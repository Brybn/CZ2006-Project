import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/ingredient_filter.dart';
import 'package:foodapp/boundary/widgets/recipe_search_bar.dart';
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
    Navigator.of(context).pushNamed('/RecipeResultPage', arguments: args);
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
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
              children: <Widget>[
                RecipeSearchBar(
                  controller: _queryController,
                  onSubmitted: (query) => _submit(
                      context, _queryController.text, _ingredientFilters),
                ),
                const SizedBox(height: 15.0),
                IngredientFilter(
                  onTap: (filters) => setState(() {
                    _ingredientFilters = filters;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          RecipeSearchButton(
              onPressed: () =>
                  _submit(context, _queryController.text, _ingredientFilters)),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _filterCategory(String name) {
    return ExpansionTile(
      key: PageStorageKey(name),
      maintainState: true,
      title: Text(name),
      children: [
        IngredientFilter(
          onTap: (filters) => setState(() {
            _ingredientFilters = filters;
          }),
        ),
      ],
    );
  }
}
