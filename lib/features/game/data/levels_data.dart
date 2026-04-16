import '../models/level_config.dart';

final levels = [

  // Level 1 — без таймера
  LevelConfig(
    targetScore: 5,
    time: 0,
    hasTimer: false,
  ),

  // Level 2 — с таймером
  LevelConfig(
    targetScore: 5,
    time: 30,
    hasTimer: true,
  ),

];