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
  final _queryController = TextEditingController();
  final _calorieInputController = TextEditingController();
  String _ingredientFilters = "";

  @override
  void dispose() {
    _queryController.dispose();
    _calorieInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefefef),
      resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              children: <Widget>[
                RecipeSearchBar(controller: _queryController),
                const Divider(height: 20, thickness: 1),
                ..._calorieInputSection(),
                const Divider(height: 20, thickness: 1),
                const Center(
                  child: Text(
                    "Include Ingredients:",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                  ),
                ),
                IngredientFilter(onTap: _updateFilters),
                const Divider(thickness: 1),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          RecipeSearchButton(onPressed: _submit),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  List<Widget> _calorieInputSection() {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Tooltip(
            message:
                "The maximum calories of the recipes to search.\nNo limit will be set if left blank.",
            textAlign: TextAlign.center,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: Duration(seconds: 8),
            margin: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            child: Icon(Icons.info_outline_rounded, color: Colors.grey),
          ),
          SizedBox(width: 5.0),
          Text(
            "Calories:",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 29.0),
        ],
      ),
      const SizedBox(height: 10.0),
      _calorieInputField(),
    ];
  }

  Widget _calorieInputField() {
    return TextField(
      controller: _calorieInputController,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        labelText: 'Input Calories',
        floatingLabelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.local_fire_department,
          color: Colors.orange,
          size: 27.0,
        ),
        suffix: const Text('kcal'),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(50.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  void _updateFilters(String filters) {
    _ingredientFilters = filters;
  }

  void _submit() {
    final isValidDouble = RegExp(r'^-?[0-9]+([.][0-9]+)?$')
        .hasMatch(_calorieInputController.text);
    final Map<String, String> args = {
      'query': _queryController.text,
      'ingredientFilters': _ingredientFilters,
      'maxCalories': isValidDouble ? _calorieInputController.text : "",
    };
    Navigator.of(context).pushNamed('/RecipeResultsPage', arguments: args);
  }
}
