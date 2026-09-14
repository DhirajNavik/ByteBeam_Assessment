import 'package:bytebeam_assessment/core/database/tables/trip.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence_event.table.dart';
import 'package:bytebeam_assessment/core/database/utils/db_path.dart';

abstract final class TripQuery {
  TripQuery._();

  static const List<String> fetchAllColumns = [
    TripTable.id,
    VehicleTable.id,
    TripTable.originGeofenceId,
    'origin_name',
    TripTable.destinationGeofenceId,
    'destination_name',
    TripTable.startedAt,
    TripTable.completedAt,
    TripTable.status,
  ];

  static const String fetchAll = '''
    SELECT
      t.${TripTable.id},
      t.${VehicleTable.id},
      t.${TripTable.originGeofenceId},
      og.${GeofenceTable.name} AS origin_name,
      t.${TripTable.destinationGeofenceId},
      dg.${GeofenceTable.name} AS destination_name,
      t.${TripTable.startedAt},
      t.${TripTable.completedAt},
      t.${TripTable.status}
    FROM ${DBPath.tripsTable} t
    JOIN ${DBPath.geofencesTable} og ON og.${GeofenceTable.id} = t.${TripTable.originGeofenceId}
    LEFT JOIN ${DBPath.geofencesTable} dg ON dg.${GeofenceTable.id} = t.${TripTable.destinationGeofenceId}
    ORDER BY t.${TripTable.startedAt} DESC
  ''';

  static const String fetchUnconsumedEvents = '''
    SELECT
      ge.${GeofenceEventTable.id},
      ge.${VehicleTable.id},
      ge.${GeofenceEventTable.geofenceId},
      ge.${GeofenceEventTable.eventType},
      ge.${GeofenceEventTable.eventTime},
      ge.${GeofenceEventTable.sequenceId}
    FROM ${DBPath.geofenceEventsTable} ge
    WHERE NOT EXISTS (
      SELECT 1 FROM ${DBPath.tripsTable} t
      WHERE t.${TripTable.originEventId} = ge.${GeofenceEventTable.id}
         OR t.${TripTable.destinationEventId} = ge.${GeofenceEventTable.id}
    )
    ORDER BY ge.${VehicleTable.id}, ge.${GeofenceEventTable.sequenceId} ASC
  ''';

  static const String fetchActiveTrips = '''
    SELECT ${TripTable.id}, ${VehicleTable.id}
    FROM ${DBPath.tripsTable}
    WHERE ${TripTable.status} = 'in_progress'
  ''';

  static String get nextId => '''
    SELECT COALESCE(MAX(${TripTable.id}), 0) FROM ${DBPath.tripsTable}
  ''';

  static String insert({
    required int id,
    required int vehicleId,
    required int originGeofenceId,
    required int originEventId,
    required DateTime startedAt,
  }) => '''
    INSERT INTO ${DBPath.tripsTable} (
      ${TripTable.id}, ${VehicleTable.id}, ${TripTable.originGeofenceId},
      ${TripTable.originEventId}, ${TripTable.startedAt}, ${TripTable.status}, ${TripTable.updatedAt}
    ) VALUES (
      $id, $vehicleId, $originGeofenceId, $originEventId,
      TIMESTAMP '${startedAt.toIso8601String()}',
      'in_progress',
      TIMESTAMP '${startedAt.toIso8601String()}'
    )
  ''';

  static String complete({
    required int tripId,
    required int destinationGeofenceId,
    required int destinationEventId,
    required DateTime completedAt,
  }) => '''
    UPDATE ${DBPath.tripsTable}
    SET ${TripTable.destinationGeofenceId} = $destinationGeofenceId,
        ${TripTable.destinationEventId} = $destinationEventId,
        ${TripTable.completedAt} = TIMESTAMP '${completedAt.toIso8601String()}',
        ${TripTable.status} = 'completed',
        ${TripTable.updatedAt} = TIMESTAMP '${completedAt.toIso8601String()}'
    WHERE ${TripTable.id} = $tripId
  ''';
}