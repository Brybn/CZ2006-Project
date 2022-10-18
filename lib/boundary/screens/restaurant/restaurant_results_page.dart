import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/restaurant/favorited_restaurants_page.dart';
import 'package:foodapp/boundary/widgets/restaurant_card.dart';
import 'package:foodapp/control/restaurant_api.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantResultsPage extends StatefulWidget {
  final String cuisine;
  final List<String> preferences;
  final RangeValues currentRangeValue;
  final double latitude;
  final double longitude;

  const RestaurantResultsPage({
    Key key,
    String resCuisine,
    List<String> resPreference,
    RangeValues resCurrentRangeValue,
    double resLatitude,
    double resLongitude,
  })  : cuisine = resCuisine,
        preferences = resPreference,
        currentRangeValue = resCurrentRangeValue,
        latitude = resLatitude,
        longitude = resLongitude,
        super(key: key);

  @override
  RestaurantResultsPageState createState() => RestaurantResultsPageState();
}

class RestaurantResultsPageState extends State<RestaurantResultsPage> {
  List<Restaurant> restaurantList = [];
  List itemsOnSearch = [];
  List supportList = [];
  bool noChange = true;

  final TextEditingController _textEditingController = TextEditingController();

  Widget _buildResults(String cuisine, List<String> preferences,
      double latitude, double longitude, RangeValues rangeValues) {
    return FutureBuilder(
      future: RestaurantAPI.instance.getRestaurantList(
        cuisine: cuisine,
        preferences: preferences,
        latitude: latitude,
        longitude: longitude,
        rangeValues: rangeValues,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          restaurantList = snapshot.data;
          return restaurantList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: restaurantList.length,
                      itemBuilder: (context, index) =>
                          RestaurantCard(restaurant: restaurantList[index])),
                )
              : Container();
        } else if (snapshot.hasError) {
          return const Center(child: Text("error occurred"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Container(
          width: double.infinity,
          height: 40,
          color: Colors.white,
          child: Center(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  itemsOnSearch = restaurantList
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Search for something',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
              icon: const Icon(Icons.filter_alt),
              itemBuilder: (context) =>
                  [const PopupMenuItem(child: Text("item"))]),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritedRestaurantsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.star)),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildResults(
            widget.cuisine,
            widget.preferences,
            widget.latitude,
            widget.longitude,
            widget.currentRangeValue,
          ),
        ],
      ),
    );
  }
}
