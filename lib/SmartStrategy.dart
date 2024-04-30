import 'dart:math';

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/CPUStrategy.dart';

class SmartStrategy implements CPUStrategy {
  late List<int> lastHit; // Store the last hit coordinates
  bool targetingMode =
      false; // Flag to indicate whether the computer is in targeting mode
  late List<List<bool>>
      targeted; // Keep track of which squares have been targeted

  SmartStrategy(int boardSize) {
    targeted = List.generate(
        boardSize, (index) => List<bool>.filled(boardSize, false));
  }

  @override
  List<int> pickMove(Board opponentBoard) {
    if (!targetingMode) {
      return randomMove(opponentBoard);
    } else {
      return targetMove(opponentBoard);
    }
  }

  // Function to make a random move
  List<int> randomMove(Board opponentBoard) {
    while (true) {
      int row = Random().nextInt(opponentBoard.size);
      int col = Random().nextInt(opponentBoard.size);
      if (!targeted[row][col]) {
        targeted[row][col] = true;
        if (!opponentBoard.isAlreadyPlayed(row, col)) {
          return [row, col];
        }
      }
    }
  }

  // Function to make a targeted move after a hit
  List<int> targetMove(Board opponentBoard) {
    // If last hit is null (no previous hit), revert to random mode
    if (lastHit == null) {
      targetingMode = false;
      return randomMove(opponentBoard);
    }

    // Try to hit around the last hit
    for (var dir in directions) {
      int newRow = lastHit[0] + dir[0];
      int newCol = lastHit[1] + dir[1];
      if (isValidMove(newRow, newCol, opponentBoard.size) &&
          !targeted[newRow][newCol]) {
        targeted[newRow][newCol] = true;
        if (!opponentBoard.isAlreadyPlayed(newRow, newCol)) {
          return [newRow, newCol];
        }
      }
    }

    // If all adjacent cells are already targeted, revert to random mode
    targetingMode = false;
    return randomMove(opponentBoard);
  }

  // Function to check if a move is valid (within the board bounds)
  bool isValidMove(int row, int col, int size) {
    return row >= 0 && col >= 0 && row < size && col < size;
  }

  // List of directions to move around the last hit
  List<List<int>> directions = [
    [0, 1], // Right
    [0, -1], // Left
    [1, 0], // Down
    [-1, 0], // Up
  ];

  // Setter to update the last hit
  void setLastHit(List<int> hit) {
    lastHit = hit;
    targetingMode = true;
  }
}
