import 'package:flutter/material.dart';

class GamePieceIcon extends StatelessWidget {
  const GamePieceIcon({
    Key key,
    @required this.icon,
    @required this.isMatch,
  }) : super(key: key);

  final IconData icon;
  final bool isMatch;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMatch ? Colors.green : Colors.white,
        border: Border.all(
          width: 1.0,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Icon(
        icon,
        size: 40,
        color: isMatch ? Colors.white : Colors.green,
      ),
    );
  }
}
