import 'package:flutter/foundation.dart';
import '../models/level.dart';
import '../data/levels.dart';
import '../models/level.dart';
import './providers/game_provider.dart';

enum GameStatus { playing, correct, incorrect, completed }

class GameProvider extends ChangeNotifier {
  int _currentLevelIndex = 0;
  int _score = 0;
  int _attempts = 0;
  GameStatus _status = GameStatus.playing;
  String _lastGuess = '';
  String _feedbackMessage = '';

  int get currentLevelIndex => _currentLevelIndex;
  Level get currentLevel => gameLevels[_currentLevelIndex];
  int get score => _score;
  int get attempts => _attempts;
  GameStatus get status => _status;
  String get lastGuess => _lastGuess;
  String get feedbackMessage => _feedbackMessage;
  bool get isGameCompleted => _currentLevelIndex >= gameLevels.length;
  double get progress => (_currentLevelIndex / gameLevels.length).clamp(0.0, 1.0);
  int get currentLevelNumber => _currentLevelIndex + 1;
  int get totalLevels => gameLevels.length;

  void submitGuess(String guess) {
    if (isGameCompleted) return;

    final trimmedGuess = guess.trim();
    if (trimmedGuess.isEmpty) return;

    _lastGuess = trimmedGuess;
    _attempts++;

    final level = currentLevel;
    if (level.checkGuess(trimmedGuess)) {
      _status = GameStatus.correct;
      _score += level.points;
      _feedbackMessage = 'Correct! +${level.points} points';
      notifyListeners();
      
      Future.delayed(const Duration(milliseconds: 1500), () {
        _advanceLevel();
      });
    } else {
      _status = GameStatus.incorrect;
      _feedbackMessage = 'Not quite right. Try again!';
      notifyListeners();
    }
  }

  void _advanceLevel() {
    _currentLevelIndex++;
    if (_currentLevelIndex >= gameLevels.length) {
      _status = GameStatus.completed;
      _feedbackMessage = 'Congratulations! You completed all levels!';
    } else {
      _status = GameStatus.playing;
      _feedbackMessage = '';
    }
    _attempts = 0;
    notifyListeners();
  }

  void resetStatus() {
    if (_status == GameStatus.correct || _status == GameStatus.incorrect) {
      _status = GameStatus.playing;
      _feedbackMessage = '';
      notifyListeners();
    }
  }

  void resetGame() {
    _currentLevelIndex = 0;
    _score = 0;
    _attempts = 0;
    _status = GameStatus.playing;
    _lastGuess = '';
    _feedbackMessage = '';
    notifyListeners();
  }
}
===END FILE===