import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
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
      WITH latest_sequence AS (
        SELECT COALESCE(
          MAX(${TelemetryTable.sequenceId}),
          0
        ) AS max_sequence
        FROM ${DBPath.telemetryTable}
      )
      SELECT
        t.${VehicleTable.id},
        t.${TelemetryTable.sequenceId},
        t.${TelemetryTable.soc},
        t.${TelemetryTable.speed},
        t.${TelemetryTable.batteryTemp},
        t.${TelemetryTable.range},
        t.${TelemetryTable.odometer},
        t.${TelemetryTable.ignition},
        t.${TelemetryTable.latitude},
        t.${TelemetryTable.longitude},
        t.${TelemetryTable.lastSeen}
        FROM ${DBPath.telemetryTable} t
        CROSS JOIN latest_sequence ls
        WHERE t.${VehicleTable.id} IN ($ids)
          AND t.${TelemetryTable.sequenceId} <= ls.max_sequence
        QUALIFY ROW_NUMBER() OVER (
          PARTITION BY t.${VehicleTable.id}
          ORDER BY t.${TelemetryTable.sequenceId} DESC
        ) = 1
        ORDER BY t.${VehicleTable.id}
    ''';
  }
}
