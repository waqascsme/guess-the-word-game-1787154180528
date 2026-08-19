import '../models/level.dart';
class Level {
  final int id;
  final List<String> emojis;
  final String answer;
  final String hint;
  final int points;

  const Level({
    required this.id,
    required this.emojis,
    required this.answer,
    required this.hint,
    required this.points,
  });

  String get normalizedAnswer => answer.toUpperCase().trim();

  bool checkGuess(String guess) {
    return guess.toUpperCase().trim() == normalizedAnswer;
  }

  Level copyWith({
    int? id,
    List<String>? emojis,
    String? answer,
    String? hint,
    int? points,
  }) {
    return Level(
      id: id ?? this.id,
      emojis: emojis ?? this.emojis,
      answer: answer ?? this.answer,
      hint: hint ?? this.hint,
      points: points ?? this.points,
    );
  }

  @override
  String toString() {
    return 'Level(id: $id, emojis: $emojis, answer: $answer, hint: $hint, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Level &&
        other.id == id &&
        other.emojis == emojis &&
        other.answer == answer &&
        other.hint == hint &&
        other.points == points;
  }

  @override
  int get hashCode {
    return Object.hash(id, emojis, answer, hint, points);
  }
}