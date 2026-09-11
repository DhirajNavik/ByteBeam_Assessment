part of 'vehicle_details_bloc.dart';

@freezed
abstract class VehicleDetailsState with _$VehicleDetailsState {
  const factory VehicleDetailsState.initial() = _Initial;
  const factory VehicleDetailsState.loading() = _Loading;
  const factory VehicleDetailsState.error(String message) = _Error;
  const factory VehicleDetailsState.loaded({
    @Default(null) VehicleTelemetryEntity? telemetry,
    @Default([]) List<SOCHistoryEntity> socHistory,
  }) = _Loaded;
}
