import 'package:bytebeam_assessment/core/database/tables/geofence_event.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_event_entity.dart';

class GeofenceEventModel {
  const GeofenceEventModel({
    required this.id,
    required this.geofenceId,
    required this.vehicleId,
    required this.eventType,
    required this.eventTime,
    required this.sequenceId,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final int geofenceId;
  final int vehicleId;
  final GeofenceEventType eventType;
  final DateTime eventTime;
  final int sequenceId;
  final double latitude;
  final double longitude;

  factory GeofenceEventModel.fromLocalJson(Map<String, dynamic> json) {
    return GeofenceEventModel(
      id: (json[GeofenceEventTable.id] as num).toInt(),
      geofenceId: (json[GeofenceEventTable.geofenceId] as num).toInt(),
      vehicleId: (json[VehicleTable.id] as num).toInt(),
      eventType: GeofenceEventType.fromValue(
        json[GeofenceEventTable.eventType] as String,
      ),
      eventTime: json[GeofenceEventTable.eventTime] as DateTime,
      sequenceId: (json[GeofenceEventTable.sequenceId] as num).toInt(),
      latitude: (json[GeofenceEventTable.latitude] as num).toDouble(),
      longitude: (json[GeofenceEventTable.longitude] as num).toDouble(),
    );
  }

  GeofenceEventEntity toEntity() => GeofenceEventEntity(
        id: id,
        geofenceId: geofenceId,
        vehicleId: vehicleId,
        eventType: eventType,
        eventTime: eventTime,
        sequenceId: sequenceId,
        latitude: latitude,
        longitude: longitude,
      );
}