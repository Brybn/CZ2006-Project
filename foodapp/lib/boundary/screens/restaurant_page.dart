import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/boundary/screens/restaurants_result.dart';
import 'package:location/location.dart';

import 'package:foodapp/boundary/widgets/MultiSelectChip.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({
    Key key,
    @required User user,
  })
      : _user = user,
        super(key: key);
  final User _user;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  User _user;
  Location location = Location();
  LocationData _locationData;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
    getLoc();
  }

  getLoc() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  List<String> reportList = [
    "Vegan",
    "Vegetarian",
    "Halal",
  ];

  List<String> selectedReportList = [];

  RangeValues _currentRangeValues = const RangeValues(0, 10);

  String dropdownValue = 'Chinese';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Enter Your Preference")),
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
                    borderSide: BorderSide(color: Colors.orange, width: 2)),
              ),
              value: dropdownValue,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
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
            child: Text("Dietary Requirements",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
                    borderRadius: BorderRadius.circular(40)),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(20.0),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RestaurantResult(
                            resCuisine: dropdownValue,
                            resPreference: selectedReportList,
                            resCurrentRangeValue: _currentRangeValues,
                            resLatitude: _locationData.latitude,
                            resLongitude: _locationData.longitude,
                            user: _user,
                          ),
                    )
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
