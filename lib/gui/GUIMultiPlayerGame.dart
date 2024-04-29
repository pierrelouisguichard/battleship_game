import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Outcome.dart';
import 'package:battleship_game/services/databaseServices.dart';

class GUIMultiPlayerGame extends AbstractGame {
  late Function() _onGameStateUpdated;
  late Function() _popUp;
  final DatabaseService _databaseService = DatabaseService();
  late bool turn;
  late final String roomId;
  late bool listenToResponse;
  late bool listenToCords;
  late int row;
  late int col;

  GUIMultiPlayerGame(super._player1, super._player2,
      {required this.turn, required this.roomId}) {
    row = 0;
    col = 0;
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
    Board board1 = BoardFactory().getSmallBoard();
    Board board2 = BoardFactory().getSmallBoardNoShips();
    player1.setBoard(board1);
    player2.setBoard(board2);
    if (turn) {
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
        Future.delayed(const Duration(milliseconds: 250), () {
          listenToCords = true;
        });
      }
    });
  }

  void startListeningtoCords() {
    _databaseService.listenForCoordinates(roomId).listen((coordinates) {
      if (coordinates.isNotEmpty && listenToCords) {
        takeTurn2(coordinates[0], coordinates[1]);
        listenToCords = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          listenToResponse = true;
          turn = true;
        });
      }
    });
  }

  @override
  void startGame() {
    startListeningToResponse();
    startListeningtoCords();
    setUp();
  }

  void takeTurn2(int row, int col) {
    Outcome outcome = player1.board.dropBomb(row, col);
    if (outcome.gameWon) {
      sendResponse(roomId, "gameover");
      _popUp();
      _onGameStateUpdated();
      return;
    } else if (outcome.sunk != null) {
      sendResponse(roomId, "sunk");
    } else if (outcome.hit) {
      sendResponse(roomId, "hit");
    } else {
      sendResponse(roomId, "miss");
    }
    _onGameStateUpdated();
  }

  void sendResponse(String roomId, String response) {
    _databaseService.sendResponse(roomId, response);
  }

  void sendCords(String roomId, int row, int column) {
    _databaseService.sendCoordinates(roomId, row, column);
  }

  @override
  void takeTurn(int row, int col) {
    if (turn) {
      this.row = row;
      this.col = col;
      sendCords(roomId, row, col);
      turn = false;
    }
  }
}
