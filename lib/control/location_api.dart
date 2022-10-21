import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodapp/entity/directions.dart';
import 'package:location/location.dart';

class LocationAPI {
  static const String _baseUrl = 'maps.googleapis.com';
  static const String _googleAPIKey = 'AIzaSyCSILfdwkWaF94neARf4bijR53tP3vXgy8';

  static Future<LocationData> getLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    LocationData locationData = await location.getLocation();
    return locationData;
  }

  static Future<Directions> getDirections({
    double originLat,
    double originLon,
    double destLat,
    double destLon,
  }) async {
    Uri uri = Uri.https(
      _baseUrl,
      '/maps/api/directions/json',
      {
        'origin': '$originLat,$originLon',
        'destination': '$destLat,$destLon',
        'key': _googleAPIKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Directions.fromMap(data);
    }
    return null;
  }
}
