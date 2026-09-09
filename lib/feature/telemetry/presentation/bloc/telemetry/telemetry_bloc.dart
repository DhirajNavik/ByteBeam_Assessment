import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/usecases/watch_vehicle_usecase%20copy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'telemetry_event.dart';
part 'telemetry_state.dart';
part 'telemetry_bloc.freezed.dart';

@injectable
class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final WatchVehicleUsecase _usecase;

  TelemetryBloc(this._usecase) : super(const TelemetryState.initial()) {
    on<_Watch>(_onWatch, transformer: restartable());
    on<_StopWatching>((event, emit) => emit(const TelemetryState.initial()));
  }

  Future<void> _onWatch(_Watch event, Emitter<TelemetryState> emit) async {
    if (event.vehicleIds.isEmpty) {
      emit(const TelemetryState.loaded({}));
      return;
    }

    emit(const TelemetryState.loading());

    await emit.forEach<Either<Failure, List<VehicleTelemetryEntity>>>(
      _usecase.watch(event.vehicleIds),
      onData: (either) => either.match(
        (failure) => TelemetryState.error(failure.message),
        (telemetry) =>
            TelemetryState.loaded({for (final t in telemetry) t.vehicleId: t}),
      ),
      onError: (error, _) => TelemetryState.error(error.toString()),
    );
  }
}
