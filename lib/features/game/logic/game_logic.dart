import '../data/waste_data.dart';
import '../data/levels_data.dart';
import '../models/waste_item.dart';
import '../models/level_config.dart';
class GameLogic {
  int level = 1;

  int score = 0;
  int lives = 3;
  int timeLeft = 0;

  int currentIndex = 0;

  List<WasteItem> items = List.from(levelWaste);

  LevelConfig get currentLevel => levels[level - 1];

  WasteItem get currentItem => items[currentIndex];

  void startLevel() {
    score = 0;
    lives = 3;
    timeLeft = currentLevel.time;
    currentIndex = 0;
  }

  bool checkAnswer(String itemType, String binType) {
    final isCorrect = itemType == binType;

    if (isCorrect) {
      score++;
    } else {
      lives--;
    }

    return isCorrect;
  }

  void nextItem() {
    if (currentIndex < items.length - 1) {
      currentIndex++;
    } else {
      currentIndex = 0; // цикл внутри уровня
    }
  }

  void tick() {
    if (currentLevel.hasTimer && timeLeft > 0) {
      timeLeft--;
    }
  }

  bool get isWin =>
      score >= currentLevel.targetScore &&
      lives > 0 &&
      (!currentLevel.hasTimer || timeLeft > 0);

  bool get isGameOver =>
      lives <= 0 || (currentLevel.hasTimer && timeLeft <= 0);

  bool hasNextLevel() => level < levels.length;

  void nextLevel() {
    if (hasNextLevel()) {
      level++;
    } else {
      level = 1; // цикл игры
    }
    startLevel();
  }

  void resetLevel() {
    startLevel();
  }
}