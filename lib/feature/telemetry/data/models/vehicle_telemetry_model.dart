import 'package:bytebeam_assessment/core/database/tables/snapshot.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'vehicle_telemetry_model.freezed.dart';

@freezed
abstract class VehicleTelemetryModel with _$VehicleTelemetryModel {
  const VehicleTelemetryModel._();

  const factory VehicleTelemetryModel({
    required int vehicleId,
    required double? soc,
    required double? speed,
    required double? batteryTemp,
    required double? range,
    required DateTime? lastPingAt,
    required String status,
  }) = _VehicleTelemetryModel;

  factory VehicleTelemetryModel.fromLocalJson(Map<String, dynamic> json) {
    return VehicleTelemetryModel(
      vehicleId: json[VehicleTable.id] as int,
      soc: json[TelemetryTable.soc],
      speed: json[TelemetryTable.speed],
      batteryTemp: json[TelemetryTable.batteryTemp],
      range: json[TelemetryTable.range],
      lastPingAt: json[TelemetryTable.lastSeen],
      status: "Offline",
    );
  }

  VehicleTelemetryEntity toEntity() {
    return VehicleTelemetryEntity(
      vehicleId: vehicleId,
      soc: soc,
      speed: speed,
      batteryTemp: batteryTemp,
      range: range,
      lastPingAt: lastPingAt,
      status: status,
    );
  }
}
