part of 'alerts_bloc.dart';

@freezed
abstract class AlertsState with _$AlertsState {
  const factory AlertsState.initial() = _Initial;
  const factory AlertsState.loading() = _Loading;
  const factory AlertsState.error(String message) = _Error;
  const factory AlertsState.loaded({
    required List<AlertEntity> alerts,
    int? justDismissedId,
  }) = _Loaded;
}
