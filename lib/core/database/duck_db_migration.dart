import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

abstract final class DuckDBMigration {
  DuckDBMigration._();

  static Future<void> migrate(Connection connection) async {
    await _migrateOdometerColumn(connection);
    await _migrateGeofenceRadii(connection);
  }

  static Future<void> _migrateOdometerColumn(Connection connection) async {
    final result = await connection.query(
      ''' SELECT column_name FROM information_schema.columns WHERE table_name ='${DBPath.telemetryTable}' AND column_name = '${TelemetryTable.odometer}' ''',
    );
    final columns = result.fetchAll();
    await result.dispose();
    if (columns.isNotEmpty) return;

    await connection.query(
      ''' ALTER TABLE ${DBPath.telemetryTable} ADD COLUMN ${TelemetryTable.odometer} DOUBLE ''',
    );
  }

  static Future<void> _migrateGeofenceRadii(Connection connection) async {
    final tableCheck = await connection.query(
      ''' SELECT table_name FROM information_schema.tables WHERE table_name = '${DBPath.geofencesTable}' ''',
    );
    final exists = tableCheck.fetchAll();
    await tableCheck.dispose();
    if (exists.isEmpty) return;

    final smallCheck = await connection.query(
      ''' SELECT COUNT(*) FROM ${DBPath.geofencesTable} WHERE ${GeofenceTable.radiusMeters} < 2000 AND ${GeofenceTable.isActive} = true ''',
    );
    final smallCount = (smallCheck.fetchAll().first.first as num).toInt();
    await smallCheck.dispose();

    if (smallCount == 0) return;

    await connection.query(
      ''' UPDATE ${DBPath.geofencesTable} SET ${GeofenceTable.radiusMeters} = 8000 WHERE ${GeofenceTable.radiusMeters} < 2000 AND ${GeofenceTable.isActive} = true ''',
    );
  }
}
