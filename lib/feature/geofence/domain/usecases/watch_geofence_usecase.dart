import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/repositories/geofence_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class WatchGeofencesUsecase extends UseCase<List<GeofenceEntity>, NoParams> {
  final GeofenceRepository _repository;

  WatchGeofencesUsecase(this._repository);

  @override
  Stream<Either<Failure, List<GeofenceEntity>>> watch(NoParams params) =>
      _repository.watchAll();
}