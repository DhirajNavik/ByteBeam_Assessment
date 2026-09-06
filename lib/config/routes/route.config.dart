

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
