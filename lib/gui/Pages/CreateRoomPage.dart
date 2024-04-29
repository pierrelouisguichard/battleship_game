import 'package:battleship_game/gui/Pages/WaitingRoomPage.dart';
import 'package:battleship_game/services/databaseServices.dart';
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  static String routeName = '/create-room';

  CreateRoomScreen({Key? key}) : super(key: key);

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
              'Create Room',
              style: TextStyle(fontSize: 24),
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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                String roomId =
                    await _databaseService.createRoom(_nameController.text);
                _navigateToRoomScreen(context, roomId, _nameController.text);
              },
              child: const Text('Create'),
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
              WaitingRoomPage(roomId: roomId, isTurn: true, player: player)),
    );
  }
}
