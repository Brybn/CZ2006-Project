import 'package:dio/dio.dart';
import 'package:foodapp/control/.env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'directions.dart';

class DirectionsRepository{
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    double origin_lat,
    double origin_lon,
    double dest_lat,
    double dest_lon,
}) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin_lat},${origin_lon}',
        'destination': '${dest_lat},${dest_lon}',
        'key': googleAPIKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}