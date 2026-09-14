import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence_event.table.dart';
import 'package:bytebeam_assessment/core/database/utils/db_path.dart';

abstract final class TripTable {
  TripTable._();

  static const String id = 'trip_id';
  static const String originGeofenceId = 'origin_geofence_id';
  static const String destinationGeofenceId = 'destination_geofence_id';
  static const String originEventId = 'origin_event_id';
  static const String destinationEventId = 'destination_event_id';
  static const String startedAt = 'started_at';
  static const String completedAt = 'completed_at';
  static const String status = 'status';
  static const String updatedAt = 'updated_at';

  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS ${DBPath.tripsTable} (
      $id INTEGER PRIMARY KEY NOT NULL,
      ${VehicleTable.id} INTEGER NOT NULL,
      $originGeofenceId INTEGER NOT NULL,
      $destinationGeofenceId INTEGER,
      $originEventId INTEGER NOT NULL,
      $destinationEventId INTEGER,
      $startedAt TIMESTAMP NOT NULL,
      $completedAt TIMESTAMP,
      $status VARCHAR NOT NULL,
      $updatedAt TIMESTAMP NOT NULL,

      FOREIGN KEY (${VehicleTable.id}) REFERENCES ${DBPath.vehiclesTable}(${VehicleTable.id}),
      FOREIGN KEY ($originGeofenceId) REFERENCES ${DBPath.geofencesTable}(${GeofenceTable.id}),
      FOREIGN KEY ($destinationGeofenceId) REFERENCES ${DBPath.geofencesTable}(${GeofenceTable.id}),
      FOREIGN KEY ($originEventId) REFERENCES ${DBPath.geofenceEventsTable}(${GeofenceEventTable.id}),
      FOREIGN KEY ($destinationEventId) REFERENCES ${DBPath.geofenceEventsTable}(${GeofenceEventTable.id})
    )
  ''';
}