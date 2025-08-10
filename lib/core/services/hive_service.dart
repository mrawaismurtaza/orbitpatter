import 'package:hive_flutter/hive_flutter.dart';
import 'package:orbitpatter/data/models/location.dart';

class HiveService {
  Future<void> cacheLocation(LocationModel location) async {
    final box = Hive.box<LocationModel>('location_box');
    await box.put(
      'location',
      LocationModel(
        country: location.country,
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );
  }

  Future<LocationModel?> getCachedLocation() async {
    final box = Hive.box<LocationModel>('location_box');
    return box.get('location');
  }
}
