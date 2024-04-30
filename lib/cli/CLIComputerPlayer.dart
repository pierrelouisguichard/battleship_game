import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/CPUStrategy.dart';
import 'package:battleship_game/Outcome.dart';

class CLIComputerPlayer extends AbstractPlayer {
  final CPUStrategy _strategy;
  CLIComputerPlayer(super.name, this._strategy);

  @override
  bool isHuman() {
    return false;
  }

  @override
  void promptToTakeTurn(AbstractGame game) {
    List<int> move = _strategy.pickMove(opponent!.board);
    print(
        "$name, dropped a bomb on ${String.fromCharCode(move[0] + 65)}${move[1]}");
    game.takeTurn(move[0], move[1]);
  }

  @override
  void promptToPlayAgain(AbstractGame game) {
    return;
  }

  @override
  void sendOutcome(Outcome outcome) {
    _strategy.resultOfMove(outcome);
  }
}
