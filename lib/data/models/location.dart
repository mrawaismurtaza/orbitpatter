import 'package:hive_flutter/hive_flutter.dart';

part 'location.g.dart';

@HiveType(typeId: 0)
class LocationModel extends HiveObject {

  @HiveField(0)
  String country;
  @HiveField(1)
  double latitude;
  @HiveField(2)
  double longitude;

  LocationModel({
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}