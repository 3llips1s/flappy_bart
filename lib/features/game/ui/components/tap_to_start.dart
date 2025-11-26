import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';

class TapToStart extends TextComponent with HasGameReference<FlappyBartGame> {
  double pulseTimer = 0;

  TapToStart()
    : super(
        text: 'Zum Start tappen',
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white70, fontSize: 20),
        ),
      );

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    position = Vector2(game.size.x / 2, (game.size.y - groundHeight) / 2 + 60);

    // pulse animation
    pulseTimer += dt;
    final pulse = 1.0 + sin(pulseTimer * 3) * 0.1;
    scale = Vector2.all(pulse);
  }

  @override
  void render(Canvas canvas) {
    // render only if game hasn't started
    if (!game.gameStarted) {
      super.render(canvas);
    }
  }
}
