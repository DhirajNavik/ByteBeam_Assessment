import 'package:bytebeam_assessment/core/alerts/alert_thresholds.dart';
import 'package:bytebeam_assessment/core/database/tables/alert.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'alert_model.freezed.dart';

@freezed
abstract class AlertModel with _$AlertModel {
  const AlertModel._();

  const factory AlertModel({
    required int id,
    required int vehicleId,
    required AlertType type,
    required AlertSeverity severity,
    required AlertStatus status,
    required DateTime triggeredAt,
    required DateTime updatedAt,
    DateTime? dismissedAt,
    String? dismissReason,
    DateTime? resolvedAt,
  }) = _AlertModel;

  factory AlertModel.fromLocalJson(Map<String, dynamic> json) {
    return AlertModel(
      id: (json[AlertTable.id] as num).toInt(),
      vehicleId: (json[VehicleTable.id] as num).toInt(),
      type: AlertType.fromValue(json[AlertTable.type] as String),
      severity: AlertSeverity.fromValue(json[AlertTable.severity] as String),
      status: AlertStatus.fromValue(json[AlertTable.status] as String),
      triggeredAt: json[AlertTable.triggeredAt] as DateTime,
      updatedAt: json[AlertTable.updatedAt] as DateTime,
      dismissedAt: json[AlertTable.dismissedAt] as DateTime?,
      dismissReason: json[AlertTable.dismissReason] as String?,
      resolvedAt: json[AlertTable.resolvedAt] as DateTime?,
    );
  }

  AlertEntity toEntity() {
    return AlertEntity(
      id: id,
      vehicleId: vehicleId,
      type: type,
      severity: severity,
      status: status,
      triggeredAt: triggeredAt,
      updatedAt: updatedAt,
      dismissedAt: dismissedAt,
      dismissReason: dismissReason,
      resolvedAt: resolvedAt,
    );
  }
}
