import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/input.dart';

import '../../components/background.dart';
import '../../components/bird.dart';
import '../../components/ground.dart';

/* 

  basic game components:

  1. bird
  2. ground + background
  3. pipes
  4. scores
  
   */

class FlappyBartGame extends FlameGame with TapDetector {
  late Bird bird;
  late Background background;
  late Ground ground;

  @override
  FutureOr<void> onLoad() {
    background = Background(size);
    add(background);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);
  }

  @override
  void onTap() {
    bird.flap();
  }
}
