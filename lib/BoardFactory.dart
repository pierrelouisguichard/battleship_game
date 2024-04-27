import 'dart:io';

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/Fleet.dart';

class BoardFactory {
  Board getBigBoard() {
    Fleet fleet = Fleet(1, 2, 3);
    Board board = Board(10);
    while (true) {
      try {
        board.placeFleet(fleet);
        return board;
      } catch (e) {
        stderr.writeln("FailedToPlaceShipException");
      }
    }
  }

  List<Board> getBigBoards() {
    return [getBigBoard(), getBigBoard()];
  }

  Board getSmallBoard() {
    Fleet fleet = Fleet(1, 1, 1);
    Board board = Board(7);
    while (true) {
      try {
        board.placeFleet(fleet);
        return board;
      } catch (e) {
        stderr.writeln("FailedToPlaceShipException");
      }
    }
  }

  List<Board> getSmallBoards() {
    return [getSmallBoard(), getSmallBoard()];
  }

  Board getTinyBoard() {
    Fleet fleet = Fleet(0, 0, 1);
    Board board = Board(5);
    while (true) {
      try {
        board.placeFleet(fleet);
        return board;
      } catch (e) {
        stderr.writeln("FailedToPlaceShipException");
      }
    }
  }

  List<Board> getTinyBoards() {
    return [getTinyBoard(), getTinyBoard()];
  }
}
