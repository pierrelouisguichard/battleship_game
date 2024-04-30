import 'package:battleship_game/Ship.dart';

class Outcome {
  final bool _hit;
  final Ship? _sunk;
  bool _gameWon;
  int _row;
  int _col;

  Outcome(this._row, this._col, this._hit, this._sunk, this._gameWon);

  bool get hit => _hit;
  Ship? get sunk => _sunk;
  bool get gameWon => _gameWon;
  int get row => _row;
  int get col => _col;

  void setWon() {
    _gameWon = true;
  }
}
