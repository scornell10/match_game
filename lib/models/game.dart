import 'package:flutter/foundation.dart';

class Game {
  Game({
    this.id,
    @required this.correct,
    @required this.incorrect,
    @required this.questionCount,
    @required this.timeLength,
    @required this.timeLeft,
  });
  final int id;
  final int correct;
  final int incorrect;
  final int questionCount;
  final int timeLength;
  final int timeLeft;

  Map<String, dynamic> toMap() => {
        'id': id,
        'correct': correct,
        'incorrect': incorrect,
        'questionCount': questionCount,
        'timeLength': timeLength,
        'timeLeft': timeLeft,
      };

  factory Game.fromMap(Map<String, dynamic> map) => Game(
        id: map['id'],
        correct: map['correct'],
        incorrect: map['incorrect'],
        questionCount: map['questionCount'],
        timeLength: map['timeLength'],
        timeLeft: map['timeLeft'],
      );
}
