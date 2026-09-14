import 'package:bytebeam_assessment/core/database/duck_db_migration.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'utils/db_path.dart';
import 'duck_db_schema.dart';

@module
abstract class DuckDBModule {
  @preResolve // Injectable waits for the async database initialization.
  @lazySingleton //One Database instance is created and reused.
  Future<Database> openDatabase() async {
    final databaseDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(databaseDirectory.path, DBPath.databaseName);
    return await duckdb.open(databasePath);
  }

  @preResolve
  @lazySingleton
  Future<Connection> provideConnection(Database database) async {
    final connection = await duckdb.connect(database);
    await DuckDBSchema.createTables(connection);
    await DuckDBMigration.migrate(connection);
    return connection;
  }
}
