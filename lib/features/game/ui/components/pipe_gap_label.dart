import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class PipeGapLabel extends TextComponent {
  final String article;
  final bool isCorrectAnswer;
  final double gapStartY;

  PipeGapLabel({
    required this.article,
    required this.isCorrectAnswer,
    required this.gapStartY,
  }) : super(
         text: article,
         textRenderer: TextPaint(
           style: TextStyle(
             color: Colors.grey.shade300,
             fontSize: 20,
             fontWeight: FontWeight.bold,
           ),
         ),
       );

  @override
  FutureOr<void> onLoad() async {
    position = Vector2(15, gapStartY - 30);
  }
}
