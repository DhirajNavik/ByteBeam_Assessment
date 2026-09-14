part of 'trips_bloc.dart';

@freezed
abstract class TripsState with _$TripsState {
  const factory TripsState.initial() = _Initial;
  const factory TripsState.loading() = _Loading;
  const factory TripsState.error(String message) = _Error;
  const factory TripsState.loaded({required List<TripEntity> trips}) = _Loaded;
}