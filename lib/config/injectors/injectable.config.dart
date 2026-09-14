// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dart_duckdb/dart_duckdb.dart' as _i73;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/database/duck_db_module.dart' as _i799;
import '../../core/network/database_requester.dart' as _i384;
import '../../feature/alerts/data/datasource/alerts_datasource.dart' as _i567;
import '../../feature/alerts/data/datasource/alerts_local.dart' as _i542;
import '../../feature/alerts/data/repositories/alerts_repository_impl.dart'
    as _i1042;
import '../../feature/alerts/domain/repositories/alerts_repository.dart'
    as _i422;
import '../../feature/alerts/domain/usecases/dismiss_alert_usecase.dart'
    as _i496;
import '../../feature/alerts/domain/usecases/undo_dismiss_usecase.dart'
    as _i564;
import '../../feature/alerts/domain/usecases/watch_active_alerts_usecase.dart'
    as _i565;
import '../../feature/alerts/presentation/bloc/alerts/alerts_bloc.dart'
    as _i250;
import '../../feature/geofence/data/datasources/geofence_datasource.dart'
    as _i5;
import '../../feature/geofence/data/datasources/geofence_local.dart' as _i620;
import '../../feature/geofence/data/repositories/geofence_repository_impl.dart'
    as _i802;
import '../../feature/geofence/domain/repositories/geofence_repository.dart'
    as _i718;
import '../../feature/geofence/domain/usecases/create_geofence_usecase.dart'
    as _i399;
import '../../feature/geofence/domain/usecases/toggle_geofence_usecase.dart'
    as _i404;
import '../../feature/geofence/domain/usecases/update_geofence_usecase.dart'
    as _i1034;
import '../../feature/geofence/domain/usecases/watch_geofence_usecase.dart'
    as _i423;
import '../../feature/geofence/domain/usecases/watch_geofence_vehicle_count_usecase.dart'
    as _i899;
import '../../feature/geofence/presentation/bloc/geofence/geofence_bloc.dart'
    as _i229;
import '../../feature/telemetry/data/datasource/telemetry_datasource.dart'
    as _i64;
import '../../feature/telemetry/data/datasource/telemetry_local.dart' as _i862;
import '../../feature/telemetry/data/repositories/telemetry_repository_impl.dart'
    as _i701;
import '../../feature/telemetry/domain/repositories/telemetry_repository.dart'
    as _i757;
import '../../feature/telemetry/domain/usecases/fetch_vehicles_usecase.dart'
    as _i538;
import '../../feature/telemetry/domain/usecases/watch_fleet_history.dart'
    as _i382;
import '../../feature/telemetry/domain/usecases/watch_fleet_status_usecase.dart'
    as _i407;
import '../../feature/telemetry/domain/usecases/watch_vehicle_usecase%20copy.dart'
    as _i1066;
import '../../feature/telemetry/presentation/bloc/fleet_status/fleet_status_bloc.dart'
    as _i731;
import '../../feature/telemetry/presentation/bloc/telemetry/telemetry_bloc.dart'
    as _i903;
import '../../feature/telemetry/presentation/bloc/vehicle/vehicle_bloc.dart'
    as _i1062;
import '../../feature/telemetry/presentation/bloc/vehicle_details/vehicle_details_bloc.dart'
    as _i129;
import '../../feature/theme/cubit/theme_cubit.dart' as _i99;
import '../../feature/trips/data/datasources/trip_datasource.dart' as _i84;
import '../../feature/trips/data/datasources/trip_local.dart' as _i981;
import '../../feature/trips/data/repositories/trip_repository_impl.dart'
    as _i910;
import '../../feature/trips/domain/repositories/trip_repository.dart' as _i759;
import '../../feature/trips/domain/usecases/watch_trips_usecase.dart' as _i825;
import '../../feature/trips/presentation/trips/trips_bloc.dart' as _i412;
import '../routes/route.config.dart' as _i454;
import '../routes/route_exports.dart' as _i750;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final routeModule = _$RouteModule();
    final duckDBModule = _$DuckDBModule();
    gh.singleton<_i750.GoRouter>(() => routeModule.router());
    gh.singleton<_i99.ThemeCubit>(() => _i99.ThemeCubit());
    await gh.lazySingletonAsync<_i73.Database>(
      () => duckDBModule.openDatabase(),
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i73.Connection>(
      () => duckDBModule.provideConnection(gh<_i73.Database>()),
      preResolve: true,
    );
    gh.singleton<_i384.DatabaseRequester>(
      () => _i384.DatabaseRequester(gh<_i73.Connection>()),
    );
    gh.lazySingleton<_i567.AlertsDataSource>(
      () => _i542.AlertsLocalDataSourceImpl(gh<_i384.DatabaseRequester>()),
    );
    gh.lazySingleton<_i5.GeofenceDataSource>(
      () => _i620.GeofenceLocalDataSourceImpl(gh<_i384.DatabaseRequester>()),
    );
    gh.lazySingleton<_i84.TripsDataSource>(
      () => _i981.TripsLocalDataSourceImpl(gh<_i384.DatabaseRequester>()),
    );
    gh.lazySingleton<_i422.AlertsRepository>(
      () => _i1042.AlertsRepositoryImpl(gh<_i567.AlertsDataSource>()),
    );
    gh.lazySingleton<_i759.TripsRepository>(
      () => _i910.TripsRepositoryImpl(gh<_i84.TripsDataSource>()),
    );
    gh.lazySingleton<_i496.DismissAlertUsecase>(
      () => _i496.DismissAlertUsecase(gh<_i422.AlertsRepository>()),
    );
    gh.lazySingleton<_i564.UndoDismissUsecase>(
      () => _i564.UndoDismissUsecase(gh<_i422.AlertsRepository>()),
    );
    gh.lazySingleton<_i565.WatchActiveAlertsUsecase>(
      () => _i565.WatchActiveAlertsUsecase(gh<_i422.AlertsRepository>()),
    );
    gh.lazySingleton<_i64.TelemetryDataSource>(
      () => _i862.TelemetryLocalDataSourceImpl(gh<_i384.DatabaseRequester>()),
    );
    gh.factory<_i250.AlertsBloc>(
      () => _i250.AlertsBloc(
        gh<_i565.WatchActiveAlertsUsecase>(),
        gh<_i496.DismissAlertUsecase>(),
        gh<_i564.UndoDismissUsecase>(),
      ),
    );
    gh.lazySingleton<_i718.GeofenceRepository>(
      () => _i802.GeofenceRepositoryImpl(gh<_i5.GeofenceDataSource>()),
    );
    gh.lazySingleton<_i825.WatchTripsUsecase>(
      () => _i825.WatchTripsUsecase(gh<_i759.TripsRepository>()),
    );
    gh.lazySingleton<_i399.CreateGeofenceUsecase>(
      () => _i399.CreateGeofenceUsecase(gh<_i718.GeofenceRepository>()),
    );
    gh.lazySingleton<_i404.ToggleGeofenceUsecase>(
      () => _i404.ToggleGeofenceUsecase(gh<_i718.GeofenceRepository>()),
    );
    gh.lazySingleton<_i1034.UpdateGeofenceUsecase>(
      () => _i1034.UpdateGeofenceUsecase(gh<_i718.GeofenceRepository>()),
    );
    gh.lazySingleton<_i423.WatchGeofencesUsecase>(
      () => _i423.WatchGeofencesUsecase(gh<_i718.GeofenceRepository>()),
    );
    gh.lazySingleton<_i899.WatchGeofenceVehicleCountsUsecase>(
      () => _i899.WatchGeofenceVehicleCountsUsecase(
        gh<_i718.GeofenceRepository>(),
      ),
    );
    gh.lazySingleton<_i899.WatchVehicleGeofencesUsecase>(
      () => _i899.WatchVehicleGeofencesUsecase(gh<_i718.GeofenceRepository>()),
    );
    gh.lazySingleton<_i757.TelemetryRepository>(
      () => _i701.TelemetryRepositoryImpl(gh<_i64.TelemetryDataSource>()),
    );
    gh.factory<_i412.TripsBloc>(
      () => _i412.TripsBloc(gh<_i825.WatchTripsUsecase>()),
    );
    gh.factory<_i229.GeofenceBloc>(
      () => _i229.GeofenceBloc(
        gh<_i423.WatchGeofencesUsecase>(),
        gh<_i399.CreateGeofenceUsecase>(),
        gh<_i1034.UpdateGeofenceUsecase>(),
        gh<_i404.ToggleGeofenceUsecase>(),
        gh<_i899.WatchGeofenceVehicleCountsUsecase>(),
        gh<_i899.WatchVehicleGeofencesUsecase>(),
      ),
    );
    gh.lazySingleton<_i538.FetchVehiclesUsecase>(
      () => _i538.FetchVehiclesUsecase(gh<_i757.TelemetryRepository>()),
    );
    gh.lazySingleton<_i382.WatchFleetHistory>(
      () => _i382.WatchFleetHistory(gh<_i757.TelemetryRepository>()),
    );
    gh.lazySingleton<_i407.WatchFleetStatusUsecase>(
      () => _i407.WatchFleetStatusUsecase(gh<_i757.TelemetryRepository>()),
    );
    gh.lazySingleton<_i1066.WatchVehicleUsecase>(
      () => _i1066.WatchVehicleUsecase(gh<_i757.TelemetryRepository>()),
    );
    gh.factory<_i731.FleetStatusBloc>(
      () => _i731.FleetStatusBloc(gh<_i407.WatchFleetStatusUsecase>()),
    );
    gh.factory<_i1062.VehicleBloc>(
      () => _i1062.VehicleBloc(gh<_i538.FetchVehiclesUsecase>()),
    );
    gh.factory<_i129.VehicleDetailsBloc>(
      () => _i129.VehicleDetailsBloc(
        gh<_i1066.WatchVehicleUsecase>(),
        gh<_i382.WatchFleetHistory>(),
      ),
    );
    gh.factory<_i903.TelemetryBloc>(
      () => _i903.TelemetryBloc(gh<_i1066.WatchVehicleUsecase>()),
    );
    return this;
  }
}

class _$RouteModule extends _i454.RouteModule {}

class _$DuckDBModule extends _i799.DuckDBModule {}
