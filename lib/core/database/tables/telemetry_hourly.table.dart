import 'package:bytebeam_assessment/core/database/utils/db_path.dart';

import 'vehicle.table.dart';


abstract final class TelemetryHourlyTable {
  TelemetryHourlyTable._();

  static const String bucket = 'bucket_hour';
  static const String socMin = 'soc_min';
  static const String socMax = 'soc_max';
  static const String socAvg = 'soc_avg';
  static const String speedMax = 'speed_max';
  static const String batteryTempMax = 'battery_temp_max';
  static const String odometerEnd = 'odometer_end';
  static const String sampleCount = 'sample_count';

  static const String createTable =
      '''
    CREATE TABLE IF NOT EXISTS ${DBPath.telemetryHourlyTable} (
      ${VehicleTable.id} INTEGER NOT NULL,
      $bucket TIMESTAMP NOT NULL,
      $socMin DOUBLE,
      $socMax DOUBLE,
      $socAvg DOUBLE,
      $speedMax DOUBLE,
      $batteryTempMax DOUBLE,
      $odometerEnd DOUBLE,
      $sampleCount BIGINT NOT NULL,

      PRIMARY KEY (${VehicleTable.id}, $bucket)
    )
  ''';
}