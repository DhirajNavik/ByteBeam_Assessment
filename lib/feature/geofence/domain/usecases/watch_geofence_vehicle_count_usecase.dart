import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/repositories/geofence_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class WatchGeofenceVehicleCountsUsecase
    extends UseCase<Map<int, int>, NoParams> {
  final GeofenceRepository _repository;

  WatchGeofenceVehicleCountsUsecase(this._repository);

  @override
  Stream<Either<Failure, Map<int, int>>> watch(NoParams params) =>
      _repository.watchVehicleCounts();
}

@lazySingleton
final class WatchVehicleGeofencesUsecase
    extends UseCase<List<VehicleGeofenceEntity>, NoParams> {
  final GeofenceRepository _repository;

  WatchVehicleGeofencesUsecase(this._repository);

  @override
  Stream<Either<Failure, List<VehicleGeofenceEntity>>> watch(NoParams params) =>
      _repository.watchVehicleGeofences();
}