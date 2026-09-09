import 'dart:isolate';
import 'dart:math';

import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

abstract final class TelemetrySeeder {
  TelemetrySeeder._();

  static Isolate? _isolate;

  static Future<void> start(Connection connection) async {
    if (_isolate != null) {
      return;
    }

    await Isolate.spawn<Connection>(seed, connection);
  }

  static Future<void> seed(Connection connection) async {
    try {
      while (true) {
        await _appendTelemetry(connection);
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    } finally {
      await connection.dispose();
    }
  }

  static Future<void> _appendTelemetry(Connection connection) async {
    final result = await connection.query(''' 
    SELECT ${VehicleTable.id} 
      FROM ${DBPath.vehiclesTable} 
    ORDER BY ${VehicleTable.id} ''');

    final vehicles = result.fetchAll();
    await result.dispose();

    if (vehicles.isEmpty) {
      return;
    }
    final sequenceResult = await connection.query(
      ''' SELECT COALESCE(MAX(${TelemetryTable.sequenceId}), 0) FROM ${DBPath.telemetryTable} ''',
    );

    final maxSequence = (sequenceResult.fetchAll().first.first as num).toInt();
    await sequenceResult.dispose();

    final appender = await connection.append(DBPath.telemetryTable, null);

    try {
      final now = DateTime.now();
      var sequenceId = maxSequence + 1;
      for (final row in vehicles) {
        final vehicleId = (row.first as num).toInt();
        appender.append(sequenceId++);
        appender.append(vehicleId);
        appender.append(Random().nextDouble() * 100);
        appender.append(40.0);
        appender.append(30.0);
        appender.append(250.0);
        appender.append(1.0);
        appender.append(17.3850);
        appender.append(78.4867);
        appender.append(now);
        appender.append(6.7);
        appender.endRow();
      }

      appender.flush();
    } finally {
      appender.dispose();
    }
  }
}
