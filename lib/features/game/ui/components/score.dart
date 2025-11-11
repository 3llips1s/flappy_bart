import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../logic/flappy_bart_game.dart';

class Score extends TextComponent with HasGameReference<FlappyBartGame> {
  Score()
    : super(
        text: '0',
        textRenderer: TextPaint(
          style: TextStyle(color: Colors.grey.shade700, fontSize: 36),
        ),
      );

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      // center horizontally
      (game.size.x - size.x) / 2,

      // above bottom
      game.size.y - size.y - 60,
    );
  }

  @override
  void update(double dt) {
    final newScoreText = game.gameState.score.toString();
    if (text != newScoreText) {
      text = newScoreText;
    }
  }
}
