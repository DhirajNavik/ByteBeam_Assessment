part of 'vehicle_details_bloc.dart';

@freezed
abstract class VehicleDetailsEvent with _$VehicleDetailsEvent {
  const factory VehicleDetailsEvent.watch({required int vehicleId}) = _Watch;
  const factory VehicleDetailsEvent.watchHistory({required int vehicleId}) = _WatchHistory;

  const factory VehicleDetailsEvent.stopWatching() = _StopWatching;
}
