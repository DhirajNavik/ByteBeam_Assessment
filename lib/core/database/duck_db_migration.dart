import 'package:dart_duckdb/dart_duckdb.dart';

abstract final class DuckDBMigration {
  DuckDBMigration._();

  static Future<void> migrate(Database db) async {
  }
}