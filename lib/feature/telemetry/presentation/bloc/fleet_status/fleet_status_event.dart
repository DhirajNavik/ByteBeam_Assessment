part of 'fleet_status_bloc.dart';

@freezed
class FleetStatusEvent with _$FleetStatusEvent {
  const factory FleetStatusEvent.watch() = _Watch;
  const factory FleetStatusEvent.stopWatching() = _StopWatching;
}
