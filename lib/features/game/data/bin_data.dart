// lib/features/game/data/bin_data.dart

import 'package:flutter/material.dart';
import '../models/bin.dart';

final List<Bin> bins = [
  Bin(
    type: 'metal',
    label: 'Металл',
    color: Colors.red,
    imagePath: 'assets/images/bins/metal_bin.png',
  ),
  Bin(
    type: 'organic',
    label: 'Органика',
    color: Colors.grey.shade700,
    imagePath: 'assets/images/bins/organic_bin.png',
  ),
  Bin(
    type: 'paper',
    label: 'Бумага',
    color: Colors.blue,
    imagePath: 'assets/images/bins/paper_bin.png',
  ),
  Bin(
    type: 'plastic',
    label: 'Пластик',
    color: Colors.orange,
    imagePath: 'assets/images/bins/plastic_bin.png',
  ),
  Bin(
    type: 'glass',
    label: 'Стекло',
    color: Colors.green,
    imagePath: 'assets/images/bins/glass_bin.png',
  ),
  Bin(
    type: 'other',
    label: 'Смешанные отходы',
    color: Colors.amber,
    imagePath: 'assets/images/bins/other_bin.png',
  ),
];