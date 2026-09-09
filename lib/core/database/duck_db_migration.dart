import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

abstract final class DuckDBMigration {
  DuckDBMigration._();

  static Future<void> migrate(Connection connection) async {
    final result = await connection.query(
      ''' SELECT column_name FROM information_schema.columns WHERE table_name ='${DBPath.telemetryTable}' AND column_name = '${TelemetryTable.odometer}' ''',
    );

    final columns = result.fetchAll();
    await result.dispose();
    if (columns.isNotEmpty) {
      return;
    }

    await connection.query(
      ''' ALTER TABLE ${DBPath.telemetryTable} ADD COLUMN ${TelemetryTable.odometer} DOUBLE ''',
    );

  }
}
