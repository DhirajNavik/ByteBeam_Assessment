import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TelemetryRepository {
  Future<Either<Failure, List<VehicleEntity>>> fetchAllVehicles();
  Stream<Either<Failure, List<VehicleTelemetryEntity>>> watchVehicleTelemetry(
    List<int> ids,
  );
  Stream<Either<Failure, Map<int, FleetStatus>>> watchFleetStatus();
}
