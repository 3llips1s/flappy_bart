import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';
import 'ground.dart';
import 'pipe.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  // initial bird position + size
  Bird()
    : super(
        position: Vector2(birdStartX, birdStartY),
        size: Vector2(birdWidth, birdHeight),
      );

  double velocity = 0;

  // load bird
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('bird.png');

    add(CircleHitbox(radius: 15));
  }

  // jump
  void flap() {
    velocity = jumpStrength;
  }

  // update per sec.
  @override
  void update(double dt) {
    // apply gravity
    velocity += gravity * dt;

    // update position based on velocity
    position.y += velocity * dt;
  }

  // collision
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground || other is Pipe) {
      (parent as FlappyBartGame).gameOver();
    }
  }
}
