import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets_stats/pie_chart_widget.dart';
import 'widgets_stats/line_chart_widget.dart';
import 'widgets_stats/bar_chart_widget.dart';
import 'widgets_stats/summary_card.dart';
import 'add_data_screen.dart';
import '../../models/waste_entry.dart';

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

  // 📦 загрузка данных
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList("waste_data") ?? [];

    List<WasteEntry> loaded = data.map((e) {
      return WasteEntry.fromJson(jsonDecode(e));
    }).toList();

    setState(() {
      entries = loaded;
    });
  }

  // 📊 данные по категориям
  Map<String, double> get categoryData {
    Map<String, double> result = {};

    for (var e in entries) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }

    return result;
  }

  // 📅 данные по дням
  Map<int, double> get dailyData {
    Map<int, double> result = {};

    for (var e in entries) {
      int day = e.date.day;
      result[day] = (result[day] ?? 0) + e.amount;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Статистика")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ➕ добавить данные
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddDataScreen(),
                  ),
                );

                loadData(); // 🔥 обновляем после возврата
              },
              child: const Text("Добавить данные"),
            ),

            const SizedBox(height: 16),

            // 📦 карточка
            SummaryCard(),

            const SizedBox(height: 16),

            // 🥧 круговая диаграмма
            PieChartWidget(data: categoryData),

            const SizedBox(height: 16),

            // 📈 линейный график (по дням)
            LineChartWidget(data: dailyData),

            const SizedBox(height: 16),

            // 📊 бар график (по дням)
            BarChartWidget(data: dailyData),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
