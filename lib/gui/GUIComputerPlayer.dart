import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/CPUStrategy.dart';

class GUIComputerPlayer extends AbstractPlayer {
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
  void promptToTakeTurn(AbstractGame game) {
    List<int> move = _strategy.pickMove(opponent!.board);
    game.takeTurn(move[0], move[1]);
  }
}
