import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameReference<FlappyBartGame> {
  final bool isTopPipe;

  bool scored = false;

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
    : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(isTopPipe ? 'top_pipe.png' : 'bottom_pipe.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // scroll pipe to the left
    position.x -= groundScrollingSpeed * dt;

    // check if beard has passed pipe
    if (!scored && position.x + size.x < game.bird.position.x) {
      scored = true;

      // increment for top pipes only
      if (isTopPipe) {
        game.incrementScore();
      }
    }

    // remove pipe when off screen
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
