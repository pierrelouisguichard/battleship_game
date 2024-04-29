import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/Outcome.dart';

abstract class AbstractGame {
  final AbstractPlayer _player1;
  final AbstractPlayer _player2;
  late AbstractPlayer _currentPlayer;
  late bool _gameOver;

  AbstractGame(this._player1, this._player2) {
    _player1.setOpponent(_player2);
    _player2.setOpponent(_player1);
    _currentPlayer = _player1;
    _gameOver = false;
  }

  AbstractPlayer get player1 => _player1;
  AbstractPlayer get player2 => _player2;
  AbstractPlayer get currentPlayer => _currentPlayer;
  bool get gameOver => _gameOver;

  void playAgain() {
    _gameOver = false;
    setUp();
    switchPlayer();
    currentPlayer.promptToTakeTurn(this);
  }

  void setUp();

  void startGame();

  void quitGame() {
    _gameOver = true;
  }

  void switchPlayer() {
    _currentPlayer = (_currentPlayer == _player1) ? _player2 : _player1;
  }

  String displayOutcome(Outcome outcome) {
    if (outcome.gameWon) {
      return "${currentPlayer.name} WINS!";
    } else if (outcome.sunk != null) {
      return "${currentPlayer.name} SUNK a ${outcome.sunk!.name}";
    } else if (outcome.hit) {
      return "${currentPlayer.name} HIT a ship";
    } else {
      return "${currentPlayer.name} missed";
    }
  }

  bool isGameOver() {
    return player1.board.shipsLeft == 0 || player2.board.shipsLeft == 0;
  }

  void takeTurn(int row, int col);

  void setOnGameStateUpdated(void Function() onUpdate) {}

  void setGameOverPopUp(void Function() popUp) {}
}
