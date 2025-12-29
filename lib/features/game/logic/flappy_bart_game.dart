import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/audio/audio_manager.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/german_noun.dart';
import '../../nouns/data/csv_loader.dart';
import '../../nouns/logic/incorrect_nouns_tracker.dart';
import '../../nouns/logic/noun_selector.dart';
import '../data/high_score_manager.dart';
import '../ui/components/animated_article.dart';
import '../ui/components/audio_button.dart';
import '../ui/components/background.dart';
import '../ui/components/bird.dart';
import '../ui/components/game_over_dialog.dart';
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
  bool _musicStarted = false;

  @override
  FutureOr<void> onLoad() async {
    await AudioManager.initialize();

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

    final audioButton = AudioButton();
    add(audioButton);

    if (!kIsWeb) {
      AudioManager.startBackgroundMusic();
      _musicStarted = true;
    }

    _selectNextNoun();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameStarted && !gameState.isGameOver) {
      // center bird on screen + offsetting camera
      final screenCenter = size.y / 2;
      final birdY = bird.position.y;

      // bird offset from center
      final offset = birdY - screenCenter;

      final currentCameraY = camera.viewport.position.y;
      // negative offset since camera moves opposite
      final targetCameraY = -offset;

      camera.viewport.position.y =
          currentCameraY +
          (targetCameraY - currentCameraY) * cameraFollowSpeed * dt;
    } else {
      camera.viewport.position.y = 0;
    }
  }

  @override
  void onTap() {
    if (kIsWeb && !_musicStarted) {
      AudioManager.startBackgroundMusic();
      _musicStarted = true;
    }

    AudioManager.playFlap();

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
    AudioManager.playCorrect();
    gameState.incrementScore();
    _selectNextNoun();
    print(
      'Score: ${gameState.score}, New word: ${gameState.currentNoun?.noun}',
    );
  }

  void gameOver() async {
    if (gameState.isGameOver) return;
    AudioManager.playIncorrect();
    gameState.gameOver();
    AudioManager.pauseBackgroundMusic();

    if (gameState.currentNoun != null) {
      await IncorrectNounsTracker.addIncorrectNoun(gameState.currentNoun!);
    }

    final isNewRecord = await HighScoreManager.updateHighScore(gameState.score);
    final highScore = await HighScoreManager.getHighScore();

    pauseEngine();

    showGlassDialog(
      context: buildContext!,
      width: 300,
      height: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),

          // title
          Text(
            isNewRecord ? 'Neuer Rekord :)' : 'Spiel vorbei :(',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: isNewRecord ? Color(0xFFFF9800) : Color(0xFF1A252F),
            ),
          ),

          const SizedBox(height: 32),

          // score
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isNewRecord
                          ? Icons.emoji_events_rounded
                          : Icons.star_rounded,
                      color:
                          isNewRecord
                              ? const Color(0xFFE67E22)
                              : const Color(0XFF1C4D8D),

                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${gameState.score}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A252F),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          gameState.score == 1 ? 'Punkt' : 'Punkte',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF34495E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (!isNewRecord && highScore > 0) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF34495E).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          size: 14,
                          color: Colors.yellow,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Rekord: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF34495E),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$highScore',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (gameState.currentNoun != null) ...[
            const SizedBox(height: 36),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              builder: (context, fadeValue, child) {
                return Opacity(opacity: fadeValue, child: child);
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      // animated correct article
                      AnimatedArticle(
                        article: gameState.correctArticle!,
                        delay: const Duration(milliseconds: 300),
                      ),

                      const SizedBox(width: 8),

                      // noun
                      Text(
                        gameState.currentNoun!.noun,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF1C4D8D),
                        ),
                      ),
                    ],
                  ),

                  // translation
                  Text(
                    '- ${gameState.currentNoun!.english}',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF34495E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: GlassButton(
            onPressed: () {
              Navigator.of(buildContext!).pop();
              resetGame();
            },
            color: Color(0XFF1C4D8D),
            child: Icon(Icons.refresh_rounded, color: Colors.white, size: 32),
          ),
        ),
      ],
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

    if (!AudioManager.isMuted) {
      AudioManager.resumeBackgroundMusic();
    }
    resumeEngine();
  }

  @override
  void onRemove() {
    AudioManager.dispose();
    super.onRemove();
  }
}
