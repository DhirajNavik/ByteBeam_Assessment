import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_event_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GeofenceRepository {
  Stream<Either<Failure, List<GeofenceEntity>>> watchAll();

  Future<Either<Failure, Unit>> create({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  });

  Future<Either<Failure, Unit>> update({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  });

  Future<Either<Failure, Unit>> setActive({
    required int id,
    required bool isActive,
  });

  Stream<Either<Failure, Map<int, int>>> watchVehicleCounts();

  Stream<Either<Failure, List<VehicleGeofenceEntity>>> watchVehicleGeofences();

  Future<Either<Failure, List<GeofenceEventEntity>>> fetchEventsForVehicle(
    int vehicleId,
  );
}