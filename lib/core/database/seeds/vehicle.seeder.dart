import 'package:bytebeam_assessment/core/models/vehicle_model.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

import '../utils/db_path.dart';

abstract final class VehicleSeeder {
  VehicleSeeder._();

  static const int vehicleCount = 500;

  static const List<String> stateCodes = [
    'AP',
    'KA',
    'MH',
    'TN',
    'DL',
    'GJ',
    'TS',
    'KL',
    'RJ',
    'UP',
  ];

  static const List<VehicleDetails> models = [
    VehicleDetails(name: 'Tata Ultra EV', range: 300.0, maxSpeed: 80.0),
    VehicleDetails(name: 'Ashok Leyland AVTR EV', range: 350.0, maxSpeed: 90.0),
    VehicleDetails(name: 'Eicher Pro EV', range: 400.0, maxSpeed: 100.0),
    VehicleDetails(name: 'Switch EiV', range: 450.0, maxSpeed: 110.0),
    VehicleDetails(name: 'Volvo FM Electric', range: 500.0, maxSpeed: 120.0),
  ];

  static Future<void> seed(Connection connection) async {
    final result = await connection.query('''
      SELECT COUNT(*)
      FROM ${DBPath.vehiclesTable}
      ''');

    final totalVehicles = (result.fetchAll().first.first as num).toInt();

    await result.dispose();

    if (totalVehicles > 0) {
      return;
    }

    final appender = await connection.append(DBPath.vehiclesTable, null);

    try {
      for (int i = 1; i <= vehicleCount; i++) {
        final registrationNumber = generateRegistration(vehicleId: i);
        final model = models[(i - 1) % models.length];
        appender.append(i);
        appender.append(registrationNumber);
        appender.append(model.name);
        appender.append(model.range);
        appender.append(model.maxSpeed);

        appender.endRow();
      }

      appender.flush();
    } finally {
      appender.dispose();
    }
  }

  static String generateRegistration({required int vehicleId}) {
    final stateCode = stateCodes[(vehicleId - 1) % stateCodes.length];
    final rtoNumber = ((vehicleId * 37) % 99) + 1;
    final vehicleNumber = ((vehicleId * 7821) % 9000) + 1000;

    return '$stateCode'
        '${rtoNumber.toString().padLeft(2, '0')}'
        'EV'
        '$vehicleNumber';
  }
}
