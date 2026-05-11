// lib/features/game/widgets/draggable_item.dart

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
        child: Opacity(
          opacity: 0.85,
          child: _ItemCard(item: item, scale: 1.15),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _ItemCard(item: item, scale: 1.0),
      ),
      child: _ItemCard(item: item, scale: 1.0),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final WasteItem item;
  final double scale;

  const _ItemCard({required this.item, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              item.imagePath,
              width: 90,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}