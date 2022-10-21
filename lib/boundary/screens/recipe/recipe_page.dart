import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/recipe/ingredient_filter.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_search_bar.dart';
import 'package:foodapp/boundary/widgets/common_buttons.dart';

typedef StringCallback = void Function(String val);

class RecipePage extends StatefulWidget {
  const RecipePage({Key key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  void _submit(BuildContext context, String query, String ingredientFilters) {
    Map args = {'query': query, 'ingredientFilters': ingredientFilters};
    Navigator.of(context).pushNamed('/RecipeResultsPage', arguments: args);
  }

  final _queryController = TextEditingController();
  String _ingredientFilters = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefefef),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Enter Your Preference"),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/FavoritedRecipesPage'),
            icon: const Icon(Icons.star),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
              children: <Widget>[
                RecipeSearchBar(controller: _queryController),
                const SizedBox(height: 15.0),
                IngredientFilter(
                  onTap: (filters) =>
                      setState(() => _ingredientFilters = filters),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          RecipeSearchButton(
            onPressed: () =>
                _submit(context, _queryController.text, _ingredientFilters),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
