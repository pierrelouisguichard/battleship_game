import 'package:battleship_game/Ship.dart';
import 'package:battleship_game/ships/Battleship.dart';
import 'package:battleship_game/ships/Destroyer.dart';
import 'package:battleship_game/ships/Submarine.dart';

class Fleet {
  late List<Ship> _ships;

  Fleet(int battleships, int destroyers, int submarines) {
    _ships = [];
    for (var i = 0; i < battleships; i++) {
      _ships.add(Battleship());
    }
    for (var i = 0; i < destroyers; i++) {
      _ships.add(Destroyer());
    }
    for (var i = 0; i < submarines; i++) {
      _ships.add(Submarine());
    }
  }

  List<Ship> get ships => _ships;
}
