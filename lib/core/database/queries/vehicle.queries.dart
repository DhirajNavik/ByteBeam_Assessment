import 'package:bytebeam_assessment/core/database/db_path.dart';

import '../tables/vehicle.table.dart';

abstract final class VehicleQueries {
  VehicleQueries._();

  static const String fetchAll =
      '''
    SELECT
      ${VehicleTable.id},
      ${VehicleTable.registrationNumber},
      ${VehicleTable.model}
    FROM ${DBPath.vehiclesTabel}
    ORDER BY ${VehicleTable.id}
  ''';
}
