import 'package:battleship_game/Board.dart';
import 'package:battleship_game/Outcome.dart';

abstract class CPUStrategy {
  List<int> pickMove(Board opponentBoard);
  void resultOfMove(Outcome outcome);
}
