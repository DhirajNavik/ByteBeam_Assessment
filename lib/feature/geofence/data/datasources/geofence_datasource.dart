import 'package:bytebeam_assessment/feature/geofence/data/models/geofemce_event_model.dart';
import 'package:bytebeam_assessment/feature/geofence/data/models/geofence_model.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';

abstract interface class GeofenceDataSource {
  Stream<List<GeofenceModel>> watchAll();

  Future<void> create({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  });

  Future<void> update({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  });

  Future<void> setActive({required int id, required bool isActive});

  Stream<Map<int, int>> watchVehicleCounts();

  Stream<List<VehicleGeofenceEntity>> watchVehicleGeofences();

  Future<List<GeofenceEventModel>> fetchEventsForVehicle(int vehicleId);

  void startReconciliation();

  void stopReconciliation();
}