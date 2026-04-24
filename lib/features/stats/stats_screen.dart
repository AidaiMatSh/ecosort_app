import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/waste_entry.dart';
import 'add_data_screen.dart';
import 'widgets_stats/bar_chart_widget.dart';
import 'widgets_stats/line_chart_widget.dart';
import 'widgets_stats/pie_chart_widget.dart';
import 'widgets_stats/summary_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<WasteEntry> entries = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList("waste_data") ?? [];

    final loaded = data.map((e) {
      return WasteEntry.fromJson(jsonDecode(e));
    }).toList();

    loaded.sort((a, b) => a.date.compareTo(b.date));

    setState(() {
      entries = loaded;
    });
  }

Future<void> clearData() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Очистить данные"),
      content: const Text("Удалить всю статистику отходов?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Отмена"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Удалить"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("waste_data");

  setState(() {
    entries = [];
  });
}


  double get totalAmount {
    return entries.fold(0, (sum, e) => sum + e.amount);
  }

  Map<String, double> get categoryData {
    final Map<String, double> result = {};

    for (final e in entries) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }

    return result;
  }

  // По дням: ключ — индекс точки, чтобы подписи шли по порядку
  Map<int, double> get dailyChartData {
    final Map<int, double> result = {};

    for (int i = 0; i < entries.length; i++) {
      result[i] = entries[i].amount;
    }

    return result;
  }

  // Подписи по дням
  Map<int, String> get dailyLabels {
    final Map<int, String> labels = {};

    for (int i = 0; i < entries.length; i++) {
      final d = entries[i].date;
      labels[i] = "${d.day}.${d.month}";
    }

    return labels;
  }

  // По месяцам
  Map<int, double> get monthlyData {
    final Map<int, double> result = {};

    for (final e in entries) {
      final month = e.date.month;
      result[month] = (result[month] ?? 0) + e.amount;
    }

    return result;
  }

  Map<int, String> get monthLabels {
    return {
      1: "Янв",
      2: "Фев",
      3: "Мар",
      4: "Апр",
      5: "Май",
      6: "Июн",
      7: "Июл",
      8: "Авг",
      9: "Сен",
      10: "Окт",
      11: "Ноя",
      12: "Дек",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Статистика"),
        actions: [
          IconButton(
            onPressed: clearData,
            icon: const Icon(Icons.delete),
            tooltip: "Очистить данные",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddDataScreen(),
                      ),
                    );

                    if (result == true) {
                      await loadData();
                    }
                  },
                  child: const Text("Добавить данные"),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SummaryCard(total: totalAmount),

            const SizedBox(height: 16),

            PieChartWidget(data: categoryData),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Добавления по датам",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            LineChartWidget(
              data: dailyChartData,
              labels: dailyLabels,
            ),

            const SizedBox(height: 16),

            BarChartWidget(
              data: dailyChartData,
              labels: dailyLabels,
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Статистика по месяцам",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            BarChartWidget(
              data: monthlyData,
              labels: monthLabels,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
