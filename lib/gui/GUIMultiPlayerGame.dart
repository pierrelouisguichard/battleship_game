import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Outcome.dart';
import 'package:battleship_game/services/databaseServices.dart';

class GUIMultiPlayerGame extends AbstractGame {
  static const int delayMilliseconds = 250;
  final DatabaseService _databaseService = DatabaseService();
  final String roomId;
  late final Function() _onGameStateUpdated;
  late final Function() _popUp;
  late bool listenToResponse;
  late bool listenToCords;
  late int row;
  late int col;

  GUIMultiPlayerGame(super._player1, super._player2, {required this.roomId});

  @override
  void startGame() {
    startListeningToResponse();
    startListeningtoCords();
    setUp();
  }

  @override
  void takeTurn(int row, int col) {
    if (isMyTurn() && !player2.board.isAlreadyPlayed(row, col)) {
      this.row = row;
      this.col = col;
      sendCords(roomId, row, col);
      switchPlayer();
    }
  }

  @override
  void setGameOverPopUp(Function() popUp) {
    _popUp = popUp;
  }

  @override
  void setOnGameStateUpdated(Function() onUpdate) {
    _onGameStateUpdated = onUpdate;
  }

  @override
  void setUp() {
    Board board1 = BoardFactory().getTinyBoard();
    Board board2 = BoardFactory().getTinyBoardNoShips();
    player1.setBoard(board1);
    player2.setBoard(board2);
    if (isMyTurn()) {
      listenToResponse = true;
      listenToCords = false;
    } else {
      listenToResponse = false;
      listenToCords = true;
    }
  }

  void startListeningToResponse() {
    _databaseService.listenForResponse(roomId).listen((response) {
      if (response != null && listenToResponse) {
        displayOutcome(null, response);
        if (response == "hit") {
          player2.board.getSquare(row, col).setHit();
        } else if (response == "miss") {
          player2.board.getSquare(row, col).setMiss();
        } else if (response == "sunk") {
          player2.board.getSquare(row, col).setSunk();
        } else {
          _popUp();
          _onGameStateUpdated();
          return;
        }
        _onGameStateUpdated();
        listenToResponse = false;
        Future.delayed(const Duration(milliseconds: delayMilliseconds), () {
          listenToCords = true;
        });
      }
    });
  }

  void startListeningtoCords() {
    _databaseService.listenForCoordinates(roomId).listen((coordinates) {
      if (coordinates.isNotEmpty && listenToCords) {
        opponentTurn(coordinates[0], coordinates[1]);
        listenToCords = false;
        Future.delayed(const Duration(milliseconds: delayMilliseconds), () {
          listenToResponse = true;
          switchPlayer();
          _onGameStateUpdated();
        });
      }
    });
  }

  void opponentTurn(int row, int col) {
    Outcome outcome = player1.board.dropBomb(row, col);
    displayOutcome(outcome, null);
    if (outcome.gameWon) {
      sendResponse(roomId, "gameover");
      _popUp();
      _onGameStateUpdated();
    } else if (outcome.sunk != null) {
      sendResponse(roomId, "sunk");
    } else if (outcome.hit) {
      sendResponse(roomId, "hit");
    } else {
      sendResponse(roomId, "miss");
    }
  }

  void sendResponse(String roomId, String response) {
    _databaseService.sendResponse(roomId, response);
  }

  void sendCords(String roomId, int row, int column) {
    _databaseService.sendCoordinates(roomId, row, column);
  }
}
