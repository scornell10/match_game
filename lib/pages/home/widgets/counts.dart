import 'package:flutter/material.dart';
import 'package:match_game/blocs/game_bloc.dart';
import 'package:match_game/models/games_summary.dart';
import 'package:provider/provider.dart';

class Counts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context);
    return Container(
      child: StreamBuilder<GamesSummary>(
          stream: bloc.gamesSummary,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error');
            if (!snapshot.hasData) return Container();
            final summary = snapshot.data;
            return Row(
              children: [
                Spacer(
                  flex: 10,
                ),
                _CountDisplay(
                  count: summary.wins,
                  isWin: true,
                ),
                Spacer(
                  flex: 1,
                ),
                _CountDisplay(
                  count: summary.losses,
                  isWin: false,
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            );
          }),
    );
  }
}

class _CountDisplay extends StatelessWidget {
  const _CountDisplay({
    @required this.count,
    this.isWin = false,
  });

  final int count;
  final bool isWin;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isWin ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }
}
