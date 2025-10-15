import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappy_bart/game/logic/flappy_bart_game.dart';

import '../constants/constants.dart';

class Ground extends SpriteComponent with HasGameReference<FlappyBartGame> {
  Ground() : super();

  // load
  @override
  FutureOr<void> onLoad() async {
    size = Vector2(2 * game.size.x, groundHeight);
    position = Vector2(0, game.size.y - groundHeight);

    sprite = await Sprite.load('ground.png');
  }

  // move ground to the left
  @override
  void update(double dt) {
    position.x -= groundScrollingSpeed * dt;

    // infinite scroll - reset ground if it half has been passed
    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
  }
}
