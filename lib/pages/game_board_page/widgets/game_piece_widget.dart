import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:match_game/models/game_piece.dart';

import 'game_piece_blank.dart';
import 'game_piece_icon.dart';

class GamePieceWidget extends StatefulWidget {
  GamePieceWidget({
    @required this.piece,
  });
  final GamePiece piece;
  @override
  _GamePieceWidgetState createState() => _GamePieceWidgetState();
}

class _GamePieceWidgetState extends State<GamePieceWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  GamePiece _piece;
  bool _isPeekMode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      _controller,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });

    _piece = widget.piece;

    _piece.addListener(_pieceChange);
  }

  void _pieceChange() {
    if (!mounted) return;

    if (_piece.isPeekMode) {
      _controller?.forward();
      _isPeekMode = true;
      return;
    } else if (_isPeekMode) {
      _controller?.reverse();
      _isPeekMode = false;
      return;
    }

    if (_piece.isVisible &&
        (_controller.status == AnimationStatus.dismissed ||
            _controller.status == AnimationStatus.reverse)) {
      _controller?.forward();
    } else if (!_piece.isVisible &&
        (_controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.forward)) {
      _controller?.reverse();
    } else if (_piece.isMatch) {
      setState(() {}); //need to rebuild when is a Match
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.009)
            ..rotateY(math.pi * _animation.value),
          child: GestureDetector(
            onTap: () async {
              if (_piece.isPeekMode || _piece.isMatch) return;
              if (_status == AnimationStatus.dismissed) {
                await _controller.forward();
                _piece.isVisible = true;
              } else {
                await _controller.reverse();
                _piece.isVisible = false;
              }
            },
            child: _animation.value <= .5
                ? GamePieceBlank()
                : GamePieceIcon(
                    icon: widget.piece.icon,
                    isMatch: widget.piece.isMatch,
                  ),
          ),
        );
      },
    );
  }
}
