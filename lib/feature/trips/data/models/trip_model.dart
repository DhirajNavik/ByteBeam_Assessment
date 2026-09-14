import 'package:bytebeam_assessment/core/database/tables/trip.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/feature/trips/domain/entities/trip_entity.dart';

class TripModel {
  const TripModel({
    required this.id,
    required this.vehicleId,
    required this.originGeofenceId,
    required this.originGeofenceName,
    required this.destinationGeofenceId,
    required this.destinationGeofenceName,
    required this.startedAt,
    required this.completedAt,
    required this.status,
  });

  final int id;
  final int vehicleId;
  final int originGeofenceId;
  final String originGeofenceName;
  final int? destinationGeofenceId;
  final String? destinationGeofenceName;
  final DateTime startedAt;
  final DateTime? completedAt;
  final TripStatus status;

  factory TripModel.fromLocalJson(Map<String, dynamic> json) {
    return TripModel(
      id: (json[TripTable.id] as num).toInt(),
      vehicleId: (json[VehicleTable.id] as num).toInt(),
      originGeofenceId: (json[TripTable.originGeofenceId] as num).toInt(),
      originGeofenceName: json['origin_name'] as String,
      destinationGeofenceId:
          (json[TripTable.destinationGeofenceId] as num?)?.toInt(),
      destinationGeofenceName: json['destination_name'] as String?,
      startedAt: json[TripTable.startedAt] as DateTime,
      completedAt: json[TripTable.completedAt] as DateTime?,
      status: TripStatus.fromValue(json[TripTable.status] as String),
    );
  }

  TripEntity toEntity() => TripEntity(
    id: id,
    vehicleId: vehicleId,
    originGeofenceId: originGeofenceId,
    originGeofenceName: originGeofenceName,
    destinationGeofenceId: destinationGeofenceId,
    destinationGeofenceName: destinationGeofenceName,
    startedAt: startedAt,
    completedAt: completedAt,
    status: status,
  );
}