import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final Map<int, double> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: data.isEmpty
          ? const Center(child: Text("Нет данных"))
          : LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: data.entries
                        .map((e) => FlSpot(
                              e.key.toDouble(),
                              e.value,
                            ))
                        .toList(),
                    isCurved: true,
                    barWidth: 3,
                  ),
                ],
              ),
            ),
    );
  }
}
