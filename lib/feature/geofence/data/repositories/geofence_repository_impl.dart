import 'package:bytebeam_assessment/core/network/exception.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/geofence/data/datasources/geofence_datasource.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_event_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/repositories/geofence_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GeofenceRepository)
class GeofenceRepositoryImpl implements GeofenceRepository {
  final GeofenceDataSource _dataSource;

  GeofenceRepositoryImpl(this._dataSource) {
    _dataSource.startReconciliation();
  }

  @override
  Stream<Either<Failure, List<GeofenceEntity>>> watchAll() async* {
    try {
      await for (final models in _dataSource.watchAll()) {
        yield Right(models.map((m) => m.toEntity()).toList());
      }
    } on DatabaseException catch (e) {
      yield Left(LocalFailue(e.toString()));
    } catch (e) {
      yield Left(LocalFailue(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> create({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    try {
      await _dataSource.create(
        name: name,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(LocalFailue(e.toString()));
    } catch (e) {
      return Left(LocalFailue(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    try {
      await _dataSource.update(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(LocalFailue(e.toString()));
    } catch (e) {
      return Left(LocalFailue(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setActive({
    required int id,
    required bool isActive,
  }) async {
    try {
      await _dataSource.setActive(id: id, isActive: isActive);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(LocalFailue(e.toString()));
    } catch (e) {
      return Left(LocalFailue(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Map<int, int>>> watchVehicleCounts() async* {
    try {
      await for (final counts in _dataSource.watchVehicleCounts()) {
        yield Right(counts);
      }
    } on DatabaseException catch (e) {
      yield Left(LocalFailue(e.toString()));
    } catch (e) {
      yield Left(LocalFailue(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<VehicleGeofenceEntity>>> watchVehicleGeofences() async* {
    try {
      await for (final memberships in _dataSource.watchVehicleGeofences()) {
        yield Right(memberships);
      }
    } on DatabaseException catch (e) {
      yield Left(LocalFailue(e.toString()));
    } catch (e) {
      yield Left(LocalFailue(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GeofenceEventEntity>>> fetchEventsForVehicle(
    int vehicleId,
  ) async {
    try {
      final events = await _dataSource.fetchEventsForVehicle(vehicleId);
      return Right(events.map((e) => e.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(LocalFailue(e.toString()));
    } catch (e) {
      return Left(LocalFailue(e.toString()));
    }
  }
}