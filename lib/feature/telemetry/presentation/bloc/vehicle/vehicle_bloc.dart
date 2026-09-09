import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/usecases/fetch_vehicles_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';
part 'vehicle_bloc.freezed.dart';

@injectable
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final FetchVehiclesUsecase _fetchVehicleUseCase;

  VehicleBloc(this._fetchVehicleUseCase) : super(const VehicleState.initial()) {
    on<_FetchVehicles>(_onFetchVehicles);
  }

  FutureOr<void> _onFetchVehicles(
    _FetchVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    if (state is _Initial) {
      emit(const VehicleState.loading());
    }

    final result = await _fetchVehicleUseCase(const NoParams());
    result.match(
      (failure) => emit(VehicleState.error(failure.message)),
      (vehicles) => emit(VehicleState.loaded(vehicles: vehicles)),
    );
  }
}
