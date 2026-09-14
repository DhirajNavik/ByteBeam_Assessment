import 'alert_thresholds.dart';

/// The subset of a vehicle's latest telemetry the reconciler needs.
///
/// Deliberately not [VehicleTelemetryEntity] — this file lives in `core`
/// and stays independent of `feature/telemetry`, the same way
/// `core/utils/vehicle_status.dart` takes raw values rather than a
/// feature entity. The telemetry datasource maps into this at the edge.
final class AlertReading {
  const AlertReading({
    required this.vehicleId,
    required this.soc,
    required this.batteryTemp,
    required this.lastSeen,
  });

  final int vehicleId;
  final double? soc;
  final double? batteryTemp;
  final DateTime? lastSeen;

  bool isStale(DateTime now) =>
      lastSeen == null || now.difference(lastSeen!) > AlertThresholds.staleAfter;
}

/// A currently open alert row (status `active` or `dismissed` — never
/// `resolved`; resolved rows are history and are not fed back in).
final class OpenAlert {
  const OpenAlert({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.severity,
    required this.status,
  }) : assert(
         status == AlertStatus.active || status == AlertStatus.dismissed,
         'OpenAlert must be active or dismissed, never resolved',
       );

  final int id;
  final int vehicleId;
  final AlertType type;
  final AlertSeverity severity;
  final AlertStatus status;
}

/// One change the caller should persist. Each mutation names exactly what
/// happened so the datasource can turn it into a single, obvious SQL
/// statement — the reconciler itself never touches the database.
sealed class AlertMutation {
  const AlertMutation({required this.vehicleId, required this.type});

  final int vehicleId;
  final AlertType type;
}

/// No open alert existed for this vehicle+type; the condition just
/// started failing.
final class OpenNewAlert extends AlertMutation {
  const OpenNewAlert({
    required super.vehicleId,
    required super.type,
    required this.severity,
    required this.at,
  });

  final AlertSeverity severity;
  final DateTime at;
}

/// An `active` alert's severity moved — either escalated (warning to
/// critical) or de-escalated (critical to warning) while still failing.
final class UpdateSeverity extends AlertMutation {
  const UpdateSeverity({
    required super.vehicleId,
    required super.type,
    required this.alertId,
    required this.severity,
    required this.at,
  });

  final int alertId;
  final AlertSeverity severity;
  final DateTime at;
}

/// A `dismissed` alert escalated (e.g. warning dismissed as "I am on it",
/// then SOC dropped below the critical threshold). Escalation is treated
/// as a materially new situation the person hasn't seen yet, so it comes
/// back as `active`. De-escalation while dismissed is intentionally NOT a
/// mutation — see [AlertReconciler.reconcile].
final class ReactivateAlert extends AlertMutation {
  const ReactivateAlert({
    required super.vehicleId,
    required super.type,
    required this.alertId,
    required this.severity,
    required this.at,
  });

  final int alertId;
  final AlertSeverity severity;
  final DateTime at;
}

/// The underlying condition cleared. Applies whether the alert was
/// `active` or `dismissed` — resolution is independent of dismissal per
/// spec section 3-C. Terminal: the row becomes history, never revived.
final class ResolveAlert extends AlertMutation {
  const ResolveAlert({
    required super.vehicleId,
    required super.type,
    required this.alertId,
    required this.at,
  });

  final int alertId;
  final DateTime at;
}

/// Pure function: latest readings + currently open alerts -> what should
/// change. No I/O, no wall-clock reads (the caller passes [now]), so this
/// is fully unit-testable without a database or a timer.
abstract final class AlertReconciler {
  AlertReconciler._();

  static List<AlertMutation> reconcile({
    required List<AlertReading> readings,
    required List<OpenAlert> openAlerts,
    required DateTime now,
  }) {
    final mutations = <AlertMutation>[];

    for (final reading in readings) {
      for (final type in AlertType.values) {
        final existing = _find(openAlerts, reading.vehicleId, type);

        // Staleness freezes evaluation entirely: we neither open,
        // escalate, de-escalate, nor resolve. Losing signal is not the
        // same as the battery recovering.
        if (reading.isStale(now)) continue;

        final severity = _severityFor(type, reading);

        if (severity == null) {
          if (existing != null) {
            mutations.add(
              ResolveAlert(
                vehicleId: reading.vehicleId,
                type: type,
                alertId: existing.id,
                at: now,
              ),
            );
          }
          continue;
        }

        if (existing == null) {
          mutations.add(
            OpenNewAlert(
              vehicleId: reading.vehicleId,
              type: type,
              severity: severity,
              at: now,
            ),
          );
          continue;
        }

        if (existing.status == AlertStatus.active) {
          if (severity != existing.severity) {
            mutations.add(
              UpdateSeverity(
                vehicleId: reading.vehicleId,
                type: type,
                alertId: existing.id,
                severity: severity,
                at: now,
              ),
            );
          }
          continue;
        }

        // existing.status == dismissed
        final isEscalation =
            severity.index > existing.severity.index; // warning(0) -> critical(1)
        if (isEscalation) {
          mutations.add(
            ReactivateAlert(
              vehicleId: reading.vehicleId,
              type: type,
              alertId: existing.id,
              severity: severity,
              at: now,
            ),
          );
        }
        // Same severity or de-escalation while dismissed: no mutation.
        // The person dismissed it; things staying the same or getting
        // better shouldn't re-interrupt them.
      }
    }

    return mutations;
  }

  static OpenAlert? _find(List<OpenAlert> alerts, int vehicleId, AlertType type) {
    for (final alert in alerts) {
      if (alert.vehicleId == vehicleId && alert.type == type) return alert;
    }
    return null;
  }

  /// The two SOC thresholds are one escalating alert: critical wins over
  /// warning when both are true.
  static AlertSeverity? _severityFor(AlertType type, AlertReading reading) {
    switch (type) {
      case AlertType.batterySoc:
        final soc = reading.soc;
        if (soc == null) return null;
        if (soc < AlertThresholds.socCritical) return AlertSeverity.critical;
        if (soc < AlertThresholds.socWarning) return AlertSeverity.warning;
        return null;
      case AlertType.batteryOverheat:
        final temp = reading.batteryTemp;
        if (temp == null) return null;
        if (temp > AlertThresholds.overheatCritical) return AlertSeverity.critical;
        return null;
    }
  }
}
