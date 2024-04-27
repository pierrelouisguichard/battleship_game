// ignore_for_file: unused_local_variable

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/BoardFactory.dart';
import 'package:battleship_game/Fleet.dart';

void main() {
  // Board b1 = Board(10, 10);

  // Fleet fleet = Fleet(3, 3, 3);

  // b1.placeFleet(fleet);

  List<Board> boards = BoardFactory().getBigBoards();

  boards[0].displayBoard(true);
  print("");
  boards[0].displayBoard(true);
}
