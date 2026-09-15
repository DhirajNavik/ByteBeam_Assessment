import 'dart:math';

import 'package:bytebeam_assessment/core/database/queries/telemetry.query.dart';
import 'package:bytebeam_assessment/core/database/queries/vehicle.query.dart';
import 'package:bytebeam_assessment/core/database/utils/db_path.dart';
import 'package:bytebeam_assessment/core/database/utils/fleet_geo_constants.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:flutter/foundation.dart';

/// Result of one backfill run, so the caller can report real numbers rather
/// than guessing.
final class BackfillReport {
  const BackfillReport({
    required this.rowsWritten,
    required this.vehicleCount,
    required this.elapsed,
    required this.skipped,
  });

  final int rowsWritten;
  final int vehicleCount;
  final Duration elapsed;

  /// True when the table already held at least [BackfillSeeder.targetRows]
  /// rows and the run was a no-op.
  final bool skipped;

  double get rowsPerSecond =>
      elapsed.inMilliseconds == 0 ? 0 : rowsWritten / (elapsed.inMilliseconds / 1000);

  @override
  String toString() => skipped
      ? 'BackfillReport(skipped — table already at target size)'
      : 'BackfillReport(rows: $rowsWritten, vehicles: $vehicleCount, '
          'elapsed: ${elapsed.inMilliseconds}ms, '
          '${rowsPerSecond.toStringAsFixed(0)} rows/s)';
}

/// One-shot history backfill for the section-4 scale exercise.
///
/// Deliberately separate from [TelemetrySeeder]: that one simulates a *live*
/// feed on a 2s timer (~1 row/vehicle/tick), which would need ~2.8 hours of
/// uptime to reach 2M rows. This one dumps history as fast as the DuckDB
/// appender allows.
///
/// The RNG is seeded with a fixed value so repeated runs produce identical
/// data — otherwise the p50/p95 query numbers aren't comparable between runs.
abstract final class BackfillSeeder {
  BackfillSeeder._();

  /// 500 vehicles x 4000 rows = 2,000,000 rows, clearing the brief's
  /// "at least 2 million signal rows" bar.
  static const int rowsPerVehicle = 4000;

  static const int targetRows = 2000000;

  /// Rows are spread backwards across this window so `last_seen` staleness,
  /// the OFFLINE rule, and the SOC sparkline all see realistic timestamps.
  static const Duration window = Duration(days: 7);

  /// Appender is flushed every this many vehicles. Flushing per-vehicle keeps
  /// peak memory bounded without paying flush overhead on every row.
  static const int flushEveryVehicles = 10;

  static Future<int> currentRowCount(Connection connection) async {
    final result = await connection.query(
      'SELECT COUNT(*) FROM ${DBPath.telemetryTable}',
    );
    final count = (result.fetchAll().first.first as num).toInt();
    await result.dispose();
    return count;
  }

  /// Backfills history for every vehicle already present in the vehicles
  /// table. Call [VehicleSeeder.seed] first.
  ///
  /// No-ops when the table already holds [targetRows] or more, so tapping the
  /// debug action twice doesn't silently produce 4M rows and invalidate your
  /// recorded measurements. Pass `force: true` to override.
  static Future<BackfillReport> run(
    Connection connection, {
    bool force = false,
    void Function(double progress)? onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();

    final existing = await currentRowCount(connection);
    if (!force && existing >= targetRows) {
      debugPrint('Backfill skipped: telemetry already has $existing rows');
      return BackfillReport(
        rowsWritten: 0,
        vehicleCount: 0,
        elapsed: stopwatch.elapsed,
        skipped: true,
      );
    }

    final profileResult = await connection.query(VehicleQuery.fetchAllProfiles);
    final profiles = profileResult.fetchAll();
    await profileResult.dispose();

    if (profiles.isEmpty) {
      debugPrint('Backfill aborted: no vehicles seeded yet');
      return BackfillReport(
        rowsWritten: 0,
        vehicleCount: 0,
        elapsed: stopwatch.elapsed,
        skipped: false,
      );
    }

    final sequenceResult = await connection.query(
      TelemetryQuery.nextSequenceId,
    );
    var nextSequence =
        (sequenceResult.fetchAll().first.first as num).toInt() + 1;
    await sequenceResult.dispose();

    final random = Random(42); // fixed seed: reproducible measurements
    final now = DateTime.now();
    final stepMs = window.inMilliseconds ~/ rowsPerVehicle;

    var rowsWritten = 0;

    final appender = await connection.append(DBPath.telemetryTable, null);
    try {
      for (var index = 0; index < profiles.length; index++) {
        final row = profiles[index];
        final vehicleId = (row[0] as num).toInt();
        final maxSpeed = (row[1] as num).toDouble();
        final totalRange = (row[2] as num).toDouble();

        // Per-vehicle starting state. Spread SOC across the range so the
        // alert thresholds (20% warning / 10% critical) and the overheat
        // threshold all get exercised by the backfilled data.
        var soc = 8.0 + random.nextDouble() * 92;
        var odometer = random.nextDouble() * 90000 + 5000;
        var batteryTemp = 22.0 + random.nextDouble() * 20;
        var latitude = FleetGeoConstants.randomLat(random.nextDouble());
        var longitude = FleetGeoConstants.randomLon(random.nextDouble());

        for (var i = 0; i < rowsPerVehicle; i++) {
          final driving = random.nextDouble() < 0.6;
          final speed =
              driving ? maxSpeed * (0.2 + random.nextDouble() * 0.7) : 0.0;

          if (driving) {
            soc = (soc - 0.02).clamp(0.0, 100.0);
            batteryTemp = (batteryTemp + 0.01).clamp(20.0, 50.0);
            odometer += speed * 2 / 3600;

            // Random walk inside the simulated fleet's bounding box, so
            // backfilled positions land in the same world the live seeder
            // and the seeded geofences use.
            latitude = (latitude + (random.nextDouble() - 0.5) * 0.004).clamp(
              FleetGeoConstants.minLat,
              FleetGeoConstants.maxLat,
            );
            longitude = (longitude + (random.nextDouble() - 0.5) * 0.004).clamp(
              FleetGeoConstants.minLon,
              FleetGeoConstants.maxLon,
            );
          } else {
            batteryTemp = (batteryTemp - 0.02).clamp(20.0, 50.0);
          }

          // Recharge when depleted, so a 7-day history has multiple
          // discharge cycles rather than flatlining at 0.
          if (soc <= 5) soc = 85.0;

          final lastSeen = now.subtract(
            Duration(milliseconds: (rowsPerVehicle - i) * stepMs),
          );

          appender
            ..append(nextSequence++)
            ..append(vehicleId)
            ..append(soc)
            ..append(speed)
            ..append(batteryTemp)
            ..append(totalRange * (soc / 100))
            ..append(odometer)
            ..append(driving ? 1.0 : 0.0)
            ..append(latitude)
            ..append(longitude)
            ..append(lastSeen)
            ..endRow();

          rowsWritten++;
        }

        if (index % flushEveryVehicles == 0) {
          appender.flush();
        }

        onProgress?.call((index + 1) / profiles.length);

        // Yield to the event loop so the progress UI can paint instead of
        // the whole backfill blocking the isolate end-to-end.
        await Future<void>.delayed(Duration.zero);
      }

      appender.flush();
    } finally {
      appender.dispose();
    }

    stopwatch.stop();

    final report = BackfillReport(
      rowsWritten: rowsWritten,
      vehicleCount: profiles.length,
      elapsed: stopwatch.elapsed,
      skipped: false,
    );
    debugPrint('BACKFILL: $report');
    return report;
  }
}