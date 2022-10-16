import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/mapsample.dart';
import 'dart:math';
import 'package:foodapp/boundary/screens/review_page.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/boundary/screens/favourites.dart';
import 'package:foodapp/boundary/widgets/favorite_widget.dart';

class RestaurantResult extends StatefulWidget {
  final User _user;
  final String cuisine;
  final List<String> preference;
  final RangeValues _currentRangeValue;
  final double _latitude;
  final double _longitude;

  const RestaurantResult(
      {Key key,
      String resCuisine,
      List<String> resPreference,
      RangeValues resCurrentRangeValue,
      double resLatitude,
      double resLongitude,
      User user})
      : _user = user,
        cuisine = resCuisine,
        preference = resPreference,
        _currentRangeValue = resCurrentRangeValue,
        _latitude = resLatitude,
        _longitude = resLongitude,
        super(key: key);

  @override
  _RestaurantResultState createState() => _RestaurantResultState();
}

class _RestaurantResultState extends State<RestaurantResult> {
  String cuisine;
  List<String> preference;
  RangeValues _currentRangeValue;
  double _latitude;
  double _longitude;
  User _user;
  List _items = [];
  List itemsOnSearch = [];
  List supportList = [];
  int j = 0;
  bool noChange = true;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    cuisine = widget.cuisine;
    _user = widget._user;
    preference = widget.preference;
    _currentRangeValue = widget._currentRangeValue;
    _latitude = widget._latitude;
    _longitude = widget._longitude;
    super.initState();
    readJson();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/restaurants.json');
    final data = await json.decode(response);
    setState(() {
      data["items"].forEach((element) => {
            j = 0,
            if ((element["cuisine"].contains(cuisine)) &&
                (calculateDistance(double.parse(element['lat']),
                        double.parse(element['lon']), _latitude, _longitude)) <=
                    _currentRangeValue.end.toDouble())
              {
                for (var i = 0; i < preference.length; i++)
                  {
                    if (element["cuisine"].contains(preference[i]))
                      {
                        j++,
                      }
                  },
                if (j == preference.length) {_items.add(element)}
              }
          });
    });
  }

  void matchSearch(String value) {
    for (int j = 0; j < _items.length; j++) {
      if (_items[j]["name"] != value) {
        _items.removeAt(j);
      }
    }
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
                    itemsOnSearch = _items
                        .where((element) => element["name"]
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
            IconButton(onPressed: () => {}, icon: const Icon(Icons.filter_alt)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Favourites(user: _user)));
                },
                icon: const Icon(Icons.star))
          ]),
      body: Container(
        child: Column(
          children: <Widget>[
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _textEditingController.text.isNotEmpty
                          ? itemsOnSearch.length
                          : _items.length,
                      itemBuilder: (context, index) {
                        return buildItem(
                            _textEditingController.text.isNotEmpty
                                ? itemsOnSearch[index]["name"]
                                : _items[index]["name"],
                            _textEditingController.text.isNotEmpty
                                ? itemsOnSearch[index]["address"]
                                : _items[index]["address"],
                            _textEditingController.text.isNotEmpty
                                ? itemsOnSearch[index]["image_url"]
                                : _items[index]["image_url"],
                            _textEditingController.text.isNotEmpty
                                ? itemsOnSearch[index]["rating"]
                                : _items[index]["rating"],
                            _textEditingController.text.isNotEmpty
                                ? double.parse(itemsOnSearch[index]["lat"])
                                : double.parse(_items[index]["lat"]),
                            _textEditingController.text.isNotEmpty
                                ? double.parse(itemsOnSearch[index]["lon"])
                                : double.parse(_items[index]["lon"]),
                            _textEditingController.text.isNotEmpty
                                ? itemsOnSearch[index]["id_source"]
                                : _items[index]["id_source"]);
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  GestureDetector buildItem(String title, String subTitle, String url, rating,
      double lat, double lon, String resId) {
    print(lat);
    print(lon);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailPage(url, resId, _user)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: url,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2.0, spreadRadius: 1.0, color: Colors.grey)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 80,
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: Text(
                            subTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: IconButton(
                            icon: const Icon(Icons.location_pin),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapSample(
                                          dest_lat: lat, dest_lon: lon)));
                            })),
                    FavoriteWidget(
                        prating: rating,
                        purl: url,
                        psubtitle: subTitle,
                        user: _user,
                        ptitle: title),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
