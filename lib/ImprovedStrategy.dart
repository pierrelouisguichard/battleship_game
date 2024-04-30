import 'dart:math';

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/CPUStrategy.dart';
import 'package:battleship_game/Outcome.dart';

class ImprovedStrategy implements CPUStrategy {
  List<List<int>> _lastHits = [];

  @override
  List<int> pickMove(Board opponentBoard) {
    if (_lastHits.isNotEmpty) {
      for (int index = 0; index < _lastHits.length; index++) {
        final List<int> lastHit = _lastHits[index];
        List<List<int>> directions = [
          [0, 1], // Right
          [0, -1], // Left
          [1, 0], // Down
          [-1, 0], // Up
        ];
        for (List<int> direction in directions) {
          int x = lastHit[0] + direction[0];
          int y = lastHit[1] + direction[1];
          if (inBoundsAndUntried(opponentBoard, x, y)) {
            return [x, y];
          }
        }
      }
    }
    return randomSquare(opponentBoard);
  }

  @override
  void resultOfMove(Outcome outcome) {
    if (outcome.hit) {
      _lastHits.add([outcome.row, outcome.col]);
      if (outcome.sunk != null) {
        _lastHits.clear();
      }
    }
  }

  bool inBoundsAndUntried(Board board, int x, int y) {
    return board.isValidCoordinate(x, y) &&
        !board.getSquare(x, y).isAlreadyPlayed();
  }

  List<int> randomSquare(Board board) {
    while (true) {
      final x = Random().nextInt(board.size);
      final y = Random().nextInt(board.size);
      if (!board.getSquare(x, y).isAlreadyPlayed()) {
        return [x, y];
      }
    }
  }
}
