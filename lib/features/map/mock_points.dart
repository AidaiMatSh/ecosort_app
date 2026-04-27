import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/recycle_point.dart';

final List<RecyclePoint> mockPoints = [
  RecyclePoint(
    name: "Макулатура",
    type: "paper",
    location: LatLng(42.8746, 74.5698),
  ),
  RecyclePoint(
    name: "Пластик",
    type: "plastic",
    location: LatLng(42.8700, 74.5800),
  ),
  RecyclePoint(
    name: "Стекло",
    type: "glass",
    location: LatLng(42.8800, 74.5600),
  ),
];