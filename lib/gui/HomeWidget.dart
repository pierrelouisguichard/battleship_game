import 'package:battleship_game/gui/WindowWidget.dart';
import 'package:battleship_game/gui/createRoomWidget.dart';
import 'package:battleship_game/gui/join_room.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  static String routeName = '/main-menu';

  const HomeWidget({Key? key}) : super(key: key);

  void _navigateToGamePageApp(BuildContext context) {
    Navigator.pushNamed(context, WindowWidget.routeName);
  }

  void _navigateToCreateRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void _navigateToJoinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Battle Ship',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToGamePageApp(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Single Player'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToCreateRoom(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Create Room'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToJoinRoom(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
              ),
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
