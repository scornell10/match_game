import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'application.dart';
import 'repositories/game_repository.dart';
import 'services/database_service.dart';

final instance = GetIt.instance;
void main() {
  instance.registerSingleton<DatabaseService>(DatabaseService());
  instance.registerSingleton<GameRepository>(GameRepository());
  runApp(Application());
}
