// lib/features/game/data/waste_data.dart

import '../models/waste_item.dart';

final List<WasteItem> wasteItems = [
  WasteItem(
    name: 'Газета',
    type: 'paper',
    image: 'newspaper',
    imagePath: 'assets/images/waste/newspaper.png',
  ),
  WasteItem(
    name: 'Яблочный огрызок',
    type: 'organic',
    image: 'apple',
    imagePath: 'assets/images/waste/apple.png',
  ),
  WasteItem(
    name: 'Жестяная банка',
    type: 'metal',
    image: 'tin_can',
    imagePath: 'assets/images/waste/tin_can.png',
  ),
  WasteItem(
    name: 'Пластиковая бутылка',
    type: 'plastic',
    image: 'bottle',
    imagePath: 'assets/images/waste/bottle.png',
  ),
  WasteItem(
    name: 'Стеклянная банка',
    type: 'glass',
    image: 'glass_jar',
    imagePath: 'assets/images/waste/glass_jar.png',
  ),
  WasteItem(
    name: 'Кожура банана',
    type: 'organic',
    image: 'banana_peel',
    imagePath: 'assets/images/waste/banana_peel.png',
  ),
];