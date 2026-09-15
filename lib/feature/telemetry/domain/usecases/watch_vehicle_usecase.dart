import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/repositories/telemetry_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class WatchVehicleUsecase
    extends UseCase<List<VehicleTelemetryEntity>, List<int>> {
  final TelemetryRepository _repository;

  WatchVehicleUsecase(this._repository);

  @override
  Stream<Either<Failure, List<VehicleTelemetryEntity>>> watch(List<int> params) {
    return _repository.watchVehicleTelemetry(params);
  }
}
