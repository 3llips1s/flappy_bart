import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'features/game/logic/flappy_bart_game.dart';
import 'features/nouns/data/csv_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  await CsvLoader.loadNouns();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: GameWidget(game: FlappyBartGame()),
    );
  }
}
