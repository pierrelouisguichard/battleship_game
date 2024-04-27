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
    _currentPlayer = _player2;
    _gameOver = false;
  }

  AbstractPlayer get player1 => _player1;
  AbstractPlayer get player2 => _player2;
  AbstractPlayer get currentPlayer => _currentPlayer;
  bool get gameOver => _gameOver;

  void setGameOver() {
    _gameOver = true;
  }

  void playAgain();

  void setGameOn() {
    _gameOver = false;
  }

  void startGame();

  void quitGame() {
    _gameOver = true;
  }

  void switchPlayer() {
    _currentPlayer = (_currentPlayer == _player1) ? _player2 : _player1;
  }

  bool isGameOver() {
    return _player1.board.shipsLeft == 0 || _player2.board.shipsLeft == 0;
  }

  void takeTurn(int row, int col);

  void displayOutcome(Outcome outcome);

  void displayBothBoards(bool showShips);
}
