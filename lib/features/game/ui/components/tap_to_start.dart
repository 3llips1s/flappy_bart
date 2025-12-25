import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';

class TapToStart extends TextComponent with HasGameReference<FlappyBartGame> {
  double pulseTimer = 0;

  final double pulseSpeed = 0.5;
  final double pulseAmplitude = 0.05;

  TapToStart()
    : super(
        text: 'zum Start tappen',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0XFF1C4D8D),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    position = Vector2(game.size.x / 2, (game.size.y - groundHeight) - 40);

    // pulse animation
    pulseTimer += dt;
    final pulse = 1.0 + sin(pulseTimer * pulseSpeed * 2 * pi) * pulseAmplitude;
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
