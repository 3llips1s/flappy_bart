import 'dart:math';

import 'package:flame/components.dart';

import '../../../../core/constants/constants.dart';
import '../../logic/flappy_bart_game.dart';
import 'pipe_pair.dart';

class PipeManager extends Component with HasGameReference<FlappyBartGame> {
  double pipeSpawnTimer = 0;
  bool firstPipe = true;
  double firstPipeDelay = 1.5;

  @override
  void update(double dt) {
    if (!game.gameStarted) {
      pipeSpawnTimer = 0;
      firstPipe = true;
      return;
    }

    pipeSpawnTimer += dt;

    final spawnDelay = firstPipe ? firstPipeDelay : pipeInterval;

    if (pipeSpawnTimer > spawnDelay) {
      pipeSpawnTimer = 0;
      spawnPipe();
      firstPipe = false;
    }
  }

  void spawnPipe() {
    final double screenHeight = game.size.y;
    final double availableHeight = screenHeight - groundHeight;
    final double totalGapSpace = pipeGapSize * 2;
    final double maxPipeSpace = availableHeight - totalGapSpace;
    final double minRequiredSpace =
        minTopPipeHeight + minMiddlePipeHeight + minBottomPipeHeight;

    if (maxPipeSpace < minRequiredSpace) return;

    final double extraSpace = maxPipeSpace - minRequiredSpace;
    final double topExtra = Random().nextDouble() * extraSpace * 0.4;
    final double middleExtra = Random().nextDouble() * extraSpace * 0.3;

    final double topPipeHeight = minTopPipeHeight + topExtra;
    final double middlePipeHeight = minMiddlePipeHeight + middleExtra;

    final double bottomPipeStartY =
        topPipeHeight + middlePipeHeight + totalGapSpace;

    print(
      'Top: $topPipeHeight, Gap: $pipeGapSize, Middle: $middlePipeHeight, Gap: $pipeGapSize',
    );
    print('Bottom should start at: $bottomPipeStartY');
    print('Available height: $availableHeight, Ground: $groundHeight');

    final currentNoun = game.gameState.currentNoun;

    if (currentNoun == null) return;

    final pipePair = PipePair(
      topPipeHeight: topPipeHeight,
      middlePipeHeight: middlePipeHeight,
      bottomPipeStartY: bottomPipeStartY,
      correctArticle: game.gameState.correctArticle ?? 'der',
      incorrectArticle: game.gameState.incorrectArticle ?? 'die',
      noun: currentNoun,
    );

    pipePair.position = Vector2(game.size.x, 0);
    game.add(pipePair);
  }
}
