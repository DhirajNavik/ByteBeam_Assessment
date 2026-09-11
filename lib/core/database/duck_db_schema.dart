import 'package:bytebeam_assessment/core/database/tables/alert.table.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

import 'tables/vehicle.table.dart';

abstract final class DuckDBSchema {
  DuckDBSchema._();

  static Future<void> createTables(Connection connection) async {
    await connection.execute(VehicleTable.createTable);
    await connection.execute(TelemetryTable.createTable);
    await connection.execute(AlertTable.createTable);
  }
}
