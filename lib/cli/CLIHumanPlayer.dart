import 'dart:io';

import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/Outcome.dart';

class CLIHumanPlayer extends AbstractPlayer {
  CLIHumanPlayer(super.name);

  @override
  bool isHuman() {
    return true;
  }

  @override
  void promptToTakeTurn(AbstractGame game) {
    while (true) {
      stdout.write("$name, drop bomb (row col): ");
      var input = stdin.readLineSync()!.trim();
      if (input.toLowerCase() == 'quit') {
        print("$name has quit the game.");
        game.quitGame();
        break;
      }
      var coordinates = input.trim().split('');

      if (coordinates.length == 2) {
        var row =
            coordinates[0].toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
        var col = int.parse(coordinates[1]);

        if (opponent!.board.isValidCoordinate(row, col) &&
            !opponent!.board.isAlreadyPlayed(row, col)) {
          game.takeTurn(row, col);
          break;
        }
      }
      print("Invalid input, try again.");
    }
  }

  @override
  void promptToPlayAgain(AbstractGame game) {
    stdout.write("Would you like to play again? (Y/n)");
    var input = stdin.readLineSync()!.trim();
    if (input.toLowerCase() == 'y') {
      game.playAgain();
    }
  }

  @override
  void sendOutcome(Outcome outcome) {
    // TODO: implement sendOutcome
  }
}
