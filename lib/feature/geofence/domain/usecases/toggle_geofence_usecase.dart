import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/params/toggle_geofence_params.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/repositories/geofence_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
final class ToggleGeofenceUsecase extends UseCase<Unit, ToggleGeofenceParams> {
  final GeofenceRepository _repository;

  ToggleGeofenceUsecase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleGeofenceParams params) =>
      _repository.setActive(id: params.id, isActive: params.isActive);
}