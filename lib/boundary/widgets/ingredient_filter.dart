import 'package:flutter/material.dart';

import 'package:foodapp/boundary/screens/recipe/recipe_page.dart';

class IngredientFilter extends StatefulWidget {
  const IngredientFilter({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final StringCallback onTap;

  @override
  State<StatefulWidget> createState() => _IngredientFilterState();
}

class _IngredientFilterState extends State<IngredientFilter> {
  final List<String> _pantryItemsList = [
    "black pepper",
    "cooking oil",
    "flour",
    "olive oil",
    "salt",
    "sugar",
    "vegetable oil",
  ];

  final List<String> _dairyList = [
    "butter",
    "cheese",
    "cream",
    "eggs",
    "milk",
    "yogurt",
  ];

  final List<String> _spiceList = [
    "allspice",
    "basil",
    "cilantro",
    "cinnamon",
    "coriander",
    "dill",
    "ginger",
    "mace",
    "mint",
    "nutmeg",
    "rosemary",
    "thyme",
    "turmeric",
  ];

  final List<String> _fruitList = [
    "apple",
    "banana",
    "berries",
    "grape",
    "lemon",
    "lime",
    "mango",
    "orange",
    "peach",
    "pear",
    "pineapple",
    "watermelon",
  ];

  final List<String> _vegetableList = [
    "beans",
    "broccoli",
    "cabbage",
    "carrots",
    "cauliflower",
    "celery",
    "chili",
    "cucumber",
    "eggplant",
    "garlic",
    "leeks",
    "lettuce",
    "mushroom",
    "olives",
    "onions",
    "peas",
    "peppers",
    "potatoes",
    "sprouts",
    "tomatoes",
  ];

  final List<String> _meatList = [
    "beef",
    "chicken breasts",
    "chicken drumsticks",
    "chicken wings",
    "ground beef",
    "ground chicken",
    "ground pork",
    "fish",
    "lamb",
    "pork",
    "salmon fillet",
    "tuna",
    "turkey",
  ];

  final List<String> _selectedFilters = <String>[];

  Iterable<Widget> _ingredientChips(List<String> ingredientList) {
    return ingredientList
        .map((ingredient) => Padding(
              padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
              child: FilterChip(
                label: Text(
                  ingredient,
                  style: const TextStyle(fontSize: 12.5),
                ),
                showCheckmark: false,
                selectedColor: Colors.orangeAccent,
                selected: _selectedFilters.contains(ingredient),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedFilters.add(ingredient);
                    } else {
                      _selectedFilters
                          .removeWhere((name) => name == ingredient);
                    }
                    widget.onTap(_selectedFilters.join(','));
                  });
                },
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Selected: ${_selectedFilters.join(',')}'),
        const Text(
          "Pantry Items",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        Wrap(children: _ingredientChips(_pantryItemsList)),
        const Text(
          "Dairy",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        Wrap(children: _ingredientChips(_dairyList)),
        const Text(
          "Spices",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        Wrap(children: _ingredientChips(_spiceList)),
        const Text(
          "Fruits",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        Wrap(children: _ingredientChips(_fruitList)),
        const Text(
          "Vegetables",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        Wrap(children: _ingredientChips(_vegetableList)),
        const Text(
          "Meats",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        Wrap(children: _ingredientChips(_meatList)),
      ],
    );
  }
}
