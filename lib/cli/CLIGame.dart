// ignore_for_file: avoid_print

import 'dart:io';

import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Outcome.dart';

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

  setUp() {
    print("Choose a board size:");
    print("1. Tiny Boards");
    print("2. Small Boards");
    print("3. Big Boards");

    String? input = stdin.readLineSync();
    int? choice = int.parse(input!);

    List<Board>? boards;

    switch (choice) {
      case 1:
        boards = BoardFactory().getTinyBoards();
        break;
      case 2:
        boards = BoardFactory().getSmallBoards();
        break;
      case 3:
        boards = BoardFactory().getBigBoards();
        break;
    }

    player1.setBoard(boards![0]);
    player2.setBoard(boards[1]);
  }

  @override
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

  @override
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
        stdout.write(currentPlayer.opponent!.board
            .getSquare(i, j)
            .getDisplayCharacter(!currentPlayer.isHuman() || showShips));
      }
      stdout.write("    ");
      stdout.write("${String.fromCharCode(65 + i)} ");
      for (int j = 0; j < currentPlayer.board.size; j++) {
        stdout.write(currentPlayer.board.getSquare(i, j).getDisplayCharacter(
            !currentPlayer.opponent!.isHuman() || showShips));
      }
      print("");
    }
  }

  @override
  void takeTurn(int row, int col) {
    Outcome outcome = currentPlayer.opponent!.board.dropBomb(row, col);
    displayOutcome(outcome);
    if (isGameOver()) {
      setGameOver();
      if (player1.isHuman()) {
        player1.promptToPlayAgain(this);
      } else if (player2.isHuman()) {
        player2.promptToPlayAgain(this);
      }
    }
  }

  @override
  void playAgain() {
    setGameOn();
    setUp();
  }
}
