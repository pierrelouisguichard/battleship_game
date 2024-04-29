import 'package:battleship_game/AbstractPlayer.dart';
import 'package:battleship_game/Board.dart';
import 'package:battleship_game/RandomStrategy.dart';
import 'package:battleship_game/firebase_options.dart';
import 'package:battleship_game/gui/GUIComputerPlayer.dart';
import 'package:battleship_game/gui/GUIGame.dart';
import 'package:battleship_game/gui/GUIHumanPlayer.dart';
import 'package:battleship_game/gui/HomeWidget.dart';
import 'package:battleship_game/gui/WindowWidget.dart';
import 'package:battleship_game/gui/createRoomWidget.dart';
import 'package:battleship_game/gui/join_room.dart';
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

      return WindowWidget(
        game: game,
      );
    }

    return MaterialApp(
      routes: {
        HomeWidget.routeName: (context) => const HomeWidget(),
        WindowWidget.routeName: (context) => setUpSinglePlayer(),
        JoinRoomScreen.routeName: (context) => JoinRoomScreen(),
        CreateRoomScreen.routeName: (context) => CreateRoomScreen(),
        // BattleshipApp.routeName: (context) => BattleshipApp(),
        // MultiplayerApp.routeName: (context) => MultiplayerApp(
        //       roomId: '',
        //       isTurn: true,
        //       player: '',
        //     ),
      },
      initialRoute: HomeWidget.routeName,
    );
  }
}
