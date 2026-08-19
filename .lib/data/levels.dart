import '../models/level.dart';
import '../models/level.dart';

final List<Level> gameLevels = [
  const Level(
    id: 1,
    emojis: ['🌞', '🌊', '🏖️', '🕶️'],
    answer: 'SUMMER',
    hint: 'Warmest season of the year',
    points: 100,
  ),
  const Level(
    id: 2,
    emojis: ['🍕', '🍔', '🍟', '🌭'],
    answer: 'FASTFOOD',
    hint: 'Quick and tasty meals',
    points: 150,
  ),
  const Level(
    id: 3,
    emojis: ['🐶', '🐱', '🐰', '🐹'],
    answer: 'PETS',
    hint: 'Furry friends at home',
    points: 200,
  ),
  const Level(
    id: 4,
    emojis: ['🎄', '🎁', '⛄', '⭐'],
    answer: 'CHRISTMAS',
    hint: 'Most wonderful time of the year',
    points: 250,
  ),
];

int get totalLevels => gameLevels.length;

int get maxPossibleScore => gameLevels.fold(0, (sum, level) => sum + level.points);
===END FILE===