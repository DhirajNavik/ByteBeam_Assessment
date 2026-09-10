import 'package:bloc/bloc.dart';
import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/usecases/watch_fleet_status_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fleet_status_event.dart';
part 'fleet_status_state.dart';
part 'fleet_status_bloc.freezed.dart';

@injectable
class FleetStatusBloc extends Bloc<FleetStatusEvent, FleetStatusState> {
  final WatchFleetStatusUsecase _usecase;
  FleetStatusBloc(this._usecase) : super(_Initial()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<FleetStatusState> emit) async {
    await emit.forEach(
      _usecase.watch(const NoParams()),
      onData: (either) => either.match(
        (failure) => FleetStatusState.error(failure.message),
        (statusMap) => FleetStatusState.loaded(statusMap),
      ),
      onError: (error, _) => FleetStatusState.error(error.toString()),
    );
  }
}
