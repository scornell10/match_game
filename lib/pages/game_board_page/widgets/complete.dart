import 'package:flutter/material.dart';
import 'package:match_game/blocs/game_bloc.dart';

class Complete extends StatelessWidget {
  Complete({
    @required this.status,
  });
  final GameStatus status;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: status == GameStatus.Complete ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(offset: Offset(5, 5), color: Colors.grey),
            BoxShadow(offset: Offset(1, 1), color: Colors.white)
          ]),
      child: Text(
        status == GameStatus.Complete ? 'Complete!' : 'Time is Up!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      ),
    );
  }
}
