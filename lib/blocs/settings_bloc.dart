import 'package:get_it/get_it.dart';
import 'package:match_game/models/settings.dart';
import 'package:rxdart/rxdart.dart';

import '../services/database_service.dart';

class SettingsBloc {
  final databaseService = GetIt.instance<DatabaseService>();
  final BehaviorSubject<Settings> _settingsSub = BehaviorSubject<Settings>();

  Stream<Settings> get settings => _settingsSub.stream;

  Future loadSettings() async {
    try {
      final settings = await databaseService.retrieveSettings();
      _settingsSub.sink.add(settings);
    } catch (e) {
      _settingsSub.addError(e);
    }
  }

  Future updateSettings(
    int gamePieceCount,
    int preGameTimer,
    int gameTimer,
  ) async {
    try {
      final settings = Settings(
        id: 1,
        gamePieceCount: gamePieceCount,
        preGameTimer: preGameTimer,
        gameTimer: gameTimer,
      );
      await databaseService.updateSettings(settings);
      await loadSettings();
    } catch (e) {
      _settingsSub.addError(e);
    }
  }

  dispose() {
    _settingsSub?.close();
  }
}
