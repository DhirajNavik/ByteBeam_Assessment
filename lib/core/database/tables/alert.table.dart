import '../utils/db_path.dart';
import 'vehicle.table.dart';

abstract final class AlertTable {
  AlertTable._();

  static const String id = 'alert_id';
  static const String type = 'type';
  static const String severity = 'severity';
  static const String status = 'status';
  static const String triggeredAt = 'triggered_at';
  static const String updatedAt = 'updated_at';
  static const String dismissedAt = 'dismissed_at';
  static const String dismissReason = 'dismiss_reason';
  static const String resolvedAt = 'resolved_at';

  static const String createTable =
      '''
    CREATE TABLE IF NOT EXISTS ${DBPath.alertsTable} (
      $id BIGINT PRIMARY KEY NOT NULL,
      ${VehicleTable.id} INTEGER NOT NULL,
      $type VARCHAR NOT NULL,
      $severity VARCHAR NOT NULL,
      $status VARCHAR NOT NULL,
      $triggeredAt TIMESTAMP NOT NULL,
      $updatedAt TIMESTAMP NOT NULL,
      $dismissedAt TIMESTAMP,
      $dismissReason VARCHAR,
      $resolvedAt TIMESTAMP,

      FOREIGN KEY (${VehicleTable.id})
        REFERENCES ${DBPath.vehiclesTable}(${VehicleTable.id})
    )
  ''';
}
