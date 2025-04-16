class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  String _currentRoute = 'nav';

  String get currentRoute => _currentRoute;

  void updateRoute(String route) {
    _currentRoute = route;
  }
}