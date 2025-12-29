import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../../core/audio/audio_manager.dart';
import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';

class AudioButton extends TextComponent
    with TapCallbacks, HasGameReference<FlappyBartGame>, HasPaint {
  AudioButton() : super(anchor: Anchor.center);

  static const _speakerColor = Color(0xFF1C4D8D);

  static final _soundOn = TextPaint(
    style: const TextStyle(
      color: _speakerColor,
      fontSize: 24,
      fontFamily: 'MaterialIcons',
    ),
  );

  static final _soundOff = TextPaint(
    style: TextStyle(
      color: _speakerColor.withOpacity(0.7),
      fontSize: 24,
      fontFamily: 'MaterialIcons',
    ),
  );

  @override
  FutureOr<void> onLoad() async {
    text = _getIconString();

    textRenderer = AudioManager.isMuted ? _soundOff : _soundOn;

    add(
      CircleHitbox()
        ..size = Vector2(24, 24)
        ..anchor = Anchor.center,
    );
  }

  String _getIconString() {
    final iconData =
        AudioManager.isMuted ? Icons.volume_off_rounded : Icons.volume_up_sharp;
    return String.fromCharCode(iconData.codePoint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position = Vector2(32, (game.size.y - groundHeight) - 40);

    // update icon on state change
    final currentIconString = _getIconString();
    if (text != currentIconString) {
      text = currentIconString;

      textRenderer = AudioManager.isMuted ? _soundOff : _soundOn;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    AudioManager.toggleMute();
    scale = Vector2.all(0.8);
    add(OpacityEffect.to(0.5, EffectController(duration: 0.3)));
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
