// lib/features/game/game_session.dart

class GameSession {
  // Есть ли активная игра (пользователь уже начал играть)
  static bool hasActiveGame = false;

  // Игра сейчас на паузе (ушёл на другую вкладку)
  static bool isPaused = false;

  // Текущий уровень и шаг обучения
  static int level = 1;
  static int step = 0;

  // Полный сброс
  static void reset() {
    hasActiveGame = false;
    isPaused = false;
    level = 1;
    step = 0;
  }
}