// ignore_for_file: avoid_print

import 'dart:io';

import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Square.dart';

class CLIGame extends AbstractGame {
  CLIGame(super.player1, super.player2);

  @override
  void startGame() async {
    setUp();
    while (!gameOver) {
      print("${currentPlayer.name}'s turn");
      displayBothBoards(false);
      currentPlayer.promptToTakeTurn(this);
      await Future.delayed(const Duration(milliseconds: 500));
      switchPlayer();
    }
  }

  @override
  void setUp() {
    final boards = BoardFactory().getTinyBoards();
    player1.setBoard(boards[0]);
    player2.setBoard(boards[1]);
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
    final outcome = currentPlayer.opponent!.board.dropBomb(row, col);
    displayOutcome(outcome, null);
    print(result);
    if (isGameOver()) {
      player1.promptToPlayAgain(this);
    }
  }

  String getDisplayCharacter(Square square, bool showShips) {
    final status = square.status;
    switch (status) {
      case SquareStatus.water:
        return "~ ";
      case SquareStatus.ship:
        return showShips ? '${square.ship!.getCodeCharacter()} ' : "~ ";
      case SquareStatus.hit:
        return "* ";
      case SquareStatus.miss:
        return "' ";
      case SquareStatus.sunk:
        return "X ";
    }
  }
}
