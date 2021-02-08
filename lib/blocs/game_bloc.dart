import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:match_game/models/models.dart';
import 'package:match_game/utils/image_generator.dart';

import 'package:rxdart/subjects.dart';

import '../services/database_service.dart';

enum GameStatus { Active, Complete, Timeout }

class GameBloc {
  final databaseService = GetIt.instance<DatabaseService>();
  final _gamePiecesSub = BehaviorSubject<List<GamePiece>>();
  final _gameStatusSub = BehaviorSubject<GameStatus>();
  final _gamesSummarySub = BehaviorSubject<GamesSummary>();
  final _gamesSub = BehaviorSubject<List<Game>>();
  final _gamePieces = List<GamePiece>();
  final _activePieces = List<GamePiece>();
  final _matchedPieces = List<GamePiece>();

  bool _changeInProgress = false; //prevent listener being called on changes
  Timer _timer;
  ValueNotifier<int> _countDownNotifier = ValueNotifier(0);

  ValueNotifier<int> get countDown => _countDownNotifier;
  Stream<List<GamePiece>> get gamePieces => _gamePiecesSub.stream;
  Stream<GamesSummary> get gamesSummary => _gamesSummarySub.stream;
  Stream<List<Game>> get games => _gamesSub.stream;
  Stream<GameStatus> get gameStatus => _gameStatusSub.stream;

  void loadNewGame() async {
    _changeInProgress = false;
    _gameStatusSub.sink.add(GameStatus.Active);
    final settings = await databaseService.retrieveSettings();
    final count = settings.gamePieceCount;
    final icons = Set<IconData>();
    final random = math.Random();

    _countDownNotifier.value = settings.gameTimer;

    //clear previos game
    _disposePieces();

    //create ramdon list of icons
    while (icons.length < count) {
      icons.add(gameIcons[random.nextInt(100)]);
    }

    //create 2 matching pieces
    for (var cnt = 0; cnt < count; cnt++) {
      final icon = icons.elementAt(cnt);
      final pieces = GamePiece.create(cnt, icon);
      _gamePieces.addAll(pieces);
    }

    //shuffle the order of the pieces
    for (var cnt = _gamePieces.length - 1; cnt > 0; cnt--) {
      final num = random.nextInt(cnt + 1);
      final temp = _gamePieces[cnt];
      _gamePieces[cnt] = _gamePieces[num];
      _gamePieces[num] = temp;
    }

    _gamePiecesSub.sink.add(_gamePieces);

    //show the pieces
    await Future.delayed(Duration(milliseconds: 500));
    _gamePieces.forEach((piece) {
      piece.isPeekMode = true;
    });

    //hide the pieces
    await Future.delayed(Duration(seconds: settings.preGameTimer));
    _gamePieces.forEach((piece) {
      piece.isPeekMode = false;
    });

    _gamePieces.forEach((piece) {
      piece.addListener(() => _pieceInPlay(piece));
    });

    _setupTimerControl();
  }

  Future loadStats() async {
    try {
      final games = await databaseService.retrieveGames();
      games.sort((a, b) => a.id.compareTo(b.id));
      _gamesSub.sink.add(games);
      int wins = 0;
      int losses = 0;
      games.forEach((game) {
        if (game.incorrect > 0)
          losses++;
        else
          wins++;
      });
      _gamesSummarySub.sink.add(
        GamesSummary(
          wins: wins,
          losses: losses,
        ),
      );
    } catch (e) {
      _gamesSub.sink.addError(e);
      _gamesSummarySub.sink.addError(e);
    }
  }

  void _setupTimerControl() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (countDown.value <= 1) {
        _timer.cancel();
        _gameStatusSub.sink.add(GameStatus.Timeout);
        _countDownNotifier.value = 0;
        _changeInProgress = true;
        _gamePieces.forEach((piece) {
          piece.isVisible = true;
        });
        await _saveGameStats();
        await loadStats();
      } else {
        _countDownNotifier.value = (_countDownNotifier.value - 1);
      }
    });
  }

  void _pieceInPlay(GamePiece piece) async {
    if (_changeInProgress) return;

    _changeInProgress = true;

    if (_activePieces.length == 1) {
      final activePiece = _activePieces.first;
      if (activePiece.id == piece.id) {
        _matchedPieces.addAll([activePiece, piece]);
        _activePieces.clear();
        activePiece.isMatch = true;
        piece.isMatch = true;
      } else {
        _activePieces.clear();
        activePiece.reset();
        piece.reset();
      }
    } else {
      _activePieces.add(piece);
    }

    if (_matchedPieces.length == _gamePieces.length) {
      _gameStatusSub.sink.add(GameStatus.Complete);
      _timer?.cancel();
      await _saveGameStats();
      await loadStats();
    }
    _changeInProgress = false;
  }

  Future _saveGameStats() async {
    int correct = 0;
    int incorrect = 0;
    _gamePieces?.forEach((piece) {
      if (piece.isMatch)
        correct++;
      else
        incorrect++;
    });
    correct = (correct / 2).round();
    incorrect = (incorrect / 2).round();
    final settings = await databaseService.retrieveSettings();
    databaseService.addGame(
      Game(
        correct: correct,
        incorrect: incorrect,
        questionCount: settings.gamePieceCount,
        timeLength: settings.gameTimer,
        timeLeft: _countDownNotifier.value,
      ),
    );
  }

  void _disposePieces() {
    _gamePieces?.forEach((piece) {
      piece?.dispose();
    });
    _gamePieces?.clear();
    _activePieces?.clear();
    _matchedPieces?.clear();
    _timer?.cancel();
  }

  void dispose() {
    _disposePieces();
    _gamePiecesSub?.close();
    _gameStatusSub?.close();
    _gamesSummarySub?.close();
    _gamesSub?.close();
  }
}
