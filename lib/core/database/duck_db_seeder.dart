import 'dart:async';

import 'package:dart_duckdb/dart_duckdb.dart';
import 'seeds/vehicle.seeder.dart';

abstract final class DuckDBSeeder {
  static final _seedCompleter = Completer<void>();
  static Future<void> get seedingComplete => _seedCompleter.future;

  static Future<void> createSeed(Connection connection) async {
    await VehicleSeeder.seed(connection);
  }
}
