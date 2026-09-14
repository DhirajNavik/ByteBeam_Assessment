import 'package:bytebeam_assessment/core/database/utils/db_path.dart';
 
abstract final class GeofenceTable {
  GeofenceTable._();
 
  static const String id = 'geofence_id';
  static const String name = 'name';
  static const String latitude = 'lat';
  static const String longitude = 'lon';
  static const String radiusMeters = 'radius_m';
  static const String isActive = 'is_active';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
 
  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS ${DBPath.geofencesTable} (
      $id INTEGER PRIMARY KEY NOT NULL,
      $name VARCHAR NOT NULL,
      $latitude DOUBLE NOT NULL,
      $longitude DOUBLE NOT NULL,
      $radiusMeters DOUBLE NOT NULL,
      $isActive BOOLEAN NOT NULL DEFAULT true,
      $createdAt TIMESTAMP NOT NULL,
      $updatedAt TIMESTAMP NOT NULL
    )
  ''';
}
 