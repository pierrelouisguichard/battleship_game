import 'package:battleship_game/AbstractGame.dart';
import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/RandomStrategy.dart';
import 'package:battleship_game/firebase_options.dart';
import 'package:battleship_game/gui/GUIComputerPlayer.dart';
import 'package:battleship_game/gui/GUIGame.dart';
import 'package:battleship_game/gui/GUIHumanPlayer.dart';
import 'package:battleship_game/gui/Pages/CreateRoomPage.dart';
import 'package:battleship_game/gui/Pages/GamePage.dart';
import 'package:battleship_game/gui/Pages/HomePage.dart';
import 'package:battleship_game/gui/Pages/JoinRoomPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Widget setUpSinglePlayer() {
      AbstractPlayer player1 = GUIHumanPlayer("Player1");
      AbstractPlayer player2 = GUIComputerPlayer("Computer1", RandomStrategy());
      GUIGame game = GUIGame(player1, player2);
      return GamePage(
        game: game,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        GamePage.routeName: (context) => setUpSinglePlayer(),
        JoinRoomPage.routeName: (context) => JoinRoomPage(),
        CreateRoomScreen.routeName: (context) => CreateRoomScreen(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}
