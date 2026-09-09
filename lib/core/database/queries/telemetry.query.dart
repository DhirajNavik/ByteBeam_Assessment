import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/snapshot.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';

abstract final class TelemetryQuery {
  TelemetryQuery._();

  static String fetchNewTelemetry(List<int> vehicleIds) {
    if (vehicleIds.isEmpty) {
      return '''
        SELECT *
        FROM ${DBPath.telemetryTable}
        WHERE 1 = 0
      ''';
    }
    final ids = vehicleIds.join(',');

    return '''
      SELECT
        ${VehicleTable.id},
        ${TelemetryTable.soc},
        ${TelemetryTable.speed},
        ${TelemetryTable.batteryTemp},
        ${TelemetryTable.range},
        ${TelemetryTable.ignition},
        ${TelemetryTable.latitude},
        ${TelemetryTable.longitude},
        ${TelemetryTable.lastSeen}
      FROM ${DBPath.telemetryTable} t
      WHERE t.${VehicleTable.id} IN ($ids)
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY t.${VehicleTable.id}
        ORDER BY t.${TelemetryTable.sequenceId} DESC
      ) = 1
      ORDER BY t.${VehicleTable.id}
    ''';
  }
}
