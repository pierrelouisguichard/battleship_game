import 'dart:math';
import 'package:battleship_game/FailedToPlaceShipException.dart';
import 'package:battleship_game/Fleet.dart';
import 'package:battleship_game/Outcome.dart';
import 'package:battleship_game/Ship.dart';
import 'package:battleship_game/Square.dart';

class Board {
  final int _size;
  late List<List<Square>> _board;
  late int _shipsLeft;

  Square getSquare(int row, int col) {
    return _board[row][col];
  }

  int get size => _size;
  int get shipsLeft => _shipsLeft;

  List<List<Square>> get board => _board;

  Board(this._size) {
    _board = List.generate(_size, (_) => List.generate(_size, (_) => Square()));
    _shipsLeft = 0;
  }

  bool isAlreadyPlayed(int row, int col) {
    return _board[row][col].isAlreadyPlayed();
  }

  void placeFleet(Fleet fleet) {
    List<Ship> ships = fleet.ships;
    for (Ship ship in ships) {
      placeShipRandomly(ship);
    }
  }

  bool isValidCoordinate(int row, int col) {
    return row >= 0 && row < _size && col >= 0 && col < _size;
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
      final row = random.nextInt(_size);
      final col = random.nextInt(_size);
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
        throw FailedToPlaceShipException();
      }
    }
  }

  Outcome dropBomb(int row, int col) {
    Outcome outcome = _board[row][col].bombSquare(row, col);
    if (outcome.sunk != null) {
      _shipsLeft--;
      if (_shipsLeft == 0) {
        outcome.setWon();
      }
    }
    return outcome;
  }
}
