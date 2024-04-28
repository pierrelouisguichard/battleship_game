import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/RandomStrategy.dart';
import 'package:battleship_game/gui/BoardWidget.dart';
import 'package:battleship_game/gui/GUIComputerPlayer.dart';
import 'package:battleship_game/gui/GUIGame.dart';
import 'package:battleship_game/gui/GUIHumanPlayer.dart';
import 'package:flutter/material.dart';

void main() {
  AbstractPlayer player1 = GUIHumanPlayer("Human");
  AbstractPlayer player2 = GUIComputerPlayer("Computer", RandomStrategy());
  GUIGame game = GUIGame(player1, player2);
  runApp(WindowWidget(game: game));
}

class WindowWidget extends StatefulWidget {
  final GUIGame game;
  const WindowWidget({super.key, required this.game});

  @override
  State<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget> {
  bool _showPopup = false;

  void showPopup() {
    print("here");
    _showPopup = true;
  }

  @override
  void initState() {
    super.initState();
    widget.game.startGame();
    widget.game.setOnGameStateUpdated(() => refreshState());
    widget.game.setGameOverPopUp(() => showPopup());
  }

  void refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: BoardWidget(
                      game: widget.game,
                      board: widget.game.player1.board,
                      visibleShips: true,
                    ),
                  ),
                  IgnorePointer(
                    ignoring:
                        !(widget.game.currentPlayer == widget.game.player1 &&
                            !widget.game.gameOver),
                    child: BoardWidget(
                      game: widget.game,
                      board: widget.game.player2.board,
                      visibleShips: widget.game.gameOver,
                    ),
                  ),
                ],
              ),
            ),
            _showPopup
                ? AlertDialog(
                    title: Text("Game Over"),
                    content: Text("Play Again?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showPopup = false;
                          });
                          widget.game.playAgain();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
