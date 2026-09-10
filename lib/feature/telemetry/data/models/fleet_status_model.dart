import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/utils/vehicle_status_classifier.dart';

class FleetStatusModel {
  final int vehicleId;
  final String status;

  const FleetStatusModel({required this.vehicleId, required this.status});

  factory FleetStatusModel.fromLocalJson(Map<String, dynamic> json) {
    return FleetStatusModel(
      vehicleId: json[VehicleTable.id] as int,
      status: deriveVehicleStatus(
        ignition: (json[TelemetryTable.ignition] as num?)?.toInt(),
        speed: (json[TelemetryTable.speed] as num?)?.toDouble(),
        lastSeen: json[TelemetryTable.lastSeen] as DateTime?,
      ),
    );
  }
}