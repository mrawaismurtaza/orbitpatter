import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMap extends StatelessWidget {
  final List<List<double>> markerCoordinates; // List of [lat, lng]
  final double zoomLevel;
  final List<double> initialCenter;
const CustomMap({
    super.key,
    required this.markerCoordinates,
    this.zoomLevel = 10.0,
    this.initialCenter = const [0.0, 0.0],
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: FlutterMap(
        
        options: MapOptions(
          initialCenter: LatLng(initialCenter[0], initialCenter[1]),
          initialZoom: zoomLevel,
        ),
        children: [
          TileLayer(
            // Bring your own tiles
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
            userAgentPackageName:
                'com.example.orbitpatter', // Add your app identifier
            // And many more recommended properties!
          ),
          MarkerLayer(
            markers: markerCoordinates.map((coord) => Marker(
              point: LatLng(coord[0], coord[1]),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
            )).toList(),
          ),
          
          RichAttributionWidget(
            // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'Orbit Patter',
                onTap: () => launchUrl(
                  Uri.parse('https://orbitpatter.com'),
                ), // (external)
              ),
              // Also add images...
            ],
          ),
       
        ],
      ),
    );
  }
}
