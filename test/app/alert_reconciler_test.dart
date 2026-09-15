import 'package:bytebeam_assessment/core/database/utils/alert_reconciler.dart';
import 'package:bytebeam_assessment/core/database/utils/alert_thresholds.dart';
import 'package:flutter_test/flutter_test.dart';

const _defaultSentinel = Object();

void main() {
  final now = DateTime(2026, 1, 1, 12, 0, 0);

  AlertReading reading({
    int vehicleId = 1,
    double? soc,
    double? batteryTemp,
    Object? lastSeen = _defaultSentinel,
  }) {
    return AlertReading(
      vehicleId: vehicleId,
      soc: soc,
      batteryTemp: batteryTemp,
      lastSeen: identical(lastSeen, _defaultSentinel)
          ? now
          : lastSeen as DateTime?,
    );
  }

  OpenAlert open({
    int id = 1,
    int vehicleId = 1,
    AlertType type = AlertType.batterySoc,
    AlertSeverity severity = AlertSeverity.warning,
    AlertStatus status = AlertStatus.active,
  }) {
    return OpenAlert(
      id: id,
      vehicleId: vehicleId,
      type: type,
      severity: severity,
      status: status,
    );
  }

  group('opening new alerts', () {
    test(
      'SOC below warning threshold with no existing alert opens a warning',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 18)],
          openAlerts: [],
          now: now,
        );

        expect(mutations, hasLength(1));
        final m = mutations.single as OpenNewAlert;
        expect(m.type, AlertType.batterySoc);
        expect(m.severity, AlertSeverity.warning);
      },
    );

    test(
      'SOC below critical threshold opens critical directly, not warning first',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 5)],
          openAlerts: [],
          now: now,
        );

        final m = mutations.single as OpenNewAlert;
        expect(m.severity, AlertSeverity.critical);
      },
    );

    test(
      'battery temp above threshold opens an overheat alert independent of SOC',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 80, batteryTemp: 50)],
          openAlerts: [],
          now: now,
        );

        expect(mutations, hasLength(1));
        expect(
          (mutations.single as OpenNewAlert).type,
          AlertType.batteryOverheat,
        );
      },
    );

    test('healthy readings produce no mutations', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 80, batteryTemp: 30)],
        openAlerts: [],
        now: now,
      );

      expect(mutations, isEmpty);
    });

    test(
      'no duplicate alert opened when one is already open for the same vehicle+type',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 15)],
          openAlerts: [open(severity: AlertSeverity.warning)],
          now: now,
        );

        // Same severity as existing -> no mutation at all, definitely not
        // a second OpenNewAlert.
        expect(mutations, isEmpty);
      },
    );
  });

  group('escalation and de-escalation while active', () {
    test('active warning escalates to critical when SOC drops further', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 5)],
        openAlerts: [
          open(
            id: 7,
            severity: AlertSeverity.warning,
            status: AlertStatus.active,
          ),
        ],
        now: now,
      );

      final m = mutations.single as UpdateSeverity;
      expect(m.alertId, 7);
      expect(m.severity, AlertSeverity.critical);
    });

    test('active critical de-escalates to warning when SOC recovers a bit', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 15)],
        openAlerts: [
          open(
            id: 7,
            severity: AlertSeverity.critical,
            status: AlertStatus.active,
          ),
        ],
        now: now,
      );

      final m = mutations.single as UpdateSeverity;
      expect(m.severity, AlertSeverity.warning);
    });
  });

  group('dismissed alerts', () {
    test('escalation reactivates a dismissed warning as critical', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 5)],
        openAlerts: [
          open(
            id: 9,
            severity: AlertSeverity.warning,
            status: AlertStatus.dismissed,
          ),
        ],
        now: now,
      );

      final m = mutations.single as ReactivateAlert;
      expect(m.alertId, 9);
      expect(m.severity, AlertSeverity.critical);
    });

    test(
      'de-escalation while dismissed produces no mutation (stays dismissed)',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 15)],
          openAlerts: [
            open(
              id: 9,
              severity: AlertSeverity.critical,
              status: AlertStatus.dismissed,
            ),
          ],
          now: now,
        );

        expect(mutations, isEmpty);
      },
    );

    test('same severity while dismissed produces no mutation', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 15)],
        openAlerts: [
          open(
            id: 9,
            severity: AlertSeverity.warning,
            status: AlertStatus.dismissed,
          ),
        ],
        now: now,
      );

      expect(mutations, isEmpty);
    });
  });

  group('resolution', () {
    test('condition clearing resolves an active alert', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 90)],
        openAlerts: [open(id: 3, status: AlertStatus.active)],
        now: now,
      );

      final m = mutations.single as ResolveAlert;
      expect(m.alertId, 3);
    });

    test(
      'condition clearing resolves a DISMISSED alert too — independent of dismissal',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 90)],
          openAlerts: [open(id: 3, status: AlertStatus.dismissed)],
          now: now,
        );

        final m = mutations.single as ResolveAlert;
        expect(m.alertId, 3);
      },
    );

    test(
      'resolved alert re-triggering opens a brand new alert, not a revival',
      () {
        // Simulates: alert resolved (no longer in the "open" set passed in,
        // since resolved rows aren't fed back to the reconciler), then the
        // condition fails again on a later tick.
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 5)],
          openAlerts: const [], // resolved row is not part of "open" alerts
          now: now,
        );

        expect(mutations.single, isA<OpenNewAlert>());
      },
    );
  });

  group('staleness freezes evaluation', () {
    test(
      'stale reading with no existing alert opens nothing, even if SOC is critical',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [
            reading(
              soc: 2,
              lastSeen: now.subtract(const Duration(minutes: 30)),
            ),
          ],
          openAlerts: [],
          now: now,
        );

        expect(mutations, isEmpty);
      },
    );

    test(
      'stale reading does NOT resolve an existing alert even though soc is now null-ish/healthy',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [
            reading(
              soc: 90,
              lastSeen: now.subtract(const Duration(minutes: 30)),
            ),
          ],
          openAlerts: [open(id: 3, status: AlertStatus.active)],
          now: now,
        );

        // Losing signal must never look like "the battery recovered".
        expect(mutations, isEmpty);
      },
    );

    test('null lastSeen counts as stale', () {
      final mutations = AlertReconciler.reconcile(
        readings: [reading(soc: 2, lastSeen: null)],
        openAlerts: [],
        now: now,
      );

      expect(mutations, isEmpty);
    });

    test(
      'reading exactly at the staleness boundary is still fresh (uses > not >=)',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [
            reading(soc: 5, lastSeen: now.subtract(AlertThresholds.staleAfter)),
          ],
          openAlerts: [],
          now: now,
        );

        expect(mutations.single, isA<OpenNewAlert>());
      },
    );
  });

  group('multiple vehicles and types are independent', () {
    test('one vehicle failing does not affect another', () {
      final mutations = AlertReconciler.reconcile(
        readings: [
          reading(vehicleId: 1, soc: 5),
          reading(vehicleId: 2, soc: 90),
        ],
        openAlerts: [],
        now: now,
      );

      expect(mutations, hasLength(1));
      expect((mutations.single as OpenNewAlert).vehicleId, 1);
    });

    test(
      'SOC alert and overheat alert on the same vehicle are tracked separately',
      () {
        final mutations = AlertReconciler.reconcile(
          readings: [reading(soc: 5, batteryTemp: 50)],
          openAlerts: [],
          now: now,
        );

        expect(mutations, hasLength(2));
        final types = mutations.map((m) => m.type).toSet();
        expect(types, {AlertType.batterySoc, AlertType.batteryOverheat});
      },
    );
  });
}
