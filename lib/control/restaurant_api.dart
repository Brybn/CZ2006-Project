import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantAPI {
  RestaurantAPI._instantiate();

  static final RestaurantAPI instance = RestaurantAPI._instantiate();

  Future<List<Restaurant>> getRestaurantList({
    String cuisine,
    List<String> preferences,
    double latitude,
    double longitude,
    RangeValues rangeValues,
  }) async {
    final String response =
        await rootBundle.loadString('assets/restaurants.json');
    final data = await json.decode(response);
    List<Restaurant> restaurantList = <Restaurant>[];
    data["items"].forEach((item) {
      var itemCuisines = item["cuisine"];
      double itemLat = double.parse(item['lat']);
      double itemLon = double.parse(item['lon']);
      bool hasCuisine = itemCuisines.contains(cuisine);
      bool withinDistance =
          _calculateDistance(itemLat, itemLon, latitude, longitude) <=
              rangeValues.end.toDouble();
      bool containsAllPreferences =
          preferences.every((preference) => itemCuisines.contains(preference));
      if (hasCuisine && withinDistance && containsAllPreferences) {
        restaurantList.add(Restaurant.fromJson(item));
      }
    });
    return restaurantList;
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
