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
import '../ui/components/pipe.dart';
import '../ui/components/pipe_manager.dart';
import '../ui/components/score.dart';
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

  bool isGameOver = false;

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

    _selectNextNoun();
  }

  @override
  void onTap() {
    bird.flap();
  }

  int score = 0;

  void incrementScore() {
    score++;
  }

  void _selectNextNoun() {
    final selection = nounSelector.selectNoun();
    gameState.setCurrentNOun(
      noun: selection.noun,
      correctArticle: selection.correctArticle,
      incorrectArticle: selection.incorrectArticle,
    );
  }

  void onGapSelected(bool isCorrect) {
    if (isCorrect) {
      gameState.incrementScore();
      _selectNextNoun();
    } else {
      IncorrectNounsTracker.addIncorrectNoun(gameState.currentNoun!);
      gameOver();
    }
  }

  void gameOver() {
    if (gameState.isGameOver) return;
    gameState.gameOver();
    pauseEngine();

    // game over dialog
    showDialog(
      context: buildContext!,
      builder:
          (context) => AlertDialog(
            title: const Text('Spiel vorbei'),
            content: Text('Deine Punkte: ${score.toString()}'),
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
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;
    isGameOver = false;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}
