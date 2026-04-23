import 'package:flutter/material.dart';
class SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text("Всего отсортировано: 100 кг"),
      ),
    );
  }
}
