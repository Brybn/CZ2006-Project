import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/common_buttons.dart';
import 'package:foodapp/boundary/widgets/restaurant/restaurant_card.dart';
import 'package:foodapp/control/restaurant_api.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantResultsPage extends StatefulWidget {
  final String cuisine;
  final List<String> preferences;
  final double rangeValue;
  final double userLatitude;
  final double userLongitude;

  const RestaurantResultsPage({
    Key key,
    this.cuisine,
    this.preferences,
    this.rangeValue,
    this.userLatitude,
    this.userLongitude,
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
      latitude: widget.userLatitude,
      longitude: widget.userLongitude,
      rangeValue: widget.rangeValue,
    ).then((returnedList) => setState(() {
          _restaurantList.addAll(returnedList);
          _filteredList.addAll(returnedList);
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Container(
          width: double.infinity,
          height: 40,
          color: Colors.white,
          child: TextField(
            onChanged: _searchResults,
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: <Widget>[
          _filterButton(),
          const FavoritedRestaurantsButton(),
        ],
      ),
      body: _buildResults(),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filteredList.isEmpty) {
      return const Center(child: Text('no results found'));
    } else {
      return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: _filteredList.length,
        itemBuilder: (context, index) =>
            RestaurantCard(restaurant: _filteredList[index]),
      );
    }
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
            _filteredList.sort((a, b) => a.distance.compareTo(b.distance)));
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
