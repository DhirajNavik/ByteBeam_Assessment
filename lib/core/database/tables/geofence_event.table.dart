import 'package:bytebeam_assessment/core/database/utils/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';

abstract final class GeofenceEventTable {
  GeofenceEventTable._();

  static const String id = 'event_id';
  static const String geofenceId = 'geofence_id';
  static const String vehicleId = 'vehicle_id';
  static const String eventType = 'event_type';
  static const String eventTime = 'event_time';
  static const String sequenceId = 'sequence_id';
  static const String latitude = 'lat';
  static const String longitude = 'lon';
  static const String createdAt = 'created_at';

  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS ${DBPath.geofenceEventsTable} (
      $id INTEGER PRIMARY KEY NOT NULL,
      $geofenceId INTEGER NOT NULL,
      ${VehicleTable.id} INTEGER NOT NULL,
      $eventType VARCHAR NOT NULL,
      $eventTime TIMESTAMP NOT NULL,
      $sequenceId BIGINT NOT NULL,
      $latitude DOUBLE NOT NULL,
      $longitude DOUBLE NOT NULL,
      $createdAt TIMESTAMP NOT NULL,
      FOREIGN KEY ($geofenceId) REFERENCES ${DBPath.geofencesTable}(geofence_id),
      FOREIGN KEY (${VehicleTable.id}) REFERENCES ${DBPath.vehiclesTable}(${VehicleTable.id})
    )
  ''';
}