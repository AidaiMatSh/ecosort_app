import 'package:flutter/material.dart';
import 'game_screen.dart';

class GameTutorialScreen extends StatefulWidget {
  const GameTutorialScreen({super.key});

  @override
  State<GameTutorialScreen> createState() => _GameTutorialScreenState();
}

class _GameTutorialScreenState extends State<GameTutorialScreen> {
  int step = 0;

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

  void next() {
    if (step < texts.length - 1) {
      setState(() {
        step++;
      });
    } else {
      // Переход непосредственно к игровому процессу
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const GameScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Обучение")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    texts[step],
                    key: ValueKey(step),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: next,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                step == texts.length - 1 ? "Начать игру" : "Далее",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}