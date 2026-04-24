import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../utils/category_colors.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: data.isEmpty
          ? const Center(child: Text("Нет данных"))
          : PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: data.entries.map((e) {
                  final value = e.value;

                  return PieChartSectionData(
                    value: value,
                    title: value > 0 ? e.key : '',
                    color: CategoryColors.colors[e.key] ?? Colors.black,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
