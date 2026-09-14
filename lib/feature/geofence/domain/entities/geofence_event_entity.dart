import 'package:equatable/equatable.dart';

enum GeofenceEventType {
  entry('entry'),
  exit('exit');

  const GeofenceEventType(this.value);
  final String value;

  static GeofenceEventType fromValue(String value) =>
      GeofenceEventType.values.firstWhere((e) => e.value == value);
}

class GeofenceEventEntity extends Equatable {
  final int id;
  final int geofenceId;
  final int vehicleId;
  final GeofenceEventType eventType;
  final DateTime eventTime;
  final int sequenceId;
  final double latitude;
  final double longitude;

  const GeofenceEventEntity({
    required this.id,
    required this.geofenceId,
    required this.vehicleId,
    required this.eventType,
    required this.eventTime,
    required this.sequenceId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props =>
      [id, geofenceId, vehicleId, eventType, eventTime, sequenceId];
}