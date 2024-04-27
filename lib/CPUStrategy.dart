import 'package:battleship_game/Board.dart';

abstract class CPUStrategy {
  List<int> pickMove(Board opponentBoard);
}
