import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/german_noun.dart';

class NounLabel extends TextComponent {
  final GermanNoun noun;
  late TextComponent nounText;
  late TextComponent translationText;

  NounLabel({required this.noun});

  @override
  FutureOr<void> onLoad() async {
    nounText = TextComponent(
      text: noun.noun,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.centerRight,
      position: Vector2(0, 0),
    );
    add(nounText);

    translationText = TextComponent(
      text: noun.english,
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
      ),
      anchor: Anchor.centerRight,
      position: Vector2(0, 24),
    );
    add(translationText);
  }
}
