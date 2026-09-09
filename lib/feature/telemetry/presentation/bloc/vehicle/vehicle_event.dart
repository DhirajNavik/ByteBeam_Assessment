part of 'vehicle_bloc.dart';

@freezed
abstract class VehicleEvent with _$VehicleEvent {
  const factory VehicleEvent.fetchVehicles() = _FetchVehicles;
}
