import 'package:bytebeam_assessment/core/database/utils/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/alert.table.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';

abstract final class AlertQuery {
  AlertQuery._();

  /// Latest soc/battery_temp/last_seen per vehicle — exactly what
  /// [AlertReconciler] needs, and nothing it doesn't (no speed/ignition,
  /// unlike [TelemetryQuery.fetchLatestStatusAll]). Same
  /// latest-sequence-per-vehicle pattern used throughout telemetry.query.dart.
  static const String fetchLatestReadingsForReconciliation =
      '''
    WITH latest_sequence AS (
      SELECT COALESCE(MAX(${TelemetryTable.sequenceId}), 0) AS max_sequence
      FROM ${DBPath.telemetryTable}
    )
    SELECT
      t.${VehicleTable.id},
      t.${TelemetryTable.soc},
      t.${TelemetryTable.batteryTemp},
      t.${TelemetryTable.lastSeen}
    FROM ${DBPath.telemetryTable} t
    CROSS JOIN latest_sequence ls
    WHERE t.${TelemetryTable.sequenceId} <= ls.max_sequence
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY t.${VehicleTable.id}
      ORDER BY t.${TelemetryTable.sequenceId} DESC
    ) = 1
  ''';

  /// `active` and `dismissed` rows only — what the reconciler needs to
  /// diff against. `resolved` rows are history and are never fed back in.
  static const String fetchOpenAlerts =
      '''
    SELECT
      ${AlertTable.id},
      ${VehicleTable.id},
      ${AlertTable.type},
      ${AlertTable.severity},
      ${AlertTable.status}
    FROM ${DBPath.alertsTable}
    WHERE ${AlertTable.status} IN ('active', 'dismissed')
    ORDER BY ${AlertTable.id}
  ''';

  /// Everything currently visible on screen — `active` only. Dismissed
  /// alerts are intentionally excluded; they only resurface via
  /// escalation (handled by the reconciler, not by this query).
  static const String fetchActiveAlerts =
      '''
    SELECT
      ${AlertTable.id},
      ${VehicleTable.id},
      ${AlertTable.type},
      ${AlertTable.severity},
      ${AlertTable.status},
      ${AlertTable.triggeredAt},
      ${AlertTable.updatedAt}
    FROM ${DBPath.alertsTable}
    WHERE ${AlertTable.status} = 'active'
    ORDER BY ${AlertTable.severity} DESC, ${AlertTable.triggeredAt} ASC
  ''';

  static String fetchById(int alertId) =>
      '''
    SELECT
      ${AlertTable.id},
      ${VehicleTable.id},
      ${AlertTable.type},
      ${AlertTable.severity},
      ${AlertTable.status},
      ${AlertTable.triggeredAt},
      ${AlertTable.updatedAt},
      ${AlertTable.dismissedAt},
      ${AlertTable.dismissReason},
      ${AlertTable.resolvedAt}
    FROM ${DBPath.alertsTable}
    WHERE ${AlertTable.id} = $alertId
  ''';

  static String get nextId =>
      '''
    SELECT COALESCE(MAX(${AlertTable.id}), 0)
    FROM ${DBPath.alertsTable}
  ''';

  static String insert({
    required int id,
    required int vehicleId,
    required String type,
    required String severity,
    required DateTime triggeredAt,
  }) =>
      '''
    INSERT INTO ${DBPath.alertsTable} (
      ${AlertTable.id}, ${VehicleTable.id}, ${AlertTable.type},
      ${AlertTable.severity}, ${AlertTable.status},
      ${AlertTable.triggeredAt}, ${AlertTable.updatedAt}
    ) VALUES (
      $id, $vehicleId, '$type',
      '$severity', 'active',
      TIMESTAMP '${triggeredAt.toIso8601String()}',
      TIMESTAMP '${triggeredAt.toIso8601String()}'
    )
  ''';

  static String updateSeverity({
    required int alertId,
    required String severity,
    required DateTime at,
  }) =>
      '''
    UPDATE ${DBPath.alertsTable}
    SET ${AlertTable.severity} = '$severity',
        ${AlertTable.updatedAt} = TIMESTAMP '${at.toIso8601String()}'
    WHERE ${AlertTable.id} = $alertId
  ''';

  static String reactivate({
    required int alertId,
    required String severity,
    required DateTime at,
  }) =>
      '''
    UPDATE ${DBPath.alertsTable}
    SET ${AlertTable.status} = 'active',
        ${AlertTable.severity} = '$severity',
        ${AlertTable.updatedAt} = TIMESTAMP '${at.toIso8601String()}',
        ${AlertTable.dismissedAt} = NULL,
        ${AlertTable.dismissReason} = NULL
    WHERE ${AlertTable.id} = $alertId
  ''';

  static String resolve({required int alertId, required DateTime at}) =>
      '''
    UPDATE ${DBPath.alertsTable}
    SET ${AlertTable.status} = 'resolved',
        ${AlertTable.resolvedAt} = TIMESTAMP '${at.toIso8601String()}',
        ${AlertTable.updatedAt} = TIMESTAMP '${at.toIso8601String()}'
    WHERE ${AlertTable.id} = $alertId
  ''';

  static String dismiss({
    required int alertId,
    required String reason,
    required DateTime at,
  }) {
    // Only free-ish text field in this table; defensively escape quotes.
    final escaped = reason.replaceAll("'", "''");
    return '''
    UPDATE ${DBPath.alertsTable}
    SET ${AlertTable.status} = 'dismissed',
        ${AlertTable.dismissedAt} = TIMESTAMP '${at.toIso8601String()}',
        ${AlertTable.dismissReason} = '$escaped',
        ${AlertTable.updatedAt} = TIMESTAMP '${at.toIso8601String()}'
    WHERE ${AlertTable.id} = $alertId
  ''';
  }

  /// Reverts a dismissal within the 5s undo window. Deliberately does NOT
  /// touch severity — undo restores exactly the dismissed state, it isn't
  /// a re-evaluation.
  static String undoDismiss({required int alertId, required DateTime at}) =>
      '''
    UPDATE ${DBPath.alertsTable}
    SET ${AlertTable.status} = 'active',
        ${AlertTable.dismissedAt} = NULL,
        ${AlertTable.dismissReason} = NULL,
        ${AlertTable.updatedAt} = TIMESTAMP '${at.toIso8601String()}'
    WHERE ${AlertTable.id} = $alertId
  ''';
}
