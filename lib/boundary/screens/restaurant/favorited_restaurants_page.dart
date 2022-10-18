import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/boundary/widgets/favorited_restaurant_card.dart';
import 'package:foodapp/control/database.dart';

class FavoritedRestaurantsPage extends StatelessWidget {
  FavoritedRestaurantsPage({Key key}) : super(key: key);

  final User _user = FirebaseAuth.instance.currentUser;

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
            final children = snapshot.data;
            return ListView(
              children: children,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
