import 'package:flutter/material.dart';
import 'package:match_game/blocs/game_bloc.dart';
import 'package:match_game/models/game.dart';
import 'package:provider/provider.dart';

import '../../route_names.dart';
import 'widgets/counts.dart';
import 'widgets/menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<GameBloc>(context).loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Game'),
      ),
      drawer: Menu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10,
          ),
          Counts(),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Spacer(
                flex: 1,
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<GameBloc>(context, listen: false).loadNewGame();
                    Navigator.of(context).pushNamed(
                      RouteNames.GAME_BOARD,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'New Game',
                      style: TextStyle(fontSize: 50),
                    ),
                  )),
              Spacer(
                flex: 1,
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Game>>(
              stream: Provider.of<GameBloc>(context).games,
              builder: (ctx, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text('Error'),
                  );
                if (!snapshot.hasData)
                  return Center(
                    child: Text('No Game History'),
                  );

                final games = snapshot.data;

                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: games.length,
                    itemBuilder: (BuildContext context, int index) {
                      final game = games[index];
                      return ListTile(
                        leading: _GameIndicator(
                          isWin: game.questionCount == game.correct,
                        ),
                        title: Row(
                          children: [
                            Text('Correct: ${game.correct}'),
                            Spacer(
                              flex: 1,
                            ),
                            Text('Incorrect: ${game.incorrect}'),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GameIndicator extends StatelessWidget {
  const _GameIndicator({
    @required this.isWin,
  });

  final bool isWin;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: isWin ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
