import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecyclePoint {
  final String name;
  final String type;
  final LatLng location;

  RecyclePoint({
    required this.name,
    required this.type,
    required this.location,
  });
}
