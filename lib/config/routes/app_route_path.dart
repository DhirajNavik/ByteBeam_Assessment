enum AppRoutePath {
  initialPage(path: "/initialPage", pathName: "initialPage"),
  detailsPage(path: "/detailsPage", pathName: "detailsPage"),
  alertsPage(path: "/alertsPage", pathName: "alertsPage"),
  geofencePage(path: "/geofencePage", pathName: "geofencePage"),
  tripsPage(path: "/tripsPage", pathName: "tripsPage");

  final String path;
  final String pathName;
  const AppRoutePath({required this.path, required this.pathName});
}
