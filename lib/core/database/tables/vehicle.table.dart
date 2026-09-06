
import '../db_path.dart';

abstract final class VehicleTable {
  VehicleTable._();

  static const String id = 'vehicle_id';
  static const String registrationNumber  = 'registration_no';
  static const String model = 'model';

  static const createTable =
      '''
      CREATE TABLE IF NOT EXISTS ${DBPath.vehiclesTabel} (
        $id INTEGER PRIMARY KEY NOT NULL,
        $registrationNumber VARCHAR NOT NULL,
        $model VARCHAR NOT NULL,
      )
    ''';
}
