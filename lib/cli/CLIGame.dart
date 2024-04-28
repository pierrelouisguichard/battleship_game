// ignore_for_file: avoid_print

import 'dart:io';

import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Outcome.dart';
import 'package:battleship_game/Square.dart';

class CLIGame extends AbstractGame {
  CLIGame(super.player1, super.player2);

  @override
  void startGame() async {
    setUp();
    while (!gameOver) {
      switchPlayer();
      print('${currentPlayer.name}\'s turn');
      displayBothBoards(false);
      currentPlayer.promptToTakeTurn(this);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void setUp() {
    List<Board> boards = BoardFactory().getTinyBoards();
    player1.setBoard(boards[0]);
    player2.setBoard(boards[1]);
  }

  void displayOutcome(Outcome outcome) {
    if (outcome.gameWon) {
      print("${currentPlayer.name} WINS!");
      displayBothBoards(true);
    } else if (outcome.sunk != null) {
      print("${currentPlayer.name} has SUNK a ${outcome.sunk!.name}");
    } else if (outcome.hit) {
      print("${currentPlayer.name} has HIT a ship");
    } else {
      print("${currentPlayer.name} has missed");
    }
  }

  void displayBothBoards(bool showShips) {
    stdout.write("  ");
    for (int col = 0; col < currentPlayer.board.size; col++) {
      stdout.write("$col ");
    }
    stdout.write("      ");
    for (int col = 0; col < currentPlayer.board.size; col++) {
      stdout.write("$col ");
    }

    print("");

    for (int i = 0; i < currentPlayer.opponent!.board.size; i++) {
      stdout.write("${String.fromCharCode(65 + i)} ");
      for (int j = 0; j < currentPlayer.opponent!.board.size; j++) {
        stdout.write(getDisplayCharacter(
            currentPlayer.opponent!.board.getSquare(i, j),
            (!currentPlayer.isHuman() || showShips)));
      }
      stdout.write("    ");
      stdout.write("${String.fromCharCode(65 + i)} ");
      for (int j = 0; j < currentPlayer.board.size; j++) {
        stdout.write(getDisplayCharacter(currentPlayer.board.getSquare(i, j),
            (!currentPlayer.opponent!.isHuman() || showShips)));
      }
      print("");
    }
  }

  @override
  void takeTurn(int row, int col) {
    Outcome outcome = currentPlayer.opponent!.board.dropBomb(row, col);
    displayOutcome(outcome);
    if (isGameOver()) {
      player1.promptToPlayAgain(this);
    }
  }

  String getDisplayCharacter(Square square, bool showShips) {
    SquareStatus status = square.status;
    switch (status) {
      case SquareStatus.empty:
        return '~ ';
      case SquareStatus.ship:
        if (showShips) {
          return '${square.ship!.getCodeCharacter()} ';
        } else {
          return '~ ';
        }
      case SquareStatus.hit:
        return '* ';
      case SquareStatus.miss:
        return '\' ';
      case SquareStatus.sunk:
        return 'X ';
    }
  }
}
