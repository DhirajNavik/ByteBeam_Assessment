part of 'telemetry_bloc.dart';

@freezed
abstract class TelemetryEvent with _$TelemetryEvent {
  const factory TelemetryEvent.watch(List<int> vehicleIds) = _Watch;
  const factory TelemetryEvent.stopWatching() = _StopWatching;
}
