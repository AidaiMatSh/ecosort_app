// lib/features/game/screens/game_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';

import '../data/bin_data.dart';
import '../logic/game_logic.dart';
import '../widgets/draggable_item.dart';
import '../widgets/bin_widget.dart';

class GameScreen extends StatefulWidget {
  final bool isPaused;
  final void Function(int level)? onLevelChanged;
  final int initialLevel;

  const GameScreen({
    super.key,
    this.isPaused = false,
    this.onLevelChanged,
    this.initialLevel = 1,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameLogic logic;
  Timer? timer;
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    logic = GameLogic();
    logic.level = widget.initialLevel;
    logic.startLevel();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant GameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused && !oldWidget.isPaused) {
      timer?.cancel();
    }
    if (!widget.isPaused && oldWidget.isPaused) {
      _startTimer();
    }
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.isPaused) return;
      setState(() {
        logic.tick();
        if (logic.isGameOver) {
          timer?.cancel();
          _showEndDialog(false);
        }
      });
    });
  }

  void _onCorrect() {
    setState(() => logic.score++);
    if (logic.isWin) {
      timer?.cancel();
      _showEndDialog(true);
    }
  }

  void _onWrong() {
    setState(() => logic.lives--);
    if (logic.isGameOver) {
      timer?.cancel();
      _showEndDialog(false);
    }
  }

  void _showEndDialog(bool result) {
    gameEnded = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          result ? "🎉 Уровень пройден!" : "💀 Уровень провален",
          textAlign: TextAlign.center,
        ),
        content: Text(
          result ? "Отличная работа! Переходим дальше." : "Не расстраивайся, попробуй ещё раз!",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                gameEnded = false;
                logic.resetLevel();
                _startTimer();
                widget.onLevelChanged?.call(logic.level);
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Повторить"),
          ),
          if (result)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  gameEnded = false;
                  logic.nextLevel();
                  _startTimer();
                  widget.onLevelChanged?.call(logic.level);
                });
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Далее"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
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
    final hasTimer = logic.currentLevel.hasTimer;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // ✅ Статус бар
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("⭐ ${logic.score}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Уровень ${logic.level}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              Row(
                children: [
                  Text("❤️ ${logic.lives}", style: const TextStyle(fontSize: 16)),
                  if (hasTimer) ...[
                    const SizedBox(width: 12),
                    Text(
                      "⏱ ${logic.timeLeft}s",
                      style: TextStyle(
                        fontSize: 16,
                        color: logic.timeLeft <= 5 ? Colors.red : Colors.black87,
                        fontWeight: logic.timeLeft <= 5 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // ✅ Предмет мусора — занимает ~35% экрана
        SizedBox(
          height: screenHeight * 0.32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Перетащи мусор в нужный бак:",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              DraggableItem(item: item),
            ],
          ),
        ),

        // ✅ Баки — занимают оставшееся пространство, крупные
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Первый ряд — 3 бака
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: bins.take(3).map((bin) => Expanded(
                    child: BinWidget(
                      bin: bin,
                      onAccept: (data) {
                        if (data == bin.type) {
                          _onCorrect();
                        } else {
                          _onWrong();
                        }
                        setState(() => logic.nextItem());
                      },
                    ),
                  )).toList(),
                ),
                // Второй ряд — 3 бака
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: bins.skip(3).take(3).map((bin) => Expanded(
                    child: BinWidget(
                      bin: bin,
                      onAccept: (data) {
                        if (data == bin.type) {
                          _onCorrect();
                        } else {
                          _onWrong();
                        }
                        setState(() => logic.nextItem());
                      },
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}