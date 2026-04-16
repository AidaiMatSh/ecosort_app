import 'dart:async';
import 'package:flutter/material.dart';

import '../data/bin_data.dart';
import '../logic/game_logic.dart';
import '../widgets/draggable_item.dart';
import '../widgets/bin_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameLogic logic = GameLogic();

  Timer? timer;

  bool gameEnded = false;
  bool win = false;

  @override
  void initState() {
    super.initState();
    logic.startLevel();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        logic.tick();

        if (logic.isGameOver) {
          timer?.cancel();
          showEndDialog(false);
        }
      });
    });
  }

  void onCorrect() {
    setState(() {
      logic.score++;
    });

    if (logic.isWin) {
      timer?.cancel();
      showEndDialog(true);
    }
  }

  void onWrong() {
    setState(() {
      logic.lives--;
    });

    if (logic.isGameOver) {
      timer?.cancel();
      showEndDialog(false);
    }
  }

  void showEndDialog(bool result) {
    gameEnded = true;
    win = result;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(
            result ? "🎉 Уровень пройден!" : "💀 Уровень провален",
          ),
          content: Text(
            result
                ? "Ты прошёл уровень, можешь идти дальше!"
                : "Ты проиграл. Попробуй ещё раз.",
          ),
          actions: [
            // 🔁 ВСЕГДА можно повторить
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  gameEnded = false;
                  logic.resetLevel();
                  startTimer();
                });
              },
              child: const Text("Повторить"),
            ),

            // 🚫 ТОЛЬКО ЕСЛИ WIN
            if (result)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  setState(() {
                    gameEnded = false;
                    logic.nextLevel();
                    startTimer();
                  });
                },
                child: const Text("Далее"),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = logic.currentItem;
    final level = logic.level;

    return Scaffold(
      appBar: AppBar(
        title: Text("Уровень $level ♻️"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("⭐ Очки: ${logic.score}"),
                Text("❤️ Жизни: ${logic.lives}"),
                Text("⏳ ${logic.timeLeft}s"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          DraggableItem(item: item),

          const Spacer(),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: bins.take(3).map((bin) {
                  return BinWidget(
                    bin: bin,
                    onAccept: (data) {
                      if (data == bin.type) {
                        onCorrect();
                      } else {
                        onWrong();
                      }

                      setState(() {
                        logic.nextItem();
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: bins.skip(3).take(3).map((bin) {
                  return BinWidget(
                    bin: bin,
                    onAccept: (data) {
                      if (data == bin.type) {
                        onCorrect();
                      } else {
                        onWrong();
                      }

                      setState(() {
                        logic.nextItem();
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}