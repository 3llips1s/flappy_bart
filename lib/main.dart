import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/game/logic/flappy_bart_game.dart';
import 'features/nouns/data/csv_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CsvLoader.loadNouns();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,

      systemNavigationBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _enforceFullScreen();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _enforceFullScreen();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enforceFullScreen();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _enforceFullScreen();
  }

  Future<void> _enforceFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,

        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: GameWidget(game: FlappyBartGame()),
      ),
    );
  }
}
