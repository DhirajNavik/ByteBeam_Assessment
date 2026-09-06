part of 'vehicle_bloc.dart';

@freezed
abstract class VehicleState with _$VehicleState {
  const factory VehicleState.initial() = _Initial;
  const factory VehicleState.loading() = _Loading;
  const factory VehicleState.error(String message) = _Error;
  const factory VehicleState.loaded({@Default([]) List<VehicleEntity> books}) =
      _Loaded;
}
