import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/params/create_geofence_params.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/repositories/geofence_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';



@lazySingleton
final class CreateGeofenceUsecase extends UseCase<Unit, CreateGeofenceParams> {
  final GeofenceRepository _repository;

  CreateGeofenceUsecase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(CreateGeofenceParams params) =>
      _repository.create(
        name: params.name,
        latitude: params.latitude,
        longitude: params.longitude,
        radiusMeters: params.radiusMeters,
      );
}