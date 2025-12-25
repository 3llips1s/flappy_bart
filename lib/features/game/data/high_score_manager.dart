import 'package:shared_preferences/shared_preferences.dart';

// spell: words prefs

class HighScoreManager {
  static const String _highScoreKey = 'flappy_bart_high_score';

  static Future<int> getHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      print('Error getting high score: $e');
      return 0;
    }
  }

  static Future<bool> updateHighScore(int score) async {
    try {
      final currentHighScore = await getHighScore();

      if (score > currentHighScore) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_highScoreKey, score);
        return true;
      }

      return false;
    } catch (e) {
      print('error updating high score: $e');
      return false;
    }
  }

  static Future<bool> isNewHighSCore(int score) async {
    final currentHighScore = await getHighScore();
    return score > currentHighScore;
  }

  static Future<void> resetHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highScoreKey);
    } catch (e) {
      print('error resetting high score: $e');
    }
  }
}
