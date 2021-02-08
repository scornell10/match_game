import 'package:get_it/get_it.dart';
import 'package:match_game/models/settings.dart';
import 'package:match_game/services/database_service.dart';

class GameRepository {
  final databaseService = GetIt.instance<DatabaseService>();

  Future<Settings> retrieveSettings() async {
    return await databaseService.retrieveSettings();
  }

  Future saveSettings(Settings settings) async {
    await databaseService.updateSettings(settings);
  }
}
