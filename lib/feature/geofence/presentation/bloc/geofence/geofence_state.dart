part of 'geofence_bloc.dart';

@freezed
abstract class GeofenceState with _$GeofenceState {
  const factory GeofenceState.initial() = _Initial;
  const factory GeofenceState.loading() = _Loading;
  const factory GeofenceState.error(String message) = _Error;
  const factory GeofenceState.loaded({
    required List<GeofenceEntity> geofences,
    @Default({}) Map<int, int> vehicleCounts,
    @Default([]) List<VehicleGeofenceEntity> vehicleGeofences,
  }) = _Loaded;
}