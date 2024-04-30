import 'dart:math';

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/CPUStrategy.dart';
import 'package:battleship_game/Outcome.dart';

class RandomStrategy implements CPUStrategy {
  @override
  List<int> pickMove(Board opponentBoard) {
    while (true) {
      int row = Random().nextInt(opponentBoard.size);
      int col = Random().nextInt(opponentBoard.size);
      if (!opponentBoard.isAlreadyPlayed(row, col)) {
        return [row, col];
      }
    }
  }

  @override
  void resultOfMove(Outcome outcome) {
    // TODO: implement resultOfMove
  }
}
