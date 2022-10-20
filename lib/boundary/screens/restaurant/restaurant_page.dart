import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/restaurant/restaurant_results_page.dart';
import 'package:location/location.dart';

import 'package:foodapp/boundary/widgets/MultiSelectChip.dart';

import 'favorited_restaurants_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  getLoc() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData locationData = await location.getLocation();
    setState(() => _locationData = locationData);
  }

  List<String> reportList = [
    "Vegan",
    "Vegetarian",
    "Halal",
  ]; // TODO: add more

  List<String> selectedReportList = [];

  RangeValues _currentRangeValues = const RangeValues(0, 10);

  String dropdownValue = 'Chinese';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Enter Your Preference"),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoritedRestaurantsPage(),
              ),
            ),
            icon: const Icon(Icons.star),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Text(
              "Cuisine",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 50, left: 50),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
              value: dropdownValue,
              onChanged: (String newValue) {
                setState(() => dropdownValue = newValue);
              },
              // TODO: add more
              items: <String>['Chinese', 'Thai', 'Asian', 'Indian']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Text(
              "Dietary Requirements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
              maxSelection: 5,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Text(
              "Distance",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RangeSlider(
              values: _currentRangeValues,
              max: 20,
              divisions: 20,
              activeColor: Colors.orange,
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(20.0),
              ),
              onPressed: _locationData == null
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RestaurantResultsPage(
                            cuisine: dropdownValue,
                            preferences: selectedReportList,
                            rangeValues: _currentRangeValues,
                            latitude: _locationData.latitude,
                            longitude: _locationData.longitude,
                          ),
                        ),
                      );
                    },
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
          )
        ],
      ),
    );
  }
}
