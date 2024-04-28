import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';

class GUIGame extends AbstractGame {
  late Function() _onGameStateUpdated;
  late Function() _popUp;
  GUIGame(super.player1, super.player2);

  void setOnGameStateUpdated(Function() onUpdate) {
    _onGameStateUpdated = onUpdate;
  }

  void setGameOverPopUp(Function() popUp) {
    _popUp = popUp;
  }

  @override
  void startGame() {
    setUp();
  }

  @override
  void takeTurn(int row, int col) {
    Board opponentsBoard = currentPlayer.opponent!.board;
    if (!opponentsBoard.getSquare(row, col).isAlreadyPlayed()) {
      opponentsBoard.dropBomb(row, col);
      _onGameStateUpdated();
      if (isGameOver()) {
        _popUp();
      }
      switchPlayer();
      currentPlayer.promptToTakeTurn(this);
    }
  }

  @override
  void setUp() {
    List<Board>? boards = BoardFactory().getTinyBoards();
    player1.setBoard(boards[0]);
    player2.setBoard(boards[1]);
  }
}
