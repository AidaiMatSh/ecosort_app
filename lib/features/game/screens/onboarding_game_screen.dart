// lib/features/game/screens/onboarding_game_screen.dart

import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../game_session.dart';

class GameTutorialScreen extends StatefulWidget {
  // ✅ isActiveTab — родитель (MainScreen) сообщает, открыта ли сейчас эта вкладка
  final bool isActiveTab;

  const GameTutorialScreen({super.key, required this.isActiveTab});

  @override
  State<GameTutorialScreen> createState() => _GameTutorialScreenState();
}

class _GameTutorialScreenState extends State<GameTutorialScreen> {
  int step = 0;
  bool showResumeMenu = false;
  bool gameStarted = false;
  int gameKey = 0; // ✅ при смене key Flutter полностью пересоздаёт GameScreen

  final List<String> texts = [
    "♻️ Эта игра — мини-симуляция реального процесса переработки мусора.",
    "В реальной жизни правильная сортировка отходов помогает:\n\n"
        "• уменьшить загрязнение окружающей среды\n"
        "• сократить количество свалок\n"
        "• увеличить переработку материалов",
    "В игре твоя задача — определить тип отхода и перетащить его в соответствующий контейнер.",
    "Правила:\n\n"
        "• каждый правильный ответ приносит очки\n"
        "• ошибки уменьшают количество жизней\n"
        "• некоторые уровни ограничены по времени",
  ];

  @override
  void didUpdateWidget(covariant GameTutorialScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ КЛЮЧЕВАЯ ЛОГИКА: отслеживаем смену вкладки через пропс
    if (!widget.isActiveTab && oldWidget.isActiveTab) {
      // Пользователь УШЁЛ с игровой вкладки
      if (gameStarted) {
        GameSession.isPaused = true;
      }
    }

    if (widget.isActiveTab && !oldWidget.isActiveTab) {
      // Пользователь ВЕРНУЛСЯ на игровую вкладку
      if (gameStarted && GameSession.isPaused) {
        setState(() {
          showResumeMenu = true;
        });
      }
    }
  }

  void next() {
    if (step < texts.length - 1) {
      setState(() => step++);
    } else {
      // Закончили обучение — запускаем игру
      setState(() {
        gameStarted = true;
        GameSession.hasActiveGame = true;
        GameSession.isPaused = false;
        GameSession.level = 1;
      });
    }
  }

  void startNewGame() {
    setState(() {
      showResumeMenu = false;
      gameKey++;
      // ✅ НЕ сбрасываем level — остаёмся на том же уровне
      GameSession.isPaused = false;
    });
  }

  void continueGame() {
    setState(() {
      showResumeMenu = false;
      GameSession.isPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ AppBar без кнопки "назад" — игра живёт внутри BottomNavBar
      appBar: AppBar(
        title: const Text("Игра ♻️"),
        automaticallyImplyLeading: false,
      ),

      body: gameStarted
          ? Stack(
              children: [
                // ✅ Передаём isPaused в GameScreen — он сам останавливает таймер
                GameScreen(
                  key: ValueKey(gameKey),
                  isPaused: GameSession.isPaused,
                  initialLevel: GameSession.level, // ✅ передаём текущий уровень
                  onLevelChanged: (level) {
                    GameSession.level = level;
                  },
                ),

                // ✅ Меню паузы поверх игры
                if (showResumeMenu)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Card(
                        margin: const EdgeInsets.all(32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "⏸️ Игра на паузе",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Уровень ${GameSession.level}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: continueGame,
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text("Продолжить"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: startNewGame,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Начать заново"),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : _buildTutorial(),
    );
  }

  Widget _buildTutorial() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Индикатор шага
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              texts.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == step ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == step ? Colors.green : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  texts[step],
                  key: ValueKey(step),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, height: 1.6),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: next,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                step == texts.length - 1 ? "Начать игру 🎮" : "Далее →",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}