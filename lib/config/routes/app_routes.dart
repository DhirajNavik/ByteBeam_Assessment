part of 'route.config.dart';

class AppRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => serviceLocator<AlertsBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutePath.initialPage.path,
          name: AppRoutePath.initialPage.pathName,
          builder: (_, _) => FleetHomePage(),
        ),

        GoRoute(
          path: AppRoutePath.detailsPage.path,
          name: AppRoutePath.detailsPage.pathName,
          builder: (context, state) {
            final vehicle = state.extra as VehicleEntity;
            return VehicleDetailPage(vehicle: vehicle);
          },
        ),

        GoRoute(
          path: AppRoutePath.alertsPage.path,
          name: AppRoutePath.alertsPage.pathName,
          builder: (_, _) => AlertsView(),
        ),
      ],
    ),
  ];
}
