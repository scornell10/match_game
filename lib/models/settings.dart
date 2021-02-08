import 'package:flutter/foundation.dart';

class Settings {
  Settings({
    @required this.id,
    @required this.gamePieceCount,
    @required this.preGameTimer,
    @required this.gameTimer,
  });

  final int id;
  final int gamePieceCount;
  final int preGameTimer;
  final int gameTimer;

  Map<String, dynamic> toMap() => {
        'id': id,
        'gamePieceCount': gamePieceCount,
        'preGameTimer': preGameTimer,
        'gameTimer': gameTimer,
      };

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(
        id: map['id'],
        gamePieceCount: map['gamePieceCount'],
        preGameTimer: map['preGameTimer'],
        gameTimer: map['gameTimer'],
      );
}
