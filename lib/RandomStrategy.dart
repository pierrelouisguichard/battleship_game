import 'dart:math';

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/CPUStrategy.dart';

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
}
