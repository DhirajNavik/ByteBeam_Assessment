import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/trips/domain/entities/trip_entity.dart';
import 'package:bytebeam_assessment/feature/trips/domain/repositories/trip_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class WatchTripsUsecase extends UseCase<List<TripEntity>, NoParams> {
  final TripsRepository _repository;

  WatchTripsUsecase(this._repository);

  @override
  Stream<Either<Failure, List<TripEntity>>> watch(NoParams params) =>
      _repository.watchAll();
}