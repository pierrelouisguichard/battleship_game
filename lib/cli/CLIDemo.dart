// ignore_for_file: file_names

import 'dart:io';

import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/RandomStrategy.dart';
import 'package:battleship_game/cli/CLIComputerPlayer.dart';
import 'package:battleship_game/cli/CLIGame.dart';
import 'package:battleship_game/cli/CLIHumanPlayer.dart';

void main() {
  print("Choose a game mode:");
  print("1. Human vs. Human");
  print("2. Human vs. Computer");
  print("3. Computer vs. Computer");

  String? input = stdin.readLineSync();
  int? choice = int.parse(input!);

  AbstractPlayer? player1;
  AbstractPlayer? player2;

  switch (choice) {
    case 1:
      player1 = CLIHumanPlayer("Human1");
      player2 = CLIHumanPlayer("Human2");
      break;
    case 2:
      player1 = CLIHumanPlayer("Human");
      player2 = CLIComputerPlayer("Computer", RandomStrategy());
      break;
    case 3:
      player1 = CLIComputerPlayer("CPU1", RandomStrategy());
      player2 = CLIComputerPlayer("CPU2", RandomStrategy());
      break;
  }

  AbstractGame game = CLIGame(player1!, player2!);
  game.startGame();
}
