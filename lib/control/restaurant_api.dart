import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantAPI {
  RestaurantAPI._instantiate();

  static final RestaurantAPI instance = RestaurantAPI._instantiate();

  static Future<List<Restaurant>> getRestaurantList({
    String cuisine,
    List<String> preferences,
    double latitude,
    double longitude,
    double rangeValue,
  }) async {
    final String response =
        await rootBundle.loadString('assets/restaurants.json');
    final data = await json.decode(response);
    final List<Restaurant> restaurantList = <Restaurant>[];
    data["items"].forEach((item) {
      double distance = _calculateDistance(double.parse(item['lat']),
          double.parse(item['lon']), latitude, longitude);
      bool hasCuisine = cuisine == "None" || item["cuisine"].contains(cuisine);
      bool withinDistance = distance <= rangeValue;
      bool containsAllPreferences = preferences
          .every((preference) => item["cuisine"].contains(preference));
      if (hasCuisine && withinDistance && containsAllPreferences) {
        restaurantList.add(Restaurant.fromJson(item, distance));
      }
    });
    return restaurantList;
  }

  static double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
