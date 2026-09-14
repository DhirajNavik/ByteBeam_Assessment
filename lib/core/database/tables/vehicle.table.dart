
import 'package:bytebeam_assessment/core/database/utils/db_path.dart';

abstract final class VehicleTable {
  VehicleTable._();

  static const String id = 'vehicle_id';
  static const String registrationNumber = 'registration_no';
  static const String model = 'model';
  static const String range = 'range';
  static const String maxSpeed = 'max_speed';

  static const createTable =
      '''
      CREATE TABLE IF NOT EXISTS ${DBPath.vehiclesTable} (
        $id INTEGER PRIMARY KEY NOT NULL,
        $registrationNumber VARCHAR NOT NULL,
        $model VARCHAR NOT NULL,
        $range DOUBLE,
        $maxSpeed DOUBLE
      )
    ''';
}
