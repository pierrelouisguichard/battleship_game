import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/gui/Widgets/SquareWidget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatefulWidget {
  final Board board;
  final bool visibleShips;
  final AbstractGame game;

  const BoardWidget(
      {super.key,
      required this.visibleShips,
      required this.board,
      required this.game});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.board.size,
        (row) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.board.size,
            (col) => SquareWidget(
              game: widget.game,
              square: widget.board.getSquare(row, col),
              visibleShips: widget.visibleShips,
              row: row,
              col: col,
            ),
          ),
        ),
      ),
    );
  }
}
