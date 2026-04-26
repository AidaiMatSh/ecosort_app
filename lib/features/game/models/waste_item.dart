// lib/features/game/models/waste_item.dart

class WasteItem {
  final String name;
  final String type;
  final String image;      // ✅ оставили как было (используется в game_logic)
  final String imagePath;  // ✅ добавили для картинок

  WasteItem({
    required this.name,
    required this.type,
    required this.image,
    required this.imagePath,
  });
}