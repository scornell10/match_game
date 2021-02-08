import 'package:flutter/material.dart';
import 'package:match_game/blocs/game_bloc.dart';
import 'package:match_game/models/models.dart';
import 'package:match_game/pages/game_board_page/widgets/game_piece_widget.dart';
import 'package:provider/provider.dart';

import 'widgets/complete.dart';
import 'widgets/timer.dart';

class GameBoardPage extends StatefulWidget {
  @override
  _GameBoardPageState createState() => _GameBoardPageState();
}

class _GameBoardPageState extends State<GameBoardPage>
    with SingleTickerProviderStateMixin {
  AnimationController _gameCompleteController;
  Animation<Offset> _gameCompleteAnimation;
  GameStatus _status = GameStatus.Active;
  @override
  void initState() {
    super.initState();
    _gameCompleteController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _gameCompleteAnimation =
        Tween<Offset>(begin: Offset(0, 4), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _gameCompleteController,
        curve: Curves.bounceInOut,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _gameCompleteController?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = Provider.of<GameBloc>(context);
    bloc.gameStatus.listen((status) async {
      if (!mounted) return;
      if (status == GameStatus.Complete || status == GameStatus.Timeout) {
        setState(() {
          _status = status;
        });
        _gameCompleteController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<GamePiece>>(
              stream: bloc.gamePieces,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text('Error'),
                  );

                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No Games'),
                  );
                }

                final pieces = snapshot.data;
                return GridView.count(
                  padding: EdgeInsets.all(10),
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: pieces
                      .map(
                        (piece) => GamePieceWidget(piece: piece),
                      )
                      .toList(),
                );
              }),
          Positioned(
            right: 10,
            bottom: 10,
            child: Timer(bloc: bloc),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: AbsorbPointer(
              absorbing: _status != GameStatus.Active,
              child: Container(
                alignment: Alignment.center,
                child: SlideTransition(
                  position: _gameCompleteAnimation,
                  child: Complete(status: _status),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
