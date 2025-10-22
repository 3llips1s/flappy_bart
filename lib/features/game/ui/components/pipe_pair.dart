import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';
import 'pipe.dart';
import 'pipe_gap_label.dart';

class PipePair extends PositionComponent with HasGameReference<FlappyBartGame> {
  final double topPipeHeight;
  final double bottomPipeStartY;
  final String correctArticle;
  final String incorrectArticle;

  bool scored = false;
  late Pipe topPipe;
  late Pipe bottomPipe;
  late PipeGapLabel topGapLabel;
  late PipeGapLabel bottomGapLabel;

  PipePair({
    required this.topPipeHeight,
    required this.bottomPipeStartY,
    required this.correctArticle,
    required this.incorrectArticle,
  });

  @override
  FutureOr<void> onLoad() async {
    topPipe = Pipe(
      Vector2(0, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );
    add(topPipe);

    final bottomPipeHeight = game.size.y - groundHeight - bottomPipeStartY;
    bottomPipe = Pipe(
      Vector2(0, bottomPipeStartY),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );
    add(bottomPipe);

    final isTopCorrect = Random().nextBool();

    final topGapMiddleY = topPipeHeight + (pipeGapSize / 2);

    topGapLabel = PipeGapLabel(
      article: isTopCorrect ? correctArticle : incorrectArticle,
      isCorrectAnswer: isTopCorrect,
      gapStartY: topGapMiddleY,
    );
    add(topGapLabel);

    final bottomGapMiddleY = bottomPipeStartY + (pipeGapSize / 2);

    bottomGapLabel = PipeGapLabel(
      article: !isTopCorrect ? correctArticle : incorrectArticle,
      isCorrectAnswer: !isTopCorrect,
      gapStartY: bottomGapMiddleY,
    );
    add(bottomGapLabel);
  }

  @override
  void update(double dt) {
    position.x -= groundScrollingSpeed * dt;

    if (!scored && position.x + pipeWidth < game.bird.position.x) {
      scored = true;
      game.incrementScore();
    }

    if (position.x + pipeWidth <= 0) {
      removeFromParent();
    }
  }
}
