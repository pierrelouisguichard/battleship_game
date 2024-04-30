import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/gui/Pages/HomePage.dart';
import 'package:battleship_game/gui/Widgets/BoardWidget.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final AbstractGame game;
  const GamePage({super.key, required this.game});

  static String routeName = '/gamePage';

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _showPopup = false;

  void showPopup() {
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

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
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
                  const Text(
                    "Opponent's Board",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            Positioned(
              left: 20,
              child: Text(
                "${widget.game.currentPlayer == widget.game.player1 ? 'Your' : 'Opponent\'s'} turn",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                widget.game.result,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _showPopup
                ? AlertDialog(
                    title: Text("Game Over, ${widget.game.result}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showPopup = false;
                          });
                          _navigateToHomePage(context);
                        },
                        child: const Text("Exit"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showPopup = false;
                          });
                          widget.game.playAgain();
                        },
                        child: const Text("Play Again"),
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
