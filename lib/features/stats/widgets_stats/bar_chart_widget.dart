import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final Map<int, double> data;
  final Map<int, String>? labels;

  const BarChartWidget({
    super.key,
    required this.data,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return SizedBox(
      height: 220,
      child: data.isEmpty
          ? const Center(child: Text("Нет данных"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final int key = value.toInt();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels?[key] ?? key.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: sortedEntries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.cyan,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
