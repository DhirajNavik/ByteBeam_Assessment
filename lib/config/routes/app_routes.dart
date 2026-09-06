part of 'route.config.dart';

class AppRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: AppRoutePath.initialPage.path,
      name: AppRoutePath.initialPage.pathName,
      builder: (_, _) => DashboardView(),
    ),
  ];
}
