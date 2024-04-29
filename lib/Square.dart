import 'package:battleship_game/Outcome.dart';
import 'package:battleship_game/Ship.dart';

enum SquareStatus { empty, ship, hit, miss, sunk }

class Square {
  late final Ship? _ship;
  late SquareStatus _status;

  Square() {
    _status = SquareStatus.empty;
  }

  Ship? get ship => _ship;
  SquareStatus get status => _status;

  void setMiss() {
    _status = SquareStatus.miss;
  }

  void setHit() {
    _status = SquareStatus.hit;
  }

  void setSunk() {
    _status = SquareStatus.sunk;
  }

  void setShip(Ship? ship) {
    _ship = ship;
    _status = SquareStatus.ship;
    _ship!.placeShipOnSquare(this);
  }

  bool isAlreadyPlayed() {
    return _status == SquareStatus.hit ||
        _status == SquareStatus.miss ||
        _status == SquareStatus.sunk;
  }

  bool hasShip() {
    return _status == SquareStatus.ship;
  }

  Outcome bombSquare() {
    if (hasShip()) {
      _ship!.hit();
      _status = SquareStatus.hit;
      if (_ship.isSunk()) {
        _ship.sinkShip();
        return Outcome(true, _ship, false);
      }
      return Outcome(true, null, false);
    }
    _status = SquareStatus.miss;
    return Outcome(false, null, false);
  }
}
