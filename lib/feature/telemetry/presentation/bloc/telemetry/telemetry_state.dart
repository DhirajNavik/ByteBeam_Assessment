part of 'telemetry_bloc.dart';

@freezed
abstract class TelemetryState with _$TelemetryState {

  const factory TelemetryState.initial() = _Initial;
  const factory TelemetryState.loading() = _Loading;
  const factory TelemetryState.error(String message) = _Error;

  /// vehicleId -> latest telemetry.
  const factory TelemetryState.loaded(
    Map<int, VehicleTelemetryEntity> byVehicleId,
  ) = _Loaded;
}
