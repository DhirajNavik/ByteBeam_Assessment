import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/repositories/telemetry_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class FetchVehiclesUsecase
    implements UseCase<List<VehicleEntity>, NoParams> {
  final TelemetryRepository _repository;

  const FetchVehiclesUsecase(this._repository);

  @override
  Future<Either<Failure, List<VehicleEntity>>> call(NoParams params) {
    return _repository.fetchAllVehicles();
  }
}
