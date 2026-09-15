import 'package:bytebeam_assessment/core/database/queries/telemetry.query.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:flutter/foundation.dart';

final class RetentionReport {
  const RetentionReport({
    required this.rawBefore,
    required this.rawAfter,
    required this.hourlyAfter,
    required this.elapsed,
  });

  final int rawBefore;
  final int rawAfter;
  final int hourlyAfter;
  final Duration elapsed;

  int get rawDropped => rawBefore - rawAfter;

  @override
  String toString() =>
      'RetentionReport(raw: $rawBefore -> $rawAfter '
      '(dropped $rawDropped), hourly rows: $hourlyAfter, '
      'elapsed: ${elapsed.inMilliseconds}ms)';
}

/// An append-only telemetry log grows without bound, so this defines what is
/// compacted, what is dropped, and — importantly — what the app loses.
///
/// Tiers:
///   * 0 to [hotWindow]: raw packets at full resolution. Backs the readings
///     register, the OFFLINE/staleness rules, the SOC sparkline, and
///     geofence/trip reconciliation.
///   * [hotWindow] to [coldWindow]: hourly rollups only
///     (min/max/avg SOC, max speed, max battery temp, end-of-hour odometer).
///   * Beyond [coldWindow]: dropped entirely.
///
/// Never compacted, because they are the audit trail the history features
/// read and they are small: `vehicles`, `geofences` (including deactivated
/// ones — the brief requires retaining those for trip history),
/// `geofenceEvents`, `alerts`.
///
/// What the app loses after compaction:
///   * Per-packet positions older than [hotWindow] are gone, so entry/exit
///     moments cannot be re-derived from history. Geofence and trip
///     reconciliation are therefore forward-only over fresh data — which is
///     already how they work, since trips persist the geofence *event ids*
///     they were built from rather than recomputing boundaries.
///   * Sparklines older than [hotWindow] show hourly steps, not per-packet
///     detail.
///   * Odometer deltas older than [coldWindow] are unrecoverable; only the
///     current lifetime value survives on the latest raw row.
///   * Exact alert trigger timings older than [hotWindow] cannot be
///     re-computed from telemetry, though the `alerts` rows themselves
///     (including triggeredAt/resolvedAt) are kept indefinitely.
abstract final class RetentionPolicy {
  RetentionPolicy._();

  static const Duration hotWindow = Duration(days: 7);
  static const Duration coldWindow = Duration(days: 90);

  /// Runs one compaction pass. Safe to call on every app start: the rollup
  /// insert skips buckets that already exist, and the deletes are bounded by
  /// timestamp, so repeat runs converge rather than compounding.
  ///
  /// Cutoffs are computed in Dart, not with NOW(), to stay consistent with
  /// how `last_seen` is written (Dart -> native appender).
  static Future<RetentionReport> compact(Connection connection) async {
    final stopwatch = Stopwatch()..start();
    final now = DateTime.now();
    final hotCutoff = now.subtract(hotWindow);
    final coldCutoff = now.subtract(coldWindow);

    final rawBefore = await _count(connection, TelemetryQuery.rowCount);

    // Order matters: roll up before deleting, or the aggregates are lost.
    await connection.execute(TelemetryQuery.rollupHourly(before: hotCutoff));
    await connection.execute(TelemetryQuery.deleteRawBefore(before: hotCutoff));
    await connection.execute(
      TelemetryQuery.deleteHourlyBefore(before: coldCutoff),
    );

    final rawAfter = await _count(connection, TelemetryQuery.rowCount);
    final hourlyAfter = await _count(
      connection,
      TelemetryQuery.hourlyRowCount,
    );

    stopwatch.stop();

    final report = RetentionReport(
      rawBefore: rawBefore,
      rawAfter: rawAfter,
      hourlyAfter: hourlyAfter,
      elapsed: stopwatch.elapsed,
    );
    debugPrint('RETENTION: $report');
    return report;
  }

  static Future<int> _count(Connection connection, String sql) async {
    final result = await connection.query(sql);
    final count = (result.fetchAll().first.first as num).toInt();
    await result.dispose();
    return count;
  }
}