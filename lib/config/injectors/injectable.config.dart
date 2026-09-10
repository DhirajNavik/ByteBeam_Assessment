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
import '../../feature/telemetry/data/datasource/telemetry_datasource.dart'
    as _i64;
import '../../feature/telemetry/data/datasource/telemetry_local.dart' as _i862;
import '../../feature/telemetry/data/repositories/telemetry_repository_impl.dart'
    as _i701;
import '../../feature/telemetry/domain/repositories/telemetry_repository.dart'
    as _i757;
import '../../feature/telemetry/domain/usecases/fetch_vehicles_usecase.dart'
    as _i538;
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
    gh.lazySingleton<_i64.TelemetryDataSource>(
      () => _i862.TelemetryLocalDataSourceImpl(gh<_i384.DatabaseRequester>()),
    );
    gh.lazySingleton<_i757.TelemetryRepository>(
      () => _i701.TelemetryRepositoryImpl(gh<_i64.TelemetryDataSource>()),
    );
    gh.lazySingleton<_i538.FetchVehiclesUsecase>(
      () => _i538.FetchVehiclesUsecase(gh<_i757.TelemetryRepository>()),
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
    gh.factory<_i903.TelemetryBloc>(
      () => _i903.TelemetryBloc(gh<_i1066.WatchVehicleUsecase>()),
    );
    return this;
  }
}

class _$RouteModule extends _i454.RouteModule {}

class _$DuckDBModule extends _i799.DuckDBModule {}
