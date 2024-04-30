import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/gui/GUIHumanPlayer.dart';
import 'package:battleship_game/gui/GUIMultiPlayerGame.dart';
import 'package:battleship_game/gui/Pages/GamePage.dart';
import 'package:battleship_game/services/databaseServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingRoomPage extends StatefulWidget {
  final String roomId;
  final bool isTurn;
  final String player;

  const WaitingRoomPage(
      {Key? key,
      required this.roomId,
      required this.isTurn,
      required this.player})
      : super(key: key);

  @override
  State<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {
  final DatabaseService _databaseService = DatabaseService();
  late Stream<bool> _roomStream;
  late GUIMultiPlayerGame _game;

  @override
  void initState() {
    super.initState();
    _roomStream = _databaseService.roomStatusStream(widget.roomId);
    AbstractPlayer player1 = GUIHumanPlayer("Player1");
    AbstractPlayer player2 = GUIHumanPlayer("Player2");
    _game = GUIMultiPlayerGame(player1, player2, roomId: widget.roomId);
    if (!widget.isTurn) {
      _game.startSecond();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: _roomStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildWaitingScreen();
          } else if (snapshot.hasError) {
            return _buildErrorScreen(snapshot.error.toString());
          } else {
            bool isFull = snapshot.data ?? false;
            return isFull
                ? GamePage(
                    game: _game,
                  )
                : _buildWaitingScreen();
          }
        },
      ),
    );
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Waiting for another user to join...'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Room Code: ${widget.roomId}'),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.roomId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Room code copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }
}
