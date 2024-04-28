import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';

class GUIHumanPlayer extends AbstractPlayer {
  GUIHumanPlayer(super.name);

  @override
  bool isHuman() {
    return true;
  }

  @override
  void promptToTakeTurn(AbstractGame game) {
    return;
  }

  @override
  void promptToPlayAgain(AbstractGame game) {
    return;
  }
}
