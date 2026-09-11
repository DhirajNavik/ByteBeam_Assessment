enum AppRoutePath {
  initialPage(path: "/initialPage", pathName: "initialPage"),
  detailsPage(path: "/detailsPage", pathName: "detailsPage"),
  alertsPage(path: "/alertsPage", pathName: "alertsPage");
  

  final String path;
  final String pathName;
  const AppRoutePath({required this.path, required this.pathName});
}
