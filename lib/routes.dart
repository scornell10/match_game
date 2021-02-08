import 'pages/pages.dart';
import 'route_names.dart';

final routes = {
  RouteNames.HOME: (_) => HomePage(),
  RouteNames.SETTINGS: (_) => SettingsPage(),
  RouteNames.GAME_BOARD: (_) => GameBoardPage(),
};
