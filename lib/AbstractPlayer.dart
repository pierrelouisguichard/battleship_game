// ignore_for_file: file_names

import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';

abstract class AbstractPlayer {
  final String _name;
  late Board _board;
  late final AbstractPlayer? _opponent;

  AbstractPlayer(this._name);

  AbstractPlayer? get opponent => _opponent;
  String get name => _name;
  Board get board => _board;

  void setBoard(Board board) {
    _board = board;
  }

  void setOpponent(AbstractPlayer opponent) {
    _opponent = opponent;
  }

  bool isHuman();

  void promptToTakeTurn(AbstractGame game);

  void promptToPlayAgain(AbstractGame game);
}
