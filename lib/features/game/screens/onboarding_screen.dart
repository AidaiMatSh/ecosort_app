import 'package:flutter/material.dart';
import 'game_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                texts[step],
                key: ValueKey(step),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: next,
              child: Text(
                step == texts.length - 1 ? "Начать игру" : "Далее",
              ),
            ),
          ],
        ),
      ),
    );
  }
}