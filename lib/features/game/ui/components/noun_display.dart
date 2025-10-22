import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../logic/flappy_bart_game.dart';

class NounDisplay extends TextComponent with HasGameReference<FlappyBartGame> {
  NounDisplay()
    : super(
        text: '',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  FutureOr<void> onLoad() async {
    position = Vector2((game.size.x - size.x) / 2, 30);
  }

  @override
  void update(double dt) {
    final noun = game.gameState.currentNoun;
    final newText = noun?.noun ?? '';

    if (text != newText) {
      text = newText;
    }
  }
}
