import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/restaurant/favorited_restaurant_card.dart';
import 'package:foodapp/control/database.dart';

class FavoritedRestaurantsPage extends StatelessWidget {
  const FavoritedRestaurantsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Favorited Restaurants"),
      ),
      body: StreamBuilder<List<FavoritedRestaurantCard>>(
        stream: Database.favoritedRestaurantsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children: snapshot.data);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
