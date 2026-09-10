import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/vehicle_model.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/vehicle_telemetry_model.dart';

abstract interface class TelemetryDataSource {
  Future<List<VehicleModel>> fetchVehicles();
  Stream<List<VehicleTelemetryModel>> watchVehicleTelemetry(
    List<int> vehicleIds,
  );
  Stream<Map<int, FleetStatus>> watchFleetStatus();
}
