import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:orbitpatter/data/models/location.dart';

class LocationService {

  final loc.Location location = loc.Location();


  /// Requests location permission from the user.
  Future<bool> requestLocationPermission() async {
    // Implementation for requesting location permission
    bool serviceEnabled;
    loc.PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == loc.PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != loc.PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<LocationModel?> getLocation() async {
    // Implementation for getting the current location
    final locData = await getCurrentLocation();
    if (locData == null) {
      return null;
    }
    // Use the location data to get the country
    final latitude = locData['latitude'];
    final longitude = locData['longitude'];
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      if (placemarks.isNotEmpty) {
        return LocationModel(
          country: placemarks.first.country!,
          latitude: double.parse(latitude.toString()),
          longitude: double.parse(longitude.toString()),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Define the methods and properties for the location service
  Future<Map<String, double>?> getCurrentLocation() async {
    // Implementation for getting the current location
    try {
      final locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        return {
          'latitude': locationData.latitude!,
          'longitude': locationData.longitude!,
        };
      }
    } catch (e) {
      print("Error getting location: $e");
    }
    return null;
  }

  
}