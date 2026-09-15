import 'package:bytebeam_assessment/core/database/tables/telemetry_hourly.table.dart';
import 'package:bytebeam_assessment/core/database/utils/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';

abstract final class TelemetryQuery {
  TelemetryQuery._();

  static const int socHistoryMaxPoints = 400;

  static String fetchLatestTelemetry(List<int> vehicleIds) {
    if (vehicleIds.isEmpty) {
      return 'SELECT * FROM ${DBPath.telemetryTable} WHERE 1 = 0';
    }
    final ids = vehicleIds.join(',');

    return '''
      WITH latest_sequence AS (
        SELECT COALESCE(
          MAX(${TelemetryTable.sequenceId}),
          0
        ) AS max_sequence
        FROM ${DBPath.telemetryTable}
      )
      SELECT
        t.${VehicleTable.id},
        t.${TelemetryTable.sequenceId},
        t.${TelemetryTable.soc},
        t.${TelemetryTable.speed},
        t.${TelemetryTable.batteryTemp},
        t.${TelemetryTable.range},
        t.${TelemetryTable.odometer},
        t.${TelemetryTable.ignition},
        t.${TelemetryTable.latitude},
        t.${TelemetryTable.longitude},
        t.${TelemetryTable.lastSeen}
        FROM ${DBPath.telemetryTable} t
        CROSS JOIN latest_sequence ls
        WHERE t.${VehicleTable.id} IN ($ids)
          AND t.${TelemetryTable.sequenceId} <= ls.max_sequence
        QUALIFY ROW_NUMBER() OVER (
          PARTITION BY t.${VehicleTable.id}
          ORDER BY t.${TelemetryTable.sequenceId} DESC
        ) = 1
        ORDER BY t.${VehicleTable.id}
    ''';
  }

  static String get nextSequenceId =>
      '''
        SELECT COALESCE(MAX(${TelemetryTable.sequenceId}), 0)
        FROM ${DBPath.telemetryTable}
  ''';

  static String get fetchLatestStatusAll =>
      '''
    WITH latest_sequence AS (
      SELECT COALESCE(MAX(${TelemetryTable.sequenceId}), 0) AS max_sequence
      FROM ${DBPath.telemetryTable}
    )
    SELECT
      t.${VehicleTable.id},
      t.${TelemetryTable.speed},
      t.${TelemetryTable.ignition},
      t.${TelemetryTable.lastSeen}
    FROM ${DBPath.telemetryTable} t
    CROSS JOIN latest_sequence ls
    WHERE t.${TelemetryTable.sequenceId} <= ls.max_sequence
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY t.${VehicleTable.id}
      ORDER BY t.${TelemetryTable.sequenceId} DESC
    ) = 1
  ''';

  static String fetchSocHistory(int vehicleId, {required DateTime since}) =>
      '''
        SELECT * FROM (
          SELECT
            MAX(${TelemetryTable.sequenceId}) AS ${TelemetryTable.sequenceId},
            AVG(${TelemetryTable.soc})        AS ${TelemetryTable.soc},
            MAX(${TelemetryTable.lastSeen})   AS ${TelemetryTable.lastSeen}
          FROM ${DBPath.telemetryTable}
          WHERE ${VehicleTable.id} = $vehicleId
            AND ${TelemetryTable.soc} IS NOT NULL
            AND ${TelemetryTable.lastSeen} IS NOT NULL
            AND ${TelemetryTable.lastSeen} >= TIMESTAMP '${since.toIso8601String()}'
          GROUP BY date_trunc('minute', ${TelemetryTable.lastSeen})
          ORDER BY ${TelemetryTable.lastSeen} DESC
          LIMIT $socHistoryMaxPoints
        )
        ORDER BY ${TelemetryTable.lastSeen} ASC
  ''';

  static String get rowCount => 'SELECT COUNT(*) FROM ${DBPath.telemetryTable}';

  static String get hourlyRowCount =>
      'SELECT COUNT(*) FROM ${DBPath.telemetryHourlyTable}';

  static String rollupHourly({required DateTime before}) =>
      '''
    INSERT INTO ${DBPath.telemetryHourlyTable} (
      ${VehicleTable.id},
      ${TelemetryHourlyTable.bucket},
      ${TelemetryHourlyTable.socMin},
      ${TelemetryHourlyTable.socMax},
      ${TelemetryHourlyTable.socAvg},
      ${TelemetryHourlyTable.speedMax},
      ${TelemetryHourlyTable.batteryTempMax},
      ${TelemetryHourlyTable.odometerEnd},
      ${TelemetryHourlyTable.sampleCount}
    )
    SELECT
      raw.${VehicleTable.id},
      date_trunc('hour', raw.${TelemetryTable.lastSeen}) AS bucket,
      MIN(raw.${TelemetryTable.soc}),
      MAX(raw.${TelemetryTable.soc}),
      AVG(raw.${TelemetryTable.soc}),
      MAX(raw.${TelemetryTable.speed}),
      MAX(raw.${TelemetryTable.batteryTemp}),
      MAX(raw.${TelemetryTable.odometer}),
      COUNT(*)
    FROM ${DBPath.telemetryTable} raw
    WHERE raw.${TelemetryTable.lastSeen} IS NOT NULL
      AND raw.${TelemetryTable.lastSeen} < TIMESTAMP '${before.toIso8601String()}'
      AND NOT EXISTS (
        SELECT 1 FROM ${DBPath.telemetryHourlyTable} h
        WHERE h.${VehicleTable.id} = raw.${VehicleTable.id}
          AND h.${TelemetryHourlyTable.bucket}
              = date_trunc('hour', raw.${TelemetryTable.lastSeen})
      )
    GROUP BY 1, 2
  ''';

  /// Drops raw rows older than [before]. Run only after [rollupHourly].
  static String deleteRawBefore({required DateTime before}) =>
      '''
    DELETE FROM ${DBPath.telemetryTable}
    WHERE ${TelemetryTable.lastSeen} IS NOT NULL
      AND ${TelemetryTable.lastSeen} < TIMESTAMP '${before.toIso8601String()}'
  ''';

  /// Drops rollup rows older than [before] — the end of the line for
  /// telemetry history.
  static String deleteHourlyBefore({required DateTime before}) =>
      '''
    DELETE FROM ${DBPath.telemetryHourlyTable}
    WHERE ${TelemetryHourlyTable.bucket} < TIMESTAMP '${before.toIso8601String()}'
  ''';
}
