

import 'package:bytebeam_assessment/config/injectors/injectable.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/bloc/alerts/alerts_bloc.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/pages/alerts_view.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/bloc/geofence/geofence_bloc.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/pages/geofence_view.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/pages/details_view.dart';
import 'package:bytebeam_assessment/feature/trips/presentation/pages/trips_view.dart';
import 'package:bytebeam_assessment/feature/trips/presentation/trips/trips_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'route_exports.dart';
part 'app_routes.dart';

@module
abstract class RouteModule {

  @singleton
  GoRouter router() {
    return GoRouter(
      navigatorKey: AppRouteConfig.rootNavigatorKey,
      initialLocation: AppRoutePath.initialPage.path,
      routes: AppRoutes.routes,
    );
  }
}

class AppRouteConfig {
  AppRouteConfig._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
}
