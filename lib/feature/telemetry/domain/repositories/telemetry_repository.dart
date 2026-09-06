import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TelemetryRepository {
  Future<Either<Failure, List<VehicleEntity>>> fetchAllVehicles();
}
