import 'package:bytebeam_assessment/core/network/exception.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/trips/data/datasources/trip_datasource.dart';
import 'package:bytebeam_assessment/feature/trips/domain/entities/trip_entity.dart';
import 'package:bytebeam_assessment/feature/trips/domain/repositories/trip_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TripsRepository)
class TripsRepositoryImpl implements TripsRepository {
  final TripsDataSource _dataSource;

  TripsRepositoryImpl(this._dataSource) {
    _dataSource.startReconciliation();
  }

  @override
  Stream<Either<Failure, List<TripEntity>>> watchAll() async* {
    try {
      await for (final trips in _dataSource.watchAll()) {
        yield Right(trips.map((e) => e.toEntity()).toList());
      }
    } on DatabaseException catch (e) {
      yield Left(LocalFailue(e.toString()));
    } catch (e) {
      yield Left(LocalFailue(e.toString()));
    }
  }
}