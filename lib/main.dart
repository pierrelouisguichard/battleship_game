// ignore_for_file: unused_local_variable

import 'package:battleship_game/Board.dart';
import 'package:battleship_game/Ship.dart';
import 'package:battleship_game/ships/Battleship.dart';

void main() {
  Board b1 = Board(5, 5);

  Ship s1 = Battleship();

  b1.placeShipRandomly(s1);
  // b1.placeShipRandomly(s2);

  b1.displayBoard(true);
}
