import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/usecases/dismiss_alert_usecase.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/usecases/undo_dismiss_usecase.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/usecases/watch_active_alerts_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alerts_event.dart';
part 'alerts_state.dart';
part 'alerts_bloc.freezed.dart';

@injectable
class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final WatchActiveAlertsUsecase _watchActiveAlerts;
  final DismissAlertUsecase _dismissAlert;
  final UndoDismissUsecase _undoDismiss;

  AlertsBloc(
    this._watchActiveAlerts,
    this._dismissAlert,
    this._undoDismiss,
  ) : super(const AlertsState.initial()) {
    on<_Watch>(_onWatch, transformer: restartable());
    on<_Dismiss>(_onDismiss, transformer: sequential());
    on<_UndoDismiss>(_onUndoDismiss, transformer: sequential());
  }

  Future<void> _onWatch(_Watch event, Emitter<AlertsState> emit) async {
    emit(const AlertsState.loading());
    await emit.forEach(
      _watchActiveAlerts.watch(const NoParams()),
      onData: (either) => either.match(
        (failure) => AlertsState.error(failure.message),
        (alerts) => AlertsState.loaded(alerts: alerts),
      ),
      onError: (error, _) => AlertsState.error(error.toString()),
    );
  }

  Future<void> _onDismiss(_Dismiss event, Emitter<AlertsState> emit) async {
    final current = state;
    if (current is _Loaded) {
      final optimistic = current.alerts
          .where((a) => a.id != event.alertId)
          .toList();
      emit(
        current.copyWith(
          alerts: optimistic,
          justDismissedId: event.alertId,
        ),
      );
    }

    await _dismissAlert(
      DismissAlertParams(alertId: event.alertId, reason: event.reason),
    );
  }

  Future<void> _onUndoDismiss(
    _UndoDismiss event,
    Emitter<AlertsState> emit,
  ) async {
    await _undoDismiss(event.alertId);
    // The active-alerts stream will re-include the alert on its next
    // poll (undo restores status='active'); nothing to emit here.
  }
}
