enum AppRoutePath {
  initialPage(path: "/initialPage", pathName: "initialPage"),
  detailsPage(path: "/detailsPage", pathName: "detailsPage"),
  alertsPage(path: "/alertsPage", pathName: "alertsPage"),
  geofencePage(path: "/geofencePage", pathName: "geofencePage");
  

  final String path;
  final String pathName;
  const AppRoutePath({required this.path, required this.pathName});
}