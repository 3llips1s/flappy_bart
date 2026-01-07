import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../logic/flappy_bart_game.dart';
import 'credits_dialog.dart';

class CreditsButton extends TextComponent
    with TapCallbacks, HasGameReference<FlappyBartGame>, HasPaint {
  CreditsButton() : super(anchor: Anchor.center);

  static const _buttonColor = Color(0xFF1C4D8D);

  final double padding = 40.0;

  static final _textPaint = TextPaint(
    style: TextStyle(
      color: _buttonColor.withOpacity(0.7),
      fontSize: 26,
      fontFamily: 'MaterialIcons',
    ),
  );

  @override
  FutureOr<void> onLoad() async {
    text = String.fromCharCode(Icons.attribution_rounded.codePoint);
    textRenderer = _textPaint;

    add(
      CircleHitbox()
        ..size = Vector2(24, 24)
        ..anchor = Anchor.center,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position = Vector2(game.size.x - padding, padding);
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    scale = Vector2.all(0.8);
    add(OpacityEffect.to(0.5, EffectController(duration: 0.3)));

    showCreditsDialog(game.buildContext!);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    add(OpacityEffect.to(1.0, EffectController(duration: 0.3)));
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
    add(OpacityEffect.to(1.0, EffectController(duration: 0.3)));
  }

  @override
  void render(Canvas canvas) {
    if (!game.gameStarted) {
      super.render(canvas);
    }
  }
}
