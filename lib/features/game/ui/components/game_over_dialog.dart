import 'package:flutter/material.dart';

import '../../../../core/models/german_noun.dart';
import 'animated_article.dart';
import 'glassmorphic_components.dart';

Future<void> showGameOverDialog({
  required BuildContext context,
  required int score,
  required int highScore,
  required bool isNewRecord,
  required GermanNoun? currentNoun,
  required String? correctArticle,
  required VoidCallback onRestart,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => GameOverDialog(
          score: score,
          highScore: highScore,
          isNewRecord: isNewRecord,
          currentNoun: currentNoun,
          correctArticle: correctArticle,
          onRestart: onRestart,
        ),
  );
}

class GameOverDialog extends StatelessWidget {
  final int score;
  final int highScore;
  final bool isNewRecord;
  final GermanNoun? currentNoun;
  final String? correctArticle;
  final VoidCallback onRestart;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.highScore,
    required this.isNewRecord,
    required this.currentNoun,
    required this.correctArticle,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicDialog(
      width: 300,
      height: 480,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: GlassButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRestart();
            },
            color: const Color(0xFF1C4D8D),
            child: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _buildTitle(),
          const SizedBox(height: 32),
          _buildScoreSection(),
          if (currentNoun != null) ...[
            const SizedBox(height: 36),
            _buildNounSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      isNewRecord ? 'Neuer Rekord :)' : 'Spiel vorbei :(',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: isNewRecord ? Colors.yellow : const Color(0xFF1A252F),
      ),
    );
  }

  Widget _buildScoreSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isNewRecord ? Icons.emoji_events_rounded : Icons.star_rounded,
                color: isNewRecord ? Colors.yellow : const Color(0xFF1C4D8D),
                size: 30,
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A252F),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    score == 1 ? 'Punkt' : 'Punkte',
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
            _buildHighScoreBadge(),
          ],
        ],
      ),
    );
  }

  Widget _buildHighScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF34495E).withOpacity(0.2),
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
            style: TextStyle(fontSize: 14, color: Color(0xFF34495E)),
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
    );
  }

  Widget _buildNounSection() {
    return TweenAnimationBuilder<double>(
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
                article: correctArticle!,
                delay: const Duration(milliseconds: 300),
              ),
              const SizedBox(width: 8),
              // noun
              Text(
                currentNoun!.noun,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C4D8D),
                ),
              ),
            ],
          ),
          // translation
          Text(
            '- ${currentNoun!.english}',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Color(0xFF34495E),
            ),
          ),
        ],
      ),
    );
  }
}
