import 'package:flutter/material.dart';
import 'package:foodapp/control/database.dart';
import 'package:foodapp/entity/recipe.dart';

class RecipeFavoriteButton extends StatelessWidget {
  const RecipeFavoriteButton({
    Key key,
    @required this.recipe,
    this.color = Colors.orange,
    this.iconSize = 49.0,
  }) : super(key: key);

  final Recipe recipe;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database.isRecipeFavorited(recipe),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isFavorited = snapshot.data;
          return IconButton(
            padding: const EdgeInsets.all(0.0),
            iconSize: iconSize,
            splashRadius: 30.0,
            onPressed: () => _toggleFavorite(isFavorited),
            icon: isFavorited
                ? Icon(Icons.star_rounded, color: color)
                : const Icon(Icons.star_border_rounded, color: Colors.grey),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _toggleFavorite(bool isFavorited) async {
    if (isFavorited) {
      await Database.removeFavoritedRecipe(recipe);
    } else {
      await Database.addFavoritedRecipe(recipe);
    }
  }
}
