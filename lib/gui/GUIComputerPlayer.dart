import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/CPUStrategy.dart';
import 'package:battleship_game/Outcome.dart';

class GUIComputerPlayer extends AbstractPlayer {
  static const int delayMilliseconds = 250;
  final CPUStrategy _strategy;
  GUIComputerPlayer(super.name, this._strategy);

  @override
  bool isHuman() {
    return false;
  }

  @override
  void promptToPlayAgain(AbstractGame game) {
    return;
  }

  @override
  void promptToTakeTurn(AbstractGame game) async {
    await Future.delayed(const Duration(milliseconds: delayMilliseconds));
    List<int> move = _strategy.pickMove(opponent!.board);
    game.takeTurn(move[0], move[1]);
  }

  @override
  void sendOutcome(Outcome outcome) {
    _strategy.resultOfMove(outcome);
  }
}
