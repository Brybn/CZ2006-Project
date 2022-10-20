import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/restaurant/favorited_restaurants_page.dart';
import 'package:foodapp/boundary/widgets/restaurant_card.dart';
import 'package:foodapp/control/restaurant_api.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantResultsPage extends StatefulWidget {
  final String cuisine;
  final List<String> preferences;
  final RangeValues rangeValues;
  final double latitude;
  final double longitude;

  const RestaurantResultsPage({
    Key key,
    this.cuisine,
    this.preferences,
    this.rangeValues,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  RestaurantResultsPageState createState() => RestaurantResultsPageState();
}

class RestaurantResultsPageState extends State<RestaurantResultsPage> {
  final List<Restaurant> _restaurantList = [];
  final List<Restaurant> _filteredList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    RestaurantAPI.getRestaurantList(
      cuisine: widget.cuisine,
      preferences: widget.preferences,
      latitude: widget.latitude,
      longitude: widget.longitude,
      rangeValues: widget.rangeValues,
    ).then((returnedList) => setState(() {
          _restaurantList.addAll(returnedList);
          _filteredList.addAll(returnedList);
          _isLoading = false;
        }));
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
          child: TextField(
            onChanged: _searchResults,
            decoration: const InputDecoration(
              hintText: 'Search for something',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: <Widget>[
          _filterButton(),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoritedRestaurantsPage(),
              ),
            ),
          ),
        ],
      ),
      body: _buildResults(),
    );
  }

  Widget _buildResults() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _filteredList.isEmpty
            ? const Center(child: Text('no results'))
            : ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: _filteredList.length,
                itemBuilder: (context, index) =>
                    RestaurantCard(restaurant: _filteredList[index]),
              );
  }

  Widget _filterButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_alt),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          value: '',
          height: 20.0,
          enabled: false,
          child: Text("Sort By"),
        ),
        const PopupMenuItem(
          value: 'Alphabetical',
          child: Text("Alphabetical"),
        ),
        const PopupMenuItem(
          value: 'Distance',
          child: Text("Distance"),
        ),
      ],
      onSelected: _sortResults,
    );
  }

  void _sortResults(String sortBy) {
    switch (sortBy) {
      case 'Alphabetical':
        setState(() => _filteredList.sort((a, b) => a.name.compareTo(b.name)));
        return;
      case 'Distance':
        setState(() =>
            _filteredList.sort((a, b) => a.distance < b.distance ? 0 : 1));
        return;
      default:
        return;
    }
  }

  void _searchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredList.clear();
        _filteredList.addAll(_restaurantList);
      });
    } else {
      setState(() {
        _filteredList.clear();
        _filteredList.addAll(_restaurantList.where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase())));
      });
    }
  }
}
