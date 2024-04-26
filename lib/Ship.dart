import 'package:battleship_game/Square.dart';

class Ship {
  final String _name;
  final int _size;
  late int _health;
  late List<Square> _position;

  Ship(this._name, this._size) {
    _position = [];
    _health = _size;
  }

  int get size => _size;

  String getCodeCharacter() {
    return _name[0];
  }

  void placeShipOnSquare(Square square) {
    _position.add(square);
  }

  void hit() {
    _health--;
  }

  void sinkShip() {
    for (Square square in _position) {
      square.setSunk();
    }
  }

  bool isSunk() {
    return _health <= 0;
  }
}
