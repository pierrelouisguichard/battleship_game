import 'package:battleship_game/gui/waitingRoomWidget.dart';
import 'package:battleship_game/services/databaseServices.dart';
import 'package:flutter/material.dart';

class JoinRoomScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  static String routeName = '/join-room';

  JoinRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Join Room',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your nickname',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _roomController,
                decoration: const InputDecoration(
                  hintText: 'Enter Game ID',
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                String? roomId = await _databaseService.joinRoom(
                    _roomController.text, _nameController.text);
                if (roomId != null) {
                  print('Joined room with ID: ${_roomController.text}');

                  _navigateToRoomScreen(context, roomId, _nameController.text);
                } else {
                  print('Room not found');
                }
              },
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRoomScreen(
      BuildContext context, String roomId, String player) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GameRoom(roomId: roomId, isTurn: false, player: player)),
    );
  }
}
