import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
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
    required double? odometer,
    required double? latitude,
    required double? longitude,
    required DateTime? lastPingAt,
    required FleetStatus status,
  }) = _VehicleTelemetryModel;

  factory VehicleTelemetryModel.fromLocalJson(Map<String, dynamic> json) {
    final speed = (json[TelemetryTable.speed] as num?)?.toDouble();
    final lastSeen = json[TelemetryTable.lastSeen] as DateTime?;
    final ignition = (json[TelemetryTable.ignition] as num?)?.toInt();

    return VehicleTelemetryModel(
      vehicleId: json[VehicleTable.id] as int,
      soc: (json[TelemetryTable.soc] as num?)?.toDouble(),
      speed: speed,
      batteryTemp: (json[TelemetryTable.batteryTemp] as num?)?.toDouble(),
      range: (json[TelemetryTable.range] as num?)?.toDouble(),
      odometer: (json[TelemetryTable.odometer] as num?)?.toDouble(),
      latitude: (json[TelemetryTable.latitude] as num?)?.toDouble(),
      longitude: (json[TelemetryTable.longitude] as num?)?.toDouble(),
      lastPingAt: lastSeen,
      status: deriveVehicleStatus(
        ignition: ignition,
        speed: speed,
        lastSeen: lastSeen,
      ),
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
      odometer: odometer,
      latitude: latitude,
      longitude: longitude,
    );
  }
}