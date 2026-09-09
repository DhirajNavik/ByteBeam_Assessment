import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/snapshot.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';

abstract final class VehicleQuery {
  VehicleQuery._();

  static const String fetchAll =
      '''
    SELECT
      v.${VehicleTable.id},
      v.${VehicleTable.registrationNumber},
      v.${VehicleTable.model},
      s.${TelemetryTable.soc},
      s.${TelemetryTable.speed},
      s.${TelemetryTable.batteryTemp},
      s.${TelemetryTable.range},
      s.${TelemetryTable.ignition},
      s.${TelemetryTable.latitude},
      s.${TelemetryTable.longitude},
      s.${TelemetryTable.lastSeen}
    FROM ${DBPath.vehiclesTable} v
    LEFT JOIN ${DBPath.snapshotTable} s
      ON v.${VehicleTable.id} = s.${VehicleTable.id}
    ORDER BY v.${VehicleTable.id}
  ''';
}
