import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/german_noun.dart';
import '../../nouns/data/csv_loader.dart';
import '../../nouns/logic/incorrect_nouns_tracker.dart';
import '../../nouns/logic/noun_selector.dart';
import '../ui/components/background.dart';
import '../ui/components/bird.dart';
import '../ui/components/ground.dart';
import '../ui/components/pipe_manager.dart';
import '../ui/components/pipe_pair.dart';
import '../ui/components/score.dart';
import '../ui/components/tap_to_start.dart';
import 'game_state.dart';

class FlappyBartGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late Score scoreText;

  late NounSelector nounSelector;
  late GameState gameState;
  late List<GermanNoun> allNouns;

  bool gameStarted = false;

  // double targetY = 0;

  @override
  FutureOr<void> onLoad() async {
    allNouns = await CsvLoader.loadNouns();
    nounSelector = NounSelector(allNouns);
    gameState = GameState();

    background = Background(size);
    add(background);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = Score();
    add(scoreText);

    final tapToStartText = TapToStart();
    add(tapToStartText);

    _selectNextNoun();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // follow bird vertically
    if (gameStarted && !gameState.isGameOver) {
      final halfScreenHeight = size.y / 2;
      final availableHeight = size.y - groundHeight;

      final targetY = (bird.position.y - halfScreenHeight).clamp(
        // don't shift past top
        0.0,
        // don't go below ground
        availableHeight - size.y,
      );

      // smooth lerp to target
      final currentY = camera.viewport.position.y;
      camera.viewport.position.y =
          currentY + (targetY - currentY) * cameraFollowSpeed * dt;
    } else {
      camera.viewport.position.y = 0;
    }
  }

  @override
  void onTap() {
    bird.flap();
  }

  void startGame() {
    gameStarted = true;
  }

  void _selectNextNoun() {
    final selection = nounSelector.selectNoun();
    gameState.setCurrentNOun(
      noun: selection.noun,
      correctArticle: selection.correctArticle,
      incorrectArticle: selection.incorrectArticle,
    );

    print(
      'Selected word: ${selection.noun.noun}, article: ${selection.correctArticle}',
    );
    print('GameState currentNoun: ${gameState.currentNoun?.noun}');
  }

  void onCorrectGap() {
    gameState.incrementScore();
    _selectNextNoun();
    print(
      'Score: ${gameState.score}, New word: ${gameState.currentNoun?.noun}',
    );
  }

  void gameOver() async {
    if (gameState.isGameOver) return;
    gameState.gameOver();

    if (gameState.currentNoun != null) {
      await IncorrectNounsTracker.addIncorrectNoun(gameState.currentNoun!);
    }

    pauseEngine();

    // game over dialog
    showDialog(
      context: buildContext!,
      builder:
          (context) => AlertDialog(
            title: const Text('Spiel vorbei'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Deine Punkte: ${gameState.score}'),
                const SizedBox(height: 16),
                if (gameState.currentNoun != null) ...[
                  Text(
                    'Richtige Antwort:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${gameState.correctArticle} ${gameState.currentNoun!.noun}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
    );
  }

  void resetGame() {
    bird.resetPosition();
    gameState.reset();
    nounSelector.reset();
    children.whereType<PipePair>().forEach((pipe) => pipe.removeFromParent());
    _selectNextNoun();
    gameStarted = false;
    camera.viewport.position.y = 0;
    resumeEngine();
  }
}
