import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/common_buttons.dart';
import 'package:foodapp/control/location_api.dart';
import 'package:location/location.dart';
import 'package:foodapp/boundary/widgets/multi_select_chip.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final List<String> _cuisineList = [
    "None",
    "Asian",
    "Chinese",
    "European",
    "French",
    "Fusion",
    "Indian",
    "Italian",
    "Japanese",
    "Korean",
    "Local",
    "Malaysian",
    "Mexican",
    "Spanish",
    "Thai",
    "Western",
  ];

  final List<String> _preferenceList = [
    "BBQ",
    "Beverages",
    "Dessert",
    "Fast Food",
    "Halal",
    "Healthy",
    "Noodles",
    "Seafood",
    "Vegan",
    "Vegetarian",
  ];

  LocationData _userLocation;
  List<String> _selectedPreferences = [];
  double _currentSliderValue = 10.0;
  String dropdownValue = "None";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocation());
  }

  void _loadLocation() {
    LocationAPI.getLocation()
        .then((location) => setState(() => _userLocation = location));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Enter Your Preference"),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/FavoritedRestaurantsPage'),
            icon: const Icon(Icons.star),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50.0),
          ..._cuisineInputSection(),
          const SizedBox(height: 50.0),
          ..._preferenceInputSection(),
          const SizedBox(height: 50.0),
          ..._distanceInputSection(),
          const SizedBox(height: 20.0),
          _restaurantSearchButton(),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  List<Widget> _cuisineInputSection() {
    return <Widget>[
      const Center(
        child: Text(
          "Cuisine",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20, right: 50, left: 50),
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
          value: dropdownValue,
          onChanged: _setDropdownValue,
          items: _cuisineList.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 20)),
            );
          }).toList(),
        ),
      ),
    ];
  }

  List<Widget> _preferenceInputSection() {
    return <Widget>[
      const Center(
        child: Text(
          "Dietary Preferences",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: MultiSelectChip(
          _preferenceList,
          onSelectionChanged: _setPreferences,
          maxSelection: 5,
        ),
      ),
    ];
  }

  List<Widget> _distanceInputSection() {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Tooltip(
            message: "The maximum radius (km) of restaurants to search.",
            textAlign: TextAlign.center,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: Duration(seconds: 5),
            margin: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            child: Icon(Icons.info_outline_rounded, color: Colors.grey),
          ),
          SizedBox(width: 5.0),
          Text(
            "Distance",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 29.0),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Slider(
          value: _currentSliderValue,
          max: 20,
          divisions: 20,
          activeColor: Colors.orange,
          label: _currentSliderValue.toInt().toString(),
          onChanged: _setSliderValue,
        ),
      ),
    ];
  }

  void _setDropdownValue(String value) {
    setState(() => dropdownValue = value);
  }

  void _setPreferences(List<String> preferences) {
    _selectedPreferences = preferences;
  }

  void _setSliderValue(double value) {
    setState(() => _currentSliderValue = value);
  }

  Widget _restaurantSearchButton() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.all(20.0),
          ),
          onPressed: _userLocation == null
              ? null
              : () => Navigator.of(context).pushNamed(
                    '/RestaurantResultsPage',
                    arguments: {
                      'cuisine': dropdownValue,
                      'preferences': _selectedPreferences,
                      'rangeValue': _currentSliderValue,
                      'userLatitude': _userLocation.latitude,
                      'userLongitude': _userLocation.longitude,
                    },
                  ),
          child: const Center(
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
