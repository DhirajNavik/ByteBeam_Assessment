import '../db_path.dart';
import 'vehicle.table.dart';

abstract final class TelemetryTable {
  TelemetryTable._();
  static const String sequenceId = 'sequence_id';

  static const String soc = 'soc';
  static const String speed = 'speed';
  static const String batteryTemp = 'battery_temp';
  static const String range = 'range_km';
  static const String ignition = 'ignition';
  static const String latitude = 'lat';
  static const String longitude = 'lon';
  static const String lastSeen = 'last_seen';

  static const String createSnapshotTable =
      '''
    CREATE TABLE IF NOT EXISTS ${DBPath.snapshotTable} (
      ${VehicleTable.id} INTEGER PRIMARY KEY NOT NULL,
      $soc DOUBLE,
      $speed DOUBLE,
      $batteryTemp DOUBLE,
      $range DOUBLE,
      $ignition DOUBLE,
      $latitude DOUBLE,
      $longitude DOUBLE,
      $lastSeen TIMESTAMP,
      FOREIGN KEY (${VehicleTable.id})
        REFERENCES ${DBPath.vehiclesTable}(${VehicleTable.id})
    )
  ''';

  static const String createTelemetryTable =
      '''
    CREATE TABLE IF NOT EXISTS ${DBPath.telemetryTable} (
      $sequenceId BIGINT PRIMARY KEY NOT NULL,
      ${VehicleTable.id} INTEGER NOT NULL,
      $soc DOUBLE,
      $speed DOUBLE,
      $batteryTemp DOUBLE,
      $range DOUBLE,
      $ignition DOUBLE,
      $latitude DOUBLE,
      $longitude DOUBLE,
      $lastSeen TIMESTAMP,

      FOREIGN KEY (${VehicleTable.id})
        REFERENCES ${DBPath.vehiclesTable}(${VehicleTable.id})
    )
  ''';
}
