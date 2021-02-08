import 'dart:io';

import 'package:match_game/models/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initialize();
    }
    return _database;
  }

  void dispose() {
    _database?.close();
    _database = null;
  }

  Future<int> addGame(Game game) async {
    final db = await database;
    return await db.insert('Game', game.toMap());
  }

  Future<int> updateGame(Game game) async {
    final db = await database;
    return await db
        .update('Game', game.toMap(), where: 'id = ?', whereArgs: [game.id]);
  }

  Future deleteGame(Game game) async {
    final db = await database;
    await db.delete('Game', where: "id = ?", whereArgs: [game.id]);
  }

  Future<List<Game>> retrieveGames() async {
    final db = await database;
    var res = await db.query('Game');
    List<Game> list =
        res.isNotEmpty ? res.map((a) => Game.fromMap(a)).toList() : [];
    return list;
  }

  Future<int> updateSettings(Settings settings) async {
    final db = await database;
    return await db.update('Settings', settings.toMap(), where: 'id = 1');
  }

  Future<Settings> retrieveSettings() async {
    final db = await database;
    final res = await db.query('settings');
    final settings = res.isNotEmpty
        ? res.map((setting) => Settings.fromMap(setting)).first
        : null;
    return settings;
  }

  Future<Database> _initialize() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'match_game.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {
        print('Database Open');
      },
      onCreate: _onCreate,
    );

    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Game ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "correct INTEGER,"
        "incorrect INTEGER,"
        "questionCount INTEGER,"
        "timeLength INTEGER,"
        "timeLeft INTEGER"
        ")");
    await db.execute("CREATE TABLE Settings ("
        "id INTEGER PRIMARY KEY,"
        "gamePieceCount INTEGER,"
        "preGameTimer INTEGER,"
        "gameTimer INTEGER"
        ")");
    await db.execute(
        "INSERT INTO Settings (id, gamePieceCount, preGameTimer, gameTimer ) "
        "values(1, 8, 3, 30) ");
  }
}
