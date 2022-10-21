import 'package:flutter/material.dart';
import 'package:foodapp/control/database.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantFavoriteButton extends StatelessWidget {
  const RestaurantFavoriteButton({Key key, @required this.restaurant})
      : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database.isRestaurantFavorited(restaurant),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isFavorited = snapshot.data;
          return IconButton(
            onPressed: () => _toggleFavorite(isFavorited),
            icon: isFavorited
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<void> _toggleFavorite(bool isFavorited) async {
    if (isFavorited) {
      await Database.removeFavoritedRestaurant(restaurant);
    } else {
      await Database.addFavoritedRestaurant(restaurant);
    }
  }
}
