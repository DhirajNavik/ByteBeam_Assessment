import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/params/update_geofence_params.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/repositories/geofence_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';



@lazySingleton
final class UpdateGeofenceUsecase extends UseCase<Unit, UpdateGeofenceParams> {
  final GeofenceRepository _repository;

  UpdateGeofenceUsecase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateGeofenceParams params) =>
      _repository.update(
        id: params.id,
        name: params.name,
        latitude: params.latitude,
        longitude: params.longitude,
        radiusMeters: params.radiusMeters,
      );
}