// ignore_for_file: avoid_print

import 'dart:io';

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

  void dropBomb(int row, int col) {
    _board[row][col].bombSquare();
  }

  void demoSetUp(Ship ship1, Ship ship2) {
    _board[0][1].setShip(ship1);
    _board[1][1].setShip(ship1);
    _board[2][1].setShip(ship1);
    _board[4][0].setShip(ship2);
    _board[4][1].setShip(ship2);
    _board[4][2].setShip(ship2);
    _board[4][3].setShip(ship2);
    dropBomb(0, 1);
    dropBomb(1, 1);
    dropBomb(2, 1);
    dropBomb(3, 1);
    dropBomb(4, 1);
  }
}

void main() {
  Board b1 = Board(5, 5);
  Ship s1 = Ship('Submarine', 3);
  Ship s2 = Ship('Battleship', 4);
  b1.demoSetUp(s1, s2);
  b1.displayBoard(true);
}
