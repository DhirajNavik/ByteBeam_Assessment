import 'package:dart_duckdb/dart_duckdb.dart';

import 'seeds/vehicle.seeder.dart';

abstract final class DuckDBSeeder {
  static Future<void> createSeed(Connection connection) async {
    await VehicleSeeder.seed(connection);
  }
}
