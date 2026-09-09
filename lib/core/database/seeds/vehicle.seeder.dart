import 'package:dart_duckdb/dart_duckdb.dart';

import '../db_path.dart';

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

  static const List<String> models = [
    'Tata Ultra EV',
    'Ashok Leyland AVTR EV',
    'Eicher Pro EV',
    'Switch EiV',
    'Volvo FM Electric',
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
        appender.append(model);

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
