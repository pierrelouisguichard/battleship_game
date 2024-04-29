// ignore_for_file: avoid_print

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
    Board board1 = BoardFactory().getTinyBoard();
    Board board2 = BoardFactory().getTinyBoardNoShips();
    player1.setBoard(board1);
    player2.setBoard(board2);
    if (turn) {
      print('Listen to Cords = false');
      listenToResponse = true;
      print('Listen to Response = true');
      listenToCords = false;
    } else {
      print('Listen to Response = false');
      listenToResponse = false;
      print('Listen to Cords = true');
      listenToCords = true;
    }
  }

  void startListeningToResponse() {
    print('CALLING startListeningToResponse');
    _databaseService.listenForResponse(roomId).listen((response) {
      if (response != null && listenToResponse) {
        print('HANDLE $response');
        if (response == "hit") {
          print("received: $response, hit");
          player2.board.getSquare(row, col).setHit();
        } else if (response == "miss") {
          print("received: $response, miss");
          player2.board.getSquare(row, col).setMiss();
        } else if (response == "sunk") {
          print("received: $response, sunk");
          player2.board.getSquare(row, col).setSunk();
        } else {
          _popUp();
          _onGameStateUpdated();
          return;
        }
        _onGameStateUpdated();
        listenToResponse = false;
        print('Listen to Response = false');
        Future.delayed(const Duration(milliseconds: 250), () {
          listenToCords = true;
          print('0.5sec pause');
          print('Listen to Cords = true');
        });
      }
    });
  }

  void startListeningtoCords() {
    print('CALLING startListeningtoCords');
    _databaseService.listenForCoordinates(roomId).listen((coordinates) {
      if (coordinates.isNotEmpty && listenToCords) {
        print('received cords: $coordinates');
        takeTurn2(coordinates[0], coordinates[1]);
        print('Listen to Cords = false');
        listenToCords = false;
        Future.delayed(Duration(milliseconds: 500), () {
          print('1sec pause');
          listenToResponse = true;
          print('Listen to Response = true');
          print('play true');
          turn = true;
          print(' ');
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
    print('CALLING SEND RESPONSE');
    print('sent response: $response');
    _databaseService.sendResponse(roomId, response);
  }

  void sendCords(String roomId, int row, int column) {
    print('CALLING SEND CORDS');
    print('sent cords: [$row, $column]');
    _databaseService.sendCoordinates(roomId, row, column);
  }

  @override
  void takeTurn(int row, int col) {
    if (turn) {
      this.row = row;
      this.col = col;
      sendCords(roomId, row, col);
      print('play off');
      turn = false;
    }
  }
}
