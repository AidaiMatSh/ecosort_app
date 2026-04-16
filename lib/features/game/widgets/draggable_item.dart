import 'package:flutter/material.dart';
import '../models/waste_item.dart';

class DraggableItem extends StatelessWidget {
  final WasteItem item;

  const DraggableItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: item.type,

      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade300,
          child: Text(item.name),
        ),
      ),

      childWhenDragging: const SizedBox(),

      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          item.name,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}