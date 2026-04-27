import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data/mock_points.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  void loadMarkers() {
    for (var point in mockPoints) {
      BitmapDescriptor color;

      switch (point.type) {
        case "paper":
          color = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        case "plastic":
          color = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          break;
        case "glass":
          color = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
          break;
        default:
          color = BitmapDescriptor.defaultMarker;
      }

      markers.add(
        Marker(
          markerId: MarkerId(point.name),
          position: point.location,
          infoWindow: InfoWindow(title: point.name),
          icon: color,
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EcoSort Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(42.8746, 74.5698),
          zoom: 12,
        ),
        markers: markers,
        myLocationEnabled: true,
      ),
    );
  }
}