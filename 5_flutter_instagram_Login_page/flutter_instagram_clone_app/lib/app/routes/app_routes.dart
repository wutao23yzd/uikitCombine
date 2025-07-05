enum AppRoutes {
  auth('/auth'),
  home('/home');

  const AppRoutes(this.route, {this.path});

  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');

}