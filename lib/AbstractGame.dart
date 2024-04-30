import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/Outcome.dart';

abstract class AbstractGame {
  final AbstractPlayer _player1;
  final AbstractPlayer _player2;
  late AbstractPlayer _currentPlayer;
  late bool _gameOver;
  late String _result;

  AbstractGame(this._player1, this._player2) {
    _player1.setOpponent(_player2);
    _player2.setOpponent(_player1);
    _currentPlayer = _player1;
    _gameOver = false;
    _result = "";
  }

  AbstractPlayer get player1 => _player1;
  AbstractPlayer get player2 => _player2;
  AbstractPlayer get currentPlayer => _currentPlayer;
  bool get gameOver => _gameOver;
  String get result => _result;

  void startSecond() {
    _currentPlayer = _player2;
  }

  bool isMyTurn() {
    return _currentPlayer == _player1;
  }

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

  void displayOutcome(Outcome? outcome, String? result) {
    String who = (currentPlayer == player1) ? "You" : 'Opponent';

    if (outcome != null) {
      if (outcome.gameWon) {
        _result = "$who WON!";
      } else if (outcome.sunk != null) {
        _result = "$who SUNK a ${outcome.sunk!.name}";
      } else if (outcome.hit) {
        _result = "$who HIT a ship";
      } else {
        _result = "$who missed";
      }
    } else {
      if (result == "hit") {
        _result = "You HIT a ship";
      } else if (result == "miss") {
        _result = "You missed.";
      } else if (result == "sunk") {
        _result = "You SUNK a ship";
      } else {
        _result = "You WON!";
      }
    }
  }

  bool isGameOver() {
    return player1.board.shipsLeft == 0 || player2.board.shipsLeft == 0;
  }

  void takeTurn(int row, int col);

  void setOnGameStateUpdated(void Function() onUpdate) {}

  void setGameOverPopUp(void Function() popUp) {}
}
