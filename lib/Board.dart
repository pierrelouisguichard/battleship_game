// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:battleship_game/Ship.dart';
import 'package:battleship_game/Square.dart';

class Board {
  final int _height;
  final int _width;
  late List<List<Square>> _board;
  late int _shipsLeft;

  List<List<Square>> get board => _board;

  Board(this._height, this._width) {
    _board =
        List.generate(_height, (_) => List.generate(_width, (_) => Square()));
    _shipsLeft = 0;
  }

  void displayBoard(bool showShips) {
    stdout.write("  ");
    for (int col = 0; col < _width; col++) {
      stdout.write("$col ");
    }
    print("");

    for (int i = 0; i < _height; i++) {
      stdout.write("${String.fromCharCode(65 + i)} ");
      for (int j = 0; j < _width; j++) {
        stdout.write(_board[i][j].getDisplayCharacter(showShips));
      }
      print("");
    }
  }

  bool isValidCoordinate(int row, int col) {
    return row >= 0 && row < _height && col >= 0 && col < _width;
  }

  bool hasAdjacentShip(int row, int col) {
    for (int i = row - 1; i <= row + 1; i++) {
      for (int j = col - 1; j <= col + 1; j++) {
        if (isValidCoordinate(i, j) && _board[i][j].hasShip()) {
          return true;
        }
      }
    }
    return false;
  }

  bool isValidPlacement(Ship ship, int row, int col, bool isHorizontal) {
    for (int i = 0; i < ship.size; i++) {
      int newRow = isHorizontal ? row : row + i;
      int newCol = isHorizontal ? col + i : col;
      if (!isValidCoordinate(newRow, newCol) ||
          _board[newRow][newCol].hasShip() ||
          hasAdjacentShip(newRow, newCol)) {
        return false;
      }
    }
    return true;
  }

  void placeShipRandomly(Ship ship) {
    final random = Random();
    int exceptionThreshold = 0;
    while (true) {
      final row = random.nextInt(_height);
      final col = random.nextInt(_width);
      final isHorizontal = random.nextBool();
      if (isValidPlacement(ship, row, col, isHorizontal)) {
        for (int i = 0; i < ship.size; i++) {
          final square =
              isHorizontal ? _board[row][col + i] : _board[row + i][col];
          square.setShip(ship);
          ship.placeShipOnSquare(square);
        }
        _shipsLeft++;
        return;
      }
      if (exceptionThreshold++ > 100) {
        print("Failed to place ship");
        break;
      }
    }
  }

  void dropBomb(int row, int col) {
    _board[row][col].bombSquare();
  }
}
