import 'dart:math';

import 'package:flame/components.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';
import 'pipe_pair.dart';

class PipeManager extends Component with HasGameReference<FlappyBartGame> {
  double pipeSpawnTimer = 0;

  @override
  void update(double dt) {
    pipeSpawnTimer += dt;

    if (pipeSpawnTimer > pipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  void spawnPipe() {
    final double screenHeight = game.size.y;

    // heights
    final double availableHeight = screenHeight - groundHeight;

    final double totalGapSpace = (pipeGapSize * 2) + pipeGapSpacing;

    final double maxPipeSpace = availableHeight - totalGapSpace;

    if (maxPipeSpace < (minTopPipeHeight + minBottomPipeHeight)) return;

    final double randomRange =
        maxPipeSpace - minTopPipeHeight - minBottomPipeHeight;
    final double topPipeHeight =
        minTopPipeHeight + Random().nextDouble() * randomRange;

    final double topGapStartY = topPipeHeight;
    final double topGapEndY = topGapStartY + pipeGapSize;

    final double bottomGapStartY = topGapEndY + pipeGapSpacing;
    final double bottomGapEndY = bottomGapStartY + pipeGapSize;

    final double bottomPipeY = bottomGapEndY;

    final pipePair = PipePair(
      topPipeHeight: topPipeHeight,
      bottomPipeStartY: bottomPipeY,
      correctArticle: game.gameState.correctArticle ?? 'der',
      incorrectArticle: game.gameState.incorrectArticle ?? 'die',
    );

    pipePair.position = Vector2(game.size.x, 0);

    game.add(pipePair);
  }
}
