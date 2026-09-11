import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/soc_history_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/usecases/watch_fleet_history.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/usecases/watch_vehicle_usecase%20copy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_details_event.dart';
part 'vehicle_details_state.dart';
part 'vehicle_details_bloc.freezed.dart';

@injectable
class VehicleDetailsBloc
    extends Bloc<VehicleDetailsEvent, VehicleDetailsState> {
  final WatchVehicleUsecase _watchVehicleUsecase;
  final WatchFleetHistory _watchFleetHistory;

  VehicleDetailsBloc(this._watchVehicleUsecase, this._watchFleetHistory)
    : super(const VehicleDetailsState.initial()) {
    on<_Watch>(_onWatch, transformer: restartable());
    on<_WatchHistory>(_onWatchHistory, transformer: restartable());

    on<_StopWatching>(_onStopWatching);
  }

  Future<void> _onWatch(_Watch event, Emitter<VehicleDetailsState> emit) async {
    emit(const VehicleDetailsState.loading());

    await emit.forEach(
      _watchVehicleUsecase.watch([event.vehicleId]),
      onData: (either) {
        return either.match(
          (failure) {
            return VehicleDetailsState.error(failure.message);
          },
          (telemetryList) {
            if (telemetryList.isEmpty) {
              return const VehicleDetailsState.error(
                'No telemetry found for this vehicle',
              );
            }

            final telemetry = telemetryList.first;

            final currentState = state;

            if (currentState is _Loaded) {
              return currentState.copyWith(telemetry: telemetry);
            }

            return VehicleDetailsState.loaded(
              telemetry: telemetry,
              socHistory: const [],
            );
          },
        );
      },
      onError: (error, stackTrace) {
        return VehicleDetailsState.error(error.toString());
      },
    );
  }

  void _onStopWatching(_StopWatching event, Emitter<VehicleDetailsState> emit) {
    emit(const VehicleDetailsState.initial());
  }

  FutureOr<void> _onWatchHistory(
    _WatchHistory event,
    Emitter<VehicleDetailsState> emit,
  ) async {
    await emit.forEach(
      _watchFleetHistory.watch(event.vehicleId),
      onData: (either) => either.match(
        (failure) {
          return VehicleDetailsState.error(failure.message);
        },
        (history) {
          final currentState = state;

          if (currentState is _Loaded) {
            return currentState.copyWith(socHistory: history);
          }

          return VehicleDetailsState.loaded(
            telemetry: null,
            socHistory: history,
          );
        },
      ),
      onError: (error, _) => VehicleDetailsState.error(error.toString()),
    );
  }
}
