import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/trips/domain/entities/trip_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TripsRepository {
  Stream<Either<Failure, List<TripEntity>>> watchAll();
}