import 'dart:io';

import 'package:bytebeam_assessment/core/database/queries/telemetry.query.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:flutter/foundation.dart';

final class LatencyReport {
  const LatencyReport({
    required this.label,
    required this.samplesMicros,
    required this.warmupRuns,
  });

  final String label;
  final List<int> samplesMicros;
  final int warmupRuns;

  int get runs => samplesMicros.length;

  double _percentileMs(int percentile) {
    if (samplesMicros.isEmpty) return 0;
    final sorted = [...samplesMicros]..sort();
    final index =
        ((sorted.length - 1) * percentile / 100).round().clamp(0, sorted.length - 1);
    return sorted[index] / 1000;
  }

  double get p50Ms => _percentileMs(50);
  double get p95Ms => _percentileMs(95);
  double get p99Ms => _percentileMs(99);
  double get minMs => samplesMicros.isEmpty
      ? 0
      : samplesMicros.reduce((a, b) => a < b ? a : b) / 1000;
  double get maxMs => samplesMicros.isEmpty
      ? 0
      : samplesMicros.reduce((a, b) => a > b ? a : b) / 1000;

  @override
  String toString() =>
      '$label: p50=${p50Ms.toStringAsFixed(1)}ms '
      'p95=${p95Ms.toStringAsFixed(1)}ms '
      'p99=${p99Ms.toStringAsFixed(1)}ms '
      'min=${minMs.toStringAsFixed(1)}ms '
      'max=${maxMs.toStringAsFixed(1)}ms '
      '(n=$runs, warmup=$warmupRuns)';
}

final class MemoryReport {
  const MemoryReport({required this.rssBytes});

  final int rssBytes;

  double get rssMb => rssBytes / 1024 / 1024;

  @override
  String toString() => 'Dart process RSS: ${rssMb.toStringAsFixed(1)} MB '
      '(cross-check with: adb shell dumpsys meminfo <package> -> TOTAL PSS)';
}

/// Measurement harness for the section-4 numbers.
///
/// Run these in PROFILE mode (`flutter run --profile`). Debug-mode timings
/// are not meaningful — assertions are on and the VM is not optimising — and
/// the README states which mode was used.
abstract final class ScaleBenchmark {
  ScaleBenchmark._();

  static const int defaultWarmup = 10;
  static const int defaultRuns = 100;

  /// Times the fleet-list query — the one that backs the status chips and
  /// the filter counts on Fleet Home.
  ///
  /// Warmup runs are discarded so the reported numbers are warm-cache, as
  /// the brief asks ("p50 and p95, warm").
  static Future<LatencyReport> fleetListQuery(
    DatabaseRequester database, {
    int warmup = defaultWarmup,
    int runs = defaultRuns,
  }) async {
    for (var i = 0; i < warmup; i++) {
      await database.query(TelemetryQuery.fetchLatestStatusAll);
    }

    final samples = <int>[];
    for (var i = 0; i < runs; i++) {
      final stopwatch = Stopwatch()..start();
      await database.query(TelemetryQuery.fetchLatestStatusAll);
      stopwatch.stop();
      samples.add(stopwatch.elapsedMicroseconds);
    }

    final report = LatencyReport(
      label: 'FLEET_LIST_QUERY',
      samplesMicros: samples,
      warmupRuns: warmup,
    );
    debugPrint('BENCH: $report');
    return report;
  }

  /// Times the bounded SOC-history query for one vehicle, so the effect of
  /// the window + downsample is measurable rather than asserted.
  static Future<LatencyReport> socHistoryQuery(
    DatabaseRequester database, {
    required int vehicleId,
    Duration window = const Duration(days: 7),
    int warmup = defaultWarmup,
    int runs = defaultRuns,
  }) async {
    String sql() => TelemetryQuery.fetchSocHistory(
      vehicleId,
      since: DateTime.now().subtract(window),
    );

    for (var i = 0; i < warmup; i++) {
      await database.query(sql());
    }

    final samples = <int>[];
    for (var i = 0; i < runs; i++) {
      final stopwatch = Stopwatch()..start();
      await database.query(sql());
      stopwatch.stop();
      samples.add(stopwatch.elapsedMicroseconds);
    }

    final report = LatencyReport(
      label: 'SOC_HISTORY_QUERY',
      samplesMicros: samples,
      warmupRuns: warmup,
    );
    debugPrint('BENCH: $report');
    return report;
  }

  /// Resident set size of the Dart process.
  ///
  /// Note for the README: this excludes some of DuckDB's native allocation,
  /// so it under-reports. `adb shell dumpsys meminfo <package>` TOTAL PSS is
  /// the honest figure and both should be reported.
  static MemoryReport memoryAtRest() {
    final report = MemoryReport(rssBytes: ProcessInfo.currentRss);
    debugPrint('BENCH: $report');
    return report;
  }

  /// Convenience: everything at once, for a single debug tap.
  static Future<String> runAll(
    DatabaseRequester database, {
    required int sampleVehicleId,
  }) async {
    final rows = await database.query(TelemetryQuery.rowCount);
    final rowCount = (rows.first.first as num).toInt();

    final fleet = await fleetListQuery(database);
    final soc = await socHistoryQuery(
      database,
      vehicleId: sampleVehicleId,
    );
    final memory = memoryAtRest();

    final summary = [
      'rows=$rowCount',
      fleet.toString(),
      soc.toString(),
      memory.toString(),
    ].join('\n');

    debugPrint('BENCH SUMMARY:\n$summary');
    return summary;
  }
}