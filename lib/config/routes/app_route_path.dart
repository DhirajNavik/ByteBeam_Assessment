enum AppRoutePath {
  initialPage(path: "/initialPage", pathName: "initialPage"),
  home(path: "/home", pathName: "home");

  final String path;
  final String pathName;
  const AppRoutePath({required this.path, required this.pathName});
}
