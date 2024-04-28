import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Square.dart';
import 'package:flutter/material.dart';

class SquareWidget extends StatelessWidget {
  final Square square;
  final bool visibleShips;
  final AbstractGame game;
  final int row;
  final int col;

  const SquareWidget(
      {Key? key,
      required this.square,
      required this.visibleShips,
      required this.game,
      required this.row,
      required this.col})
      : super(key: key);

  Color determineColour(Square square) {
    switch (square.status) {
      case SquareStatus.empty:
        return Colors.grey;
      case SquareStatus.ship:
        return visibleShips ? Colors.green : Colors.grey;
      case SquareStatus.hit:
        return Colors.orange;
      case SquareStatus.miss:
        return Colors.blue;
      case SquareStatus.sunk:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        game.takeTurn(row, col);
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: determineColour(square),
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}
