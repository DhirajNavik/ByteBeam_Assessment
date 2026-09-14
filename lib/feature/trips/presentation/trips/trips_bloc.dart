import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/trips/domain/entities/trip_entity.dart';
import 'package:bytebeam_assessment/feature/trips/domain/usecases/watch_trips_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trips_event.dart';
part 'trips_state.dart';
part 'trips_bloc.freezed.dart';

@injectable
class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final WatchTripsUsecase _watchTrips;

  TripsBloc(this._watchTrips) : super(const TripsState.initial()) {
    on<_Watch>(_onWatch, transformer: restartable());
  }

  Future<void> _onWatch(_Watch event, Emitter<TripsState> emit) async {
    emit(const TripsState.loading());
    await emit.forEach(
      _watchTrips.watch(const NoParams()),
      onData: (either) => either.match(
        (failure) => TripsState.error(failure.message),
        (trips) => TripsState.loaded(trips: trips),
      ),
      onError: (error, _) => TripsState.error(error.toString()),
    );
  }
}