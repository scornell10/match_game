import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:match_game/blocs/game_bloc.dart';

class Timer extends StatelessWidget {
  Timer({
    @required this.bloc,
  });
  final GameBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ValueListenableBuilder(
        valueListenable: bloc.countDown,
        builder: (ctx, count, child) {
          return Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          );
        },
      ),
    );
  }
}
