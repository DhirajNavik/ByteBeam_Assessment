part of 'alerts_bloc.dart';

@freezed
class AlertsEvent with _$AlertsEvent {
  const factory AlertsEvent.watch() = _Watch;

  const factory AlertsEvent.dismiss({
    required int alertId,
    required DismissReason reason,
  }) = _Dismiss;

  const factory AlertsEvent.undoDismiss(int alertId) = _UndoDismiss;
}
