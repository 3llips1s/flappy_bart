import 'dart:async';

import 'package:flame/components.dart';

import '../constants/constants.dart';

class Bird extends SpriteComponent {
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
}
