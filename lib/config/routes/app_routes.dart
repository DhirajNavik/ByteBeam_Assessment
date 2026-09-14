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

        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider(
              create: (_) =>
                  serviceLocator<GeofenceBloc>()
                    ..add(const GeofenceEvent.watch()),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: AppRoutePath.detailsPage.path,
              name: AppRoutePath.detailsPage.pathName,
              builder: (context, state) {
                final vehicle = state.extra as VehicleEntity;
                return VehicleDetailPage(vehicle: vehicle);
              },
            ),
            GoRoute(
              path: AppRoutePath.geofencePage.path,
              name: AppRoutePath.geofencePage.pathName,
              builder: (_, _) => GeofenceView(),
            ),
          ],
        ),

        GoRoute(
          path: AppRoutePath.alertsPage.path,
          name: AppRoutePath.alertsPage.pathName,
          builder: (_, _) => AlertsView(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutePath.tripsPage.path,
      name: AppRoutePath.tripsPage.pathName,
      builder: (_, _) => BlocProvider(
        create: (_) =>
            serviceLocator<TripsBloc>()..add(const TripsEvent.watch()),
        child: const TripsView(),
      ),
    ),
  ];
}
