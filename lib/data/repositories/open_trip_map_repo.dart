import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orbitpatter/core/utils/logger.dart';

class OpenTripMapRepo {
  static final url = 'https://api.opentripmap.com/0.1/en/places/radius';
  final _dio = Dio();
  static final apiKey = dotenv.env['openTripMapApiKey'];

  Future<List<dynamic>> fetchPlaces(double lng, double lat, String kind) async {
    final response = await _dio.get(
      '$url',
      queryParameters: {
        'radius': 80000,
        'lon': lng,
        'lat': lat,
        'rate': 2,
        'kinds': kind, // <-- correct
        'apikey': apiKey,
      },
    );

    if (response.statusCode == 200) {
      LoggerUtil.info(
        'Fetched places successfully ${response.data['features']}',
      );
      return response.data['features'];
    } else {
      throw Exception('Failed to load places');
    }
  }



}
