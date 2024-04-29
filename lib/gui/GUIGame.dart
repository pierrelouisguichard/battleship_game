import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Outcome.dart';

class GUIGame extends AbstractGame {
  late Function() _onGameStateUpdated;
  late Function() _popUp;
  String result = "";

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
    currentPlayer.promptToTakeTurn(this);
  }

  @override
  void takeTurn(int row, int col) {
    Board opponentsBoard = currentPlayer.opponent!.board;
    if (!opponentsBoard.getSquare(row, col).isAlreadyPlayed()) {
      Outcome outcome = opponentsBoard.dropBomb(row, col);
      result = displayOutcome(outcome);
      _onGameStateUpdated();
      _handleEndOfTurn();
    }
  }

  void _handleEndOfTurn() {
    if (isGameOver()) {
      _popUp();
      return;
    }
    switchPlayer();
    currentPlayer.promptToTakeTurn(this);
  }

  @override
  void setUp() {
    List<Board>? boards = BoardFactory().getSmallBoards();
    player1.setBoard(boards[0]);
    player2.setBoard(boards[1]);
  }
}
