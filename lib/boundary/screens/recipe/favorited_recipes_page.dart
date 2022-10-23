import 'package:flutter/material.dart';

import 'package:foodapp/boundary/widgets/recipe/favorited_recipe_card.dart';
import 'package:foodapp/control/database.dart';

class FavoritedRecipesPage extends StatelessWidget {
  const FavoritedRecipesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Favorited Recipes"),
      ),
      backgroundColor: const Color(0xffefefef),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<FavoritedRecipeCard>>(
      stream: Database.favoritedRecipesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: snapshot.data,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
