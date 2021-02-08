import 'package:flutter/material.dart';

typedef OnVisibilityChange(GamePiece piece);

class GamePiece extends ChangeNotifier {
  GamePiece({
    @required this.id,
    @required this.icon,
  });

  final int id;
  final IconData icon;
  bool _isVisible = false;
  bool _isMatch = false;
  bool _isPeekMode = false;

  bool get isVisible => _isVisible;
  bool get isMatch => _isMatch;
  bool get isPeekMode => _isPeekMode;

  set isVisible(bool isVisible) {
    _isVisible = isVisible;
    notifyListeners();
  }

  set isMatch(bool isMatch) {
    _isMatch = isMatch;
    notifyListeners();
  }

  set isPeekMode(bool isPeekMode) {
    _isPeekMode = isPeekMode;
    notifyListeners();
  }

  void reset() {
    _isVisible = false;
    _isMatch = false;
    notifyListeners();
  }

  static List<GamePiece> create(int id, IconData icon) {
    return [
      GamePiece(id: id, icon: icon),
      GamePiece(id: id, icon: icon),
    ];
  }
}
