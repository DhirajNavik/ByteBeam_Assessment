import 'dart:async';

import 'package:bytebeam_assessment/core/alerts/alert_reconciler.dart';
import 'package:bytebeam_assessment/core/alerts/alert_thresholds.dart';
import 'package:bytebeam_assessment/core/database/queries/alert.query.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:bytebeam_assessment/feature/alerts/data/datasource/alerts_datasource.dart';
import 'package:bytebeam_assessment/feature/alerts/data/models/alert_model.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AlertsDataSource)
class AlertsLocalDataSourceImpl implements AlertsDataSource {
  final DatabaseRequester _database;

  AlertsLocalDataSourceImpl(this._database);

  Timer? _reconcileTimer;

  @override
  void startReconciliation() {
    if (_reconcileTimer != null) return;
    // Piggybacks on the same polling cadence as watchFleetStatus/
    // watchVehicleTelemetry elsewhere in the app, rather than reacting
    // per-packet. Alerts only ever care about the *latest* fresh reading,
    // so a tick is enough — full event-time reasoning is Feature E's job.
    _reconcileTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _tick(),
    );
    unawaited(_tick());
  }

  @override
  void stopReconciliation() {
    _reconcileTimer?.cancel();
    _reconcileTimer = null;
  }

  Future<void> _tick() async {
    try {
      final readingRows = await _database.query(
        AlertQuery.fetchLatestReadingsForReconciliation,
      );
      final readings = readingRows
          .map(
            (row) => AlertReading(
              vehicleId: (row[0] as num).toInt(),
              soc: (row[1] as num?)?.toDouble(),
              batteryTemp: (row[2] as num?)?.toDouble(),
              lastSeen: row[3] as DateTime?,
            ),
          )
          .toList();

      final openRows = await _database.query(AlertQuery.fetchOpenAlerts);
      final openAlerts = openRows
          .map(
            (row) => OpenAlert(
              id: (row[0] as num).toInt(),
              vehicleId: (row[1] as num).toInt(),
              type: AlertType.fromValue(row[2] as String),
              severity: AlertSeverity.fromValue(row[3] as String),
              status: AlertStatus.fromValue(row[4] as String),
            ),
          )
          .toList();

      final mutations = AlertReconciler.reconcile(
        readings: readings,
        openAlerts: openAlerts,
        now: DateTime.now(),
      );

      if (mutations.isEmpty) return;

      // Sequential IDs allocated once per tick, same pattern as
      // TelemetrySeeder's sequence_id handling — simple and correct at
      // this write volume (at most one row per vehicle per type per tick).
      final nextIdResult = await _database.query(AlertQuery.nextId);
      var nextId = (nextIdResult.first.first as num).toInt() + 1;

      for (final mutation in mutations) {
        switch (mutation) {
          case OpenNewAlert m:
            await _database.query(
              AlertQuery.insert(
                id: nextId++,
                vehicleId: m.vehicleId,
                type: m.type.value,
                severity: m.severity.value,
                triggeredAt: m.at,
              ),
            );
          case UpdateSeverity m:
            await _database.query(
              AlertQuery.updateSeverity(
                alertId: m.alertId,
                severity: m.severity.value,
                at: m.at,
              ),
            );
          case ReactivateAlert m:
            await _database.query(
              AlertQuery.reactivate(
                alertId: m.alertId,
                severity: m.severity.value,
                at: m.at,
              ),
            );
          case ResolveAlert m:
            await _database.query(
              AlertQuery.resolve(alertId: m.alertId, at: m.at),
            );
        }
      }
    } catch (e) {
      // A missed tick just means we evaluate again in 3s against
      // whatever telemetry has landed by then — never surface this to
      // the UI as an alert-stream error.
      debugPrint('Alert reconciliation tick failed: $e');
    }
  }

  @override
  Stream<List<AlertModel>> watchActiveAlerts() async* {
    while (true) {
      final rows = await _database.query(AlertQuery.fetchActiveAlerts);
      yield rows
          .map(
            (row) => AlertModel(
              id: (row[0] as num).toInt(),
              vehicleId: (row[1] as num).toInt(),
              type: AlertType.fromValue(row[2] as String),
              severity: AlertSeverity.fromValue(row[3] as String),
              status: AlertStatus.fromValue(row[4] as String),
              triggeredAt: row[5] as DateTime,
              updatedAt: row[6] as DateTime,
            ),
          )
          .toList();
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Future<void> dismiss({
    required int alertId,
    required DismissReason reason,
  }) async {
    await _database.query(
      AlertQuery.dismiss(alertId: alertId, reason: reason.label, at: DateTime.now()),
    );
  }

  @override
  Future<void> undoDismiss(int alertId) async {
    await _database.query(
      AlertQuery.undoDismiss(alertId: alertId, at: DateTime.now()),
    );
  }
}
