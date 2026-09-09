import 'dart:async';

import 'package:bytebeam_assessment/core/database/seeds/telemetry.seeder.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'seeds/vehicle.seeder.dart';

abstract final class DuckDBSeeder {
  static Future<void> createSeed(Connection connection) async {
    await VehicleSeeder.seed(connection);
    unawaited(TelemetrySeeder.seed(connection));
  }
}
