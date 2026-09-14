part of 'geofence_bloc.dart';

@freezed
abstract class GeofenceEvent with _$GeofenceEvent {
  const factory GeofenceEvent.watch() = _Watch;

  const factory GeofenceEvent.create({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) = _Create;

  const factory GeofenceEvent.update({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) = _Update;

  const factory GeofenceEvent.toggle({
    required int id,
    required bool isActive,
  }) = _Toggle;
}