import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'blocs/game_bloc.dart';
import 'blocs/settings_bloc.dart';
import 'route_names.dart';
import 'services/database_service.dart';
import 'routes.dart';

class Application extends StatelessWidget {
  final databaseService = GetIt.instance<DatabaseService>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsBloc>(
          create: (context) => SettingsBloc(),
          dispose: (_, bloc) {
            bloc.dispose();
            databaseService.dispose();
          },
        ),
        Provider<GameBloc>(
          create: (context) => GameBloc(),
          dispose: (_, bloc) {
            bloc.dispose();
            databaseService.dispose();
          },
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: RouteNames.HOME,
        routes: routes,
      ),
    );
  }
}
