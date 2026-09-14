import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence_event.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';

abstract final class GeofenceQuery {
  GeofenceQuery._();

  static const String fetchAll = '''
    SELECT
      ${GeofenceTable.id},
      ${GeofenceTable.name},
      ${GeofenceTable.latitude},
      ${GeofenceTable.longitude},
      ${GeofenceTable.radiusMeters},
      ${GeofenceTable.isActive},
      ${GeofenceTable.createdAt},
      ${GeofenceTable.updatedAt}
    FROM ${DBPath.geofencesTable}
    ORDER BY ${GeofenceTable.createdAt} DESC
  ''';

  static const String fetchActive = '''
    SELECT
      ${GeofenceTable.id},
      ${GeofenceTable.name},
      ${GeofenceTable.latitude},
      ${GeofenceTable.longitude},
      ${GeofenceTable.radiusMeters},
      ${GeofenceTable.isActive},
      ${GeofenceTable.createdAt},
      ${GeofenceTable.updatedAt}
    FROM ${DBPath.geofencesTable}
    WHERE ${GeofenceTable.isActive} = true
    ORDER BY ${GeofenceTable.createdAt} DESC
  ''';

  static String fetchById(int id) => '''
    SELECT
      ${GeofenceTable.id},
      ${GeofenceTable.name},
      ${GeofenceTable.latitude},
      ${GeofenceTable.longitude},
      ${GeofenceTable.radiusMeters},
      ${GeofenceTable.isActive},
      ${GeofenceTable.createdAt},
      ${GeofenceTable.updatedAt}
    FROM ${DBPath.geofencesTable}
    WHERE ${GeofenceTable.id} = $id
  ''';

  static String get nextId => '''
    SELECT COALESCE(MAX(${GeofenceTable.id}), 0) FROM ${DBPath.geofencesTable}
  ''';

  static String insert({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    required DateTime createdAt,
  }) {
    final escaped = name.replaceAll("'", "''");
    return '''
      INSERT INTO ${DBPath.geofencesTable} (
        ${GeofenceTable.id},
        ${GeofenceTable.name},
        ${GeofenceTable.latitude},
        ${GeofenceTable.longitude},
        ${GeofenceTable.radiusMeters},
        ${GeofenceTable.isActive},
        ${GeofenceTable.createdAt},
        ${GeofenceTable.updatedAt}
      ) VALUES (
        $id, '$escaped', $latitude, $longitude, $radiusMeters,
        true,
        TIMESTAMP '${createdAt.toIso8601String()}',
        TIMESTAMP '${createdAt.toIso8601String()}'
      )
    ''';
  }

  static String update({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    required DateTime updatedAt,
  }) {
    final escaped = name.replaceAll("'", "''");
    return '''
      UPDATE ${DBPath.geofencesTable}
      SET
        ${GeofenceTable.name} = '$escaped',
        ${GeofenceTable.latitude} = $latitude,
        ${GeofenceTable.longitude} = $longitude,
        ${GeofenceTable.radiusMeters} = $radiusMeters,
        ${GeofenceTable.updatedAt} = TIMESTAMP '${updatedAt.toIso8601String()}'
      WHERE ${GeofenceTable.id} = $id
    ''';
  }

  static String setActive({
    required int id,
    required bool isActive,
    required DateTime updatedAt,
  }) => '''
    UPDATE ${DBPath.geofencesTable}
    SET
      ${GeofenceTable.isActive} = $isActive,
      ${GeofenceTable.updatedAt} = TIMESTAMP '${updatedAt.toIso8601String()}'
    WHERE ${GeofenceTable.id} = $id
  ''';

  // Haversine in pure SQL — 1 degree lat ≈ 111,320 m, 1 degree lon varies by lat.
  // Using the equirectangular approximation for short distances (< 50 km):
  //   dist_m = sqrt( (Δlat * 111320)^2 + (Δlon * 111320 * cos(lat))^2 )
  // Accurate enough for geofencing at the radii we use.
  static const String vehicleCounts = '''
    WITH latest_sequence AS (
      SELECT COALESCE(MAX(sequence_id), 0) AS max_seq
      FROM ${DBPath.telemetryTable}
    ),
    latest_positions AS (
      SELECT
        t.${VehicleTable.id},
        t.${TelemetryTable.latitude}  AS lat,
        t.${TelemetryTable.longitude} AS lon,
        t.${TelemetryTable.lastSeen}
      FROM ${DBPath.telemetryTable} t
      CROSS JOIN latest_sequence ls
      WHERE t.sequence_id <= ls.max_seq
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY t.${VehicleTable.id}
        ORDER BY t.sequence_id DESC
      ) = 1
    )
    SELECT
      g.${GeofenceTable.id},
      COUNT(lp.${VehicleTable.id}) AS vehicle_count
    FROM ${DBPath.geofencesTable} g
    LEFT JOIN latest_positions lp ON (
      g.${GeofenceTable.isActive} = true
      AND (
        sqrt(
          power((lp.lat - g.${GeofenceTable.latitude}) * 111320.0, 2)
          +
          power(
            (lp.lon - g.${GeofenceTable.longitude}) * 111320.0
            * cos(radians(g.${GeofenceTable.latitude})),
            2
          )
        )
      ) <= g.${GeofenceTable.radiusMeters}
    )
    GROUP BY g.${GeofenceTable.id}
  ''';

  static const String vehicleCurrentGeofences = '''
    WITH latest_sequence AS (
      SELECT COALESCE(MAX(sequence_id), 0) AS max_seq
      FROM ${DBPath.telemetryTable}
    ),
    latest_positions AS (
      SELECT
        t.${VehicleTable.id},
        t.${TelemetryTable.latitude}  AS lat,
        t.${TelemetryTable.longitude} AS lon,
        t.${TelemetryTable.lastSeen}
      FROM ${DBPath.telemetryTable} t
      CROSS JOIN latest_sequence ls
      WHERE t.sequence_id <= ls.max_seq
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY t.${VehicleTable.id}
        ORDER BY t.sequence_id DESC
      ) = 1
    )
    SELECT
      lp.${VehicleTable.id},
      g.${GeofenceTable.id},
      g.${GeofenceTable.name}
    FROM latest_positions lp
    JOIN ${DBPath.geofencesTable} g ON (
      g.${GeofenceTable.isActive} = true
      AND lp.${TelemetryTable.lastSeen} >= NOW() - INTERVAL '10 minutes'
      AND (
        sqrt(
          power((lp.lat - g.${GeofenceTable.latitude}) * 111320.0, 2)
          +
          power(
            (lp.lon - g.${GeofenceTable.longitude}) * 111320.0
            * cos(radians(g.${GeofenceTable.latitude})),
            2
          )
        )
      ) <= g.${GeofenceTable.radiusMeters}
    )
  ''';

  static String get nextEventId => '''
    SELECT COALESCE(MAX(${GeofenceEventTable.id}), 0)
    FROM ${DBPath.geofenceEventsTable}
  ''';

  static String insertEvent({
    required int id,
    required int geofenceId,
    required int vehicleId,
    required String eventType,
    required DateTime eventTime,
    required int sequenceId,
    required double latitude,
    required double longitude,
    required DateTime createdAt,
  }) => '''
    INSERT INTO ${DBPath.geofenceEventsTable} (
      ${GeofenceEventTable.id},
      ${GeofenceEventTable.geofenceId},
      ${VehicleTable.id},
      ${GeofenceEventTable.eventType},
      ${GeofenceEventTable.eventTime},
      ${GeofenceEventTable.sequenceId},
      ${GeofenceEventTable.latitude},
      ${GeofenceEventTable.longitude},
      ${GeofenceEventTable.createdAt}
    ) VALUES (
      $id, $geofenceId, $vehicleId,
      '$eventType',
      TIMESTAMP '${eventTime.toIso8601String()}',
      $sequenceId,
      $latitude, $longitude,
      TIMESTAMP '${createdAt.toIso8601String()}'
    )
  ''';

  static String fetchEventsForVehicle(int vehicleId) => '''
    SELECT
      ${GeofenceEventTable.id},
      ${GeofenceEventTable.geofenceId},
      ${VehicleTable.id},
      ${GeofenceEventTable.eventType},
      ${GeofenceEventTable.eventTime},
      ${GeofenceEventTable.sequenceId},
      ${GeofenceEventTable.latitude},
      ${GeofenceEventTable.longitude}
    FROM ${DBPath.geofenceEventsTable}
    WHERE ${VehicleTable.id} = $vehicleId
    ORDER BY ${GeofenceEventTable.sequenceId} ASC
  ''';

  static String fetchLastEventForVehicleGeofence({
    required int vehicleId,
    required int geofenceId,
  }) => '''
    SELECT
      ${GeofenceEventTable.id},
      ${GeofenceEventTable.geofenceId},
      ${VehicleTable.id},
      ${GeofenceEventTable.eventType},
      ${GeofenceEventTable.eventTime},
      ${GeofenceEventTable.sequenceId},
      ${GeofenceEventTable.latitude},
      ${GeofenceEventTable.longitude}
    FROM ${DBPath.geofenceEventsTable}
    WHERE ${VehicleTable.id} = $vehicleId
      AND ${GeofenceEventTable.geofenceId} = $geofenceId
    ORDER BY ${GeofenceEventTable.sequenceId} DESC
    LIMIT 1
  ''';

  static const String fetchLatestPositionsForReconciliation = '''
    WITH latest_sequence AS (
      SELECT COALESCE(MAX(sequence_id), 0) AS max_seq
      FROM ${DBPath.telemetryTable}
    ),
    latest_positions AS (
      SELECT
        t.${VehicleTable.id},
        t.${TelemetryTable.latitude},
        t.${TelemetryTable.longitude},
        t.${TelemetryTable.lastSeen},
        t.sequence_id
      FROM ${DBPath.telemetryTable} t
      CROSS JOIN latest_sequence ls
      WHERE t.sequence_id <= ls.max_seq
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY t.${VehicleTable.id}
        ORDER BY t.sequence_id DESC
      ) = 1
    )
    SELECT
      lp.${VehicleTable.id},
      lp.${TelemetryTable.latitude},
      lp.${TelemetryTable.longitude},
      lp.${TelemetryTable.lastSeen},
      lp.sequence_id
    FROM latest_positions lp
    WHERE lp.${TelemetryTable.lastSeen} IS NOT NULL
  ''';
}