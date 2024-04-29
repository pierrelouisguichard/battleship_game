import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/gui/BoardWidget.dart';
import 'package:flutter/material.dart';

class WindowWidget extends StatefulWidget {
  final AbstractGame game;
  const WindowWidget({super.key, required this.game});

  static String routeName = '/gamePage';

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
        appBar: AppBar(
          title: Text("Battleship Game"),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Your Board",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: BoardWidget(
                      game: widget.game,
                      board: widget.game.player1.board,
                      visibleShips: true,
                    ),
                  ),
                  Text(
                    "Opponent's Board",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: false,
                    // !(widget.game.currentPlayer == widget.game.player1 &&
                    //     !widget.game.gameOver),
                    child: BoardWidget(
                      game: widget.game,
                      board: widget.game.player2.board,
                      visibleShips: widget.game.gameOver,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              child: Text(
                "${widget.game.currentPlayer.name}'s turn",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                "...",
                // "${widget.game.result}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _showPopup
                ? AlertDialog(
                    title: Text(
                        "Game Over, ${widget.game.currentPlayer.name} Won!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showPopup = false;
                          });
                          widget.game.playAgain();
                        },
                        child: Text("Play Again"),
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
