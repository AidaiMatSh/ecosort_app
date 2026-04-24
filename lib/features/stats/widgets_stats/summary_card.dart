import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double total;

  const SummaryCard({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Общий мусор: $total кг",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
