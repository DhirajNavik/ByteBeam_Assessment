part of 'fleet_status_bloc.dart';

@freezed
abstract class FleetStatusState with _$FleetStatusState {
  const factory FleetStatusState.initial() = _Initial;
  const factory FleetStatusState.loading() = _Loading;

  const factory FleetStatusState.loaded(Map<int, FleetStatus> statusByVehicleId) = _Loaded;
  const factory FleetStatusState.error(String message) = _Error;
}