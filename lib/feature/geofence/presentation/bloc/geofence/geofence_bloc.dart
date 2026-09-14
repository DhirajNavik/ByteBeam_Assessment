import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/params/create_geofence_params.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/params/toggle_geofence_params.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/params/update_geofence_params.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/usecases/create_geofence_usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/usecases/toggle_geofence_usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/usecases/update_geofence_usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/usecases/watch_geofence_usecase.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/usecases/watch_geofence_vehicle_count_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'geofence_event.dart';
part 'geofence_state.dart';
part 'geofence_bloc.freezed.dart';

@injectable
class GeofenceBloc extends Bloc<GeofenceEvent, GeofenceState> {
  final WatchGeofencesUsecase _watchGeofences;
  final CreateGeofenceUsecase _createGeofence;
  final UpdateGeofenceUsecase _updateGeofence;
  final ToggleGeofenceUsecase _toggleGeofence;
  final WatchGeofenceVehicleCountsUsecase _watchCounts;
  final WatchVehicleGeofencesUsecase _watchVehicleGeofences;

  StreamSubscription<dynamic>? _countsSub;
  StreamSubscription<dynamic>? _vehicleGeoSub;

  GeofenceBloc(
    this._watchGeofences,
    this._createGeofence,
    this._updateGeofence,
    this._toggleGeofence,
    this._watchCounts,
    this._watchVehicleGeofences,
  ) : super(const GeofenceState.initial()) {
    on<_Watch>(_onWatch, transformer: restartable());
    on<_Create>(_onCreate, transformer: sequential());
    on<_Update>(_onUpdate, transformer: sequential());
    on<_Toggle>(_onToggle, transformer: sequential());
  }

  Future<void> _onWatch(_Watch event, Emitter<GeofenceState> emit) async {
    emit(const GeofenceState.loading());

    _countsSub?.cancel();
    _vehicleGeoSub?.cancel();

    _countsSub = _watchCounts.watch(const NoParams()).listen((either) {
      either.fold((_) {}, (counts) {
        final current = state;
        if (current is _Loaded) {
          emit(current.copyWith(vehicleCounts: counts));
        }
      });
    });

    _vehicleGeoSub = _watchVehicleGeofences.watch(const NoParams()).listen((either) {
      either.fold((_) {}, (memberships) {
        final current = state;
        if (current is _Loaded) {
          emit(current.copyWith(vehicleGeofences: memberships));
        }
      });
    });

    await emit.forEach(
      _watchGeofences.watch(const NoParams()),
      onData: (either) => either.match(
        (failure) => GeofenceState.error(failure.message),
        (geofences) {
          final current = state;
          if (current is _Loaded) {
            return current.copyWith(geofences: geofences);
          }
          return GeofenceState.loaded(geofences: geofences);
        },
      ),
      onError: (error, _) => GeofenceState.error(error.toString()),
    );
  }

  Future<void> _onCreate(_Create event, Emitter<GeofenceState> emit) async {
    await _createGeofence(
      CreateGeofenceParams(
        name: event.name,
        latitude: event.latitude,
        longitude: event.longitude,
        radiusMeters: event.radiusMeters,
      ),
    );
  }

  Future<void> _onUpdate(_Update event, Emitter<GeofenceState> emit) async {
    await _updateGeofence(
      UpdateGeofenceParams(
        id: event.id,
        name: event.name,
        latitude: event.latitude,
        longitude: event.longitude,
        radiusMeters: event.radiusMeters,
      ),
    );
  }

  Future<void> _onToggle(_Toggle event, Emitter<GeofenceState> emit) async {
    await _toggleGeofence(
      ToggleGeofenceParams(id: event.id, isActive: event.isActive),
    );
  }

  @override
  Future<void> close() {
    _countsSub?.cancel();
    _vehicleGeoSub?.cancel();
    return super.close();
  }
}