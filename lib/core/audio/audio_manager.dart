import 'dart:developer' as developer;

import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool _isInitialized = false;
  static bool _isMuted = false;
  static bool _isMusicPlaying = false;

  static const double musicVolume = 0.25;
  static const double flapVolume = 0.30;
  static const double correctVolume = 0.7;
  static const double incorrectVolume = 0.5;

  // preload sounds
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await FlameAudio.audioCache.loadAll([
        'flap.mp3',
        'correct.mp3',
        'incorrect.mp3',
      ]);

      await FlameAudio.audioCache.load('background.mp3');

      _isInitialized = true;
    } catch (e) {
      developer.log('Audio initialization error: $e');
    }
  }

  static Future<void> startBackgroundMusic() async {
    if (!_isInitialized || _isMuted || _isMusicPlaying) return;

    try {
      await FlameAudio.bgm.play('background.mp3', volume: musicVolume);
      _isMusicPlaying = true;
    } catch (e) {
      developer.log('music start error: $e');
    }
  }

  static void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
    _isMusicPlaying = false;
  }

  static void pauseBackgroundMusic() {
    FlameAudio.bgm.pause();
  }

  static void resumeBackgroundMusic() {
    if (!_isMuted && _isMusicPlaying) {
      FlameAudio.bgm.resume();
    }
  }

  static void playFlap() {
    if (!_isInitialized || _isMuted) return;
    FlameAudio.play('flap.mp3', volume: flapVolume);
  }

  static void playCorrect() {
    if (!_isInitialized || _isMuted) return;
    FlameAudio.play('correct.mp3', volume: correctVolume);
  }

  static void playIncorrect() {
    if (!_isInitialized || _isMuted) return;
    FlameAudio.play('incorrect.mp3', volume: incorrectVolume);
  }

  static void toggleMute() {
    _isMuted = !_isMuted;

    if (_isMuted) {
      pauseBackgroundMusic();
    } else {
      resumeBackgroundMusic();
    }
  }

  static bool get isMuted => _isMuted;

  static void dispose() {
    FlameAudio.bgm.dispose();
    _isInitialized = false;
    _isMusicPlaying = false;
  }
}
