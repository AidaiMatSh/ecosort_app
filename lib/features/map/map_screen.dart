import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'mock_points.dart';
import 'recycle_point.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;

  List<LatLng> routePoints = [];

  int ecoPoints = 120;

  String selectedFilter = 'all';

  List<RecyclePoint> customPoints = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> buildRoute(LatLng destination) async {
    if (userLocation == null) return;

    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${userLocation!.longitude},${userLocation!.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final coords = data['routes'][0]['geometry']['coordinates'];

      setState(() {
        routePoints = coords.map<LatLng>((c) {
          return LatLng(c[1], c[0]);
        }).toList();
      });
    }
  }

  List<RecyclePoint> get filteredPoints {
    final allPoints = [...mockPoints, ...customPoints];

    if (selectedFilter == 'all') return allPoints;

    return allPoints.where((p) => p.type == selectedFilter).toList();
  }

  Color getMarkerColor(String type) {
    switch (type) {
      case 'paper':
        return Colors.blue;
      case 'plastic':
        return Colors.green;
      case 'glass':
        return Colors.orange;
      case 'battery':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void addPoint(LatLng point) {
    setState(() {
      customPoints.add(
        RecyclePoint(
          name: 'New Point',
          type: 'plastic',
          location: point,
        ),
      );
      ecoPoints += 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔆 полностью светлый фон
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'EcoSort',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter:
                  userLocation ?? const LatLng(42.8746, 74.5698),
              initialZoom: 13,
              onLongPress: (tapPosition, point) {
                addPoint(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ecosort_app',
              ),

              CircleLayer(
                circles: [
                  CircleMarker(
                    point: const LatLng(42.878, 74.60),
                    radius: 60,
                    color: Colors.red.withOpacity(0.2),
                    borderColor: Colors.red,
                    borderStrokeWidth: 2,
                  ),
                  CircleMarker(
                    point: const LatLng(42.870, 74.55),
                    radius: 50,
                    color: Colors.green.withOpacity(0.2),
                    borderColor: Colors.green,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5,
                    color: Colors.blue,
                  ),
                ],
              ),

              if (userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLocation!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 45,
                      ),
                    ),
                  ],
                ),

              MarkerLayer(
                markers: filteredPoints.map((point) {
                  return Marker(
                    point: point.location,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        buildRoute(point.location);

                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    point.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Type: ${point.type}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        ecoPoints += 10;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Recycle Here ♻️'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.location_on,
                        color: getMarkerColor(point.type),
                        size: 45,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 🟢 ECO POINTS (СВЕТЛАЯ КАРТОЧКА)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eco Points',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        '$ecoPoints',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Level',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        'Planet Saver 🌍',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔵 FILTERS (СВЕТЛЫЕ КНОПКИ)
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterButton('all', 'All'),
                  filterButton('paper', 'Paper'),
                  filterButton('plastic', 'Plastic'),
                  filterButton('glass', 'Glass'),
                  filterButton('battery', 'Battery'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterButton(String value, String label) {
    final selected = selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.green : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black,
          side: const BorderSide(color: Colors.grey),
        ),
        onPressed: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Text(label),
      ),
    );
  }
}
