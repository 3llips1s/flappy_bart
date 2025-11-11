import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class PipeGapLabel extends TextComponent {
  final String article;
  final bool isCorrectAnswer;
  final double gapCenterY;

  PipeGapLabel({
    required this.article,
    required this.isCorrectAnswer,
    required this.gapCenterY,
  }) : super(
         text: article,
         textRenderer: TextPaint(
           style: TextStyle(
             color: Colors.grey.shade300,
             fontSize: 20,
             fontWeight: FontWeight.bold,
             shadows: [
               Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
             ],
           ),
         ),
       );

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    position = Vector2(30, gapCenterY);
  }
}
