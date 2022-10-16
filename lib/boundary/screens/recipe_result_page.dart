import 'package:flutter/material.dart';
import 'package:foodapp/control/recipe_api.dart';
import 'package:foodapp/boundary/widgets/recipe_card.dart';
import 'package:foodapp/boundary/widgets/recipe_search_bar.dart';
import 'package:foodapp/boundary/widgets/common_buttons.dart';

class RecipeResultPage extends StatelessWidget {
  const RecipeResultPage({
    Key key,
    @required this.query,
    this.ingredientFilters,
  }) : super(key: key);

  final String query;
  final String ingredientFilters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffefefef),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Results"),
        actions: <Widget>[
          IconButton(onPressed: () => {}, icon: const Icon(Icons.filter_alt)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              children: <Widget>[
                const SizedBox(height: 15.0),
                RecipeSearchBar(
                    onSubmitted: (query) =>
                        _submit(context, query, ingredientFilters)),
                const SizedBox(height: 15.0),
                _buildResults(query, ingredientFilters),
              ],
            ),
          ),
          _bottomBar(context),
        ],
      ),
    );
  }

  void _submit(BuildContext context, String query, String ingredientFilters) {
    Map args = {'query': query, 'ingredientFilters': ingredientFilters};
    Navigator.of(context).pushNamed('/RecipeResultPage', arguments: args);
  }

  Widget _buildResults(String query, String ingredientFilters) {
    return FutureBuilder(
      future: RecipeAPI.instance
          .getRecipeList(query: query, ingredientFilters: ingredientFilters),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data.length != 0
                ? snapshot.data
                    .map<Widget>((recipe) => RecipeCard(recipe: recipe))
                    .toList()
                : <Widget>[const Text("no results")],
          );
        } else if (snapshot.hasError) {
          return const Text("error occurred");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Ink(
      color: Colors.white,
      height: 55.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          HomeButton(onPressed: () {}),
          const FavoritedRecipesButton(),
        ],
      ),
    );
  }
}
