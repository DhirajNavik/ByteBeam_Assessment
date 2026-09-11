/// Named thresholds for Feature C alerts.
///
/// Kept in one place so the dismissible-alert reconciler and the
/// display-only verdict pills on the vehicle detail screen never drift
/// apart by editing one and forgetting the other.
abstract final class AlertThresholds {
  AlertThresholds._();

  /// SOC below this is a Warning-level "Low battery" alert.
  static const double socWarning = 20.0;

  /// SOC below this escalates the same alert to Critical
  /// ("Battery critically low"). This is NOT a second alert — see
  /// [AlertType.batterySoc].
  static const double socCritical = 10.0;

  /// Battery temperature above this is a Critical "Battery overheating"
  /// alert.
  static const double overheatCritical = 45.0;

  /// A reading older than this cannot be judged NORMAL or ALERT — it's
  /// STALE, mirroring the OFFLINE rule on Fleet Home. Stale readings are
  /// skipped by the reconciler entirely (they neither open, escalate, nor
  /// resolve an alert).
  static const Duration staleAfter = Duration(minutes: 10);
}

/// The two alert conditions from section 3-C.
///
/// Deliberately just two members: SOC-low and SOC-critically-low are one
/// escalating [batterySoc] alert, not two independent rows.
enum AlertType {
  batterySoc('battery_soc'),
  batteryOverheat('battery_overheat');

  const AlertType(this.value);
  final String value;

  static AlertType fromValue(String value) =>
      AlertType.values.firstWhere((t) => t.value == value);
}

enum AlertSeverity {
  warning('warning'),
  critical('critical');

  const AlertSeverity(this.value);
  final String value;

  static AlertSeverity fromValue(String value) =>
      AlertSeverity.values.firstWhere((s) => s.value == value);
}

/// Lifecycle of a single alert row.
///
/// - [active]: currently visible, not dismissed.
/// - [dismissed]: hidden by the user via the reason sheet; can still be
///   [resolved] by the condition clearing, or reactivated to [active] by
///   escalation (see AlertReconciler).
/// - [resolved]: the underlying condition cleared. Terminal — a later
///   re-trigger opens a brand new row rather than reviving this one, so
///   this row stays as history.
enum AlertStatus {
  active('active'),
  dismissed('dismissed'),
  resolved('resolved');

  const AlertStatus(this.value);
  final String value;

  static AlertStatus fromValue(String value) =>
      AlertStatus.values.firstWhere((s) => s.value == value);
}
