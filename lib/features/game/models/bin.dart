// lib/features/game/models/bin.dart

import 'package:flutter/material.dart';

class Bin {
  final String type;
  final String label;
  final Color color;       // ✅ добавили
  final String imagePath;  // ✅ добавили

  Bin({
    required this.type,
    required this.label,
    required this.color,
    required this.imagePath,
  });
}