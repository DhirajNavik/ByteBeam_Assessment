import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';

abstract final class VehicleQuery {
  VehicleQuery._();

  static const String fetchAllVehicles =
      '''
    SELECT
      ${VehicleTable.id},
      ${VehicleTable.registrationNumber},
      ${VehicleTable.model}
    FROM ${DBPath.vehiclesTable}
    ORDER BY ${VehicleTable.id}
  ''';

  static const String fetchAllProfiles =
      '''
    SELECT
      ${VehicleTable.id},
      ${VehicleTable.maxSpeed},
      ${VehicleTable.range}
    FROM ${DBPath.vehiclesTable}
    ORDER BY ${VehicleTable.id}
  ''';
}
