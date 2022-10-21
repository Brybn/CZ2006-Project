import 'package:flutter/material.dart';
import 'package:foodapp/control/recipe_api.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_card.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_search_bar.dart';
import 'package:foodapp/boundary/widgets/common_buttons.dart';
import 'package:foodapp/entity/recipe.dart';

class RecipeResultsPage extends StatefulWidget {
  const RecipeResultsPage({
    Key key,
    this.query = '',
    this.ingredientFilters = '',
  }) : super(key: key);

  final String query;
  final String ingredientFilters;

  @override
  State<RecipeResultsPage> createState() => RecipeResultsPageState();
}

class RecipeResultsPageState extends State<RecipeResultsPage> {
  final List<Recipe> _recipeList = [];
  final List<Recipe> _filteredList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    RecipeAPI.getRecipeList(
      query: widget.query,
      ingredientFilters: widget.ingredientFilters,
    ).then((returnedList) => setState(() {
          _recipeList.addAll(returnedList);
          _filteredList.addAll(returnedList);
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffefefef),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Results"),
        actions: <Widget>[_filterButton()],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 15.0),
          RecipeSearchBar(onChanged: _searchResults),
          const SizedBox(height: 5.0),
          Expanded(child: _buildResults()),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filteredList.isEmpty) {
      return const Center(child: Text('no results'));
    } else {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 5.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: _filteredList.length,
        itemBuilder: (context, index) =>
            RecipeCard(recipe: _filteredList[index]),
      );
    }
  }

  Widget _filterButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_alt),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          value: '',
          height: 20.0,
          enabled: false,
          child: Text("Sort By"),
        ),
        const PopupMenuItem(
          value: 'Alphabetical',
          child: Text("Alphabetical"),
        ),
        const PopupMenuItem(
          value: 'Calories',
          child: Text("Calories"),
        ),
        const PopupMenuItem(
          value: 'Time',
          child: Text("Time"),
        ),
      ],
      onSelected: _sortResults,
    );
  }

  void _sortResults(String sortBy) {
    switch (sortBy) {
      case 'Alphabetical':
        setState(
            () => _filteredList.sort((a, b) => a.title.compareTo(b.title)));
        return;
      case 'Calories':
        setState(() => _filteredList.sort((a, b) =>
            double.parse(a.calories) < double.parse(b.calories) ? 0 : 1));
        return;
      case 'Time':
        setState(() => _filteredList.sort((a, b) =>
            double.parse(a.readyInMinutes) < double.parse(b.readyInMinutes)
                ? 0
                : 1));
        return;
      default:
        return;
    }
  }

  void _searchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredList.clear();
        _filteredList.addAll(_recipeList);
      });
    } else {
      setState(() {
        _filteredList.clear();
        _filteredList.addAll(_recipeList.where((recipe) =>
            recipe.title.toLowerCase().contains(query.toLowerCase())));
      });
    }
  }

  Widget _bottomBar() {
    return Ink(
      color: Colors.white,
      height: 55.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          HomeButton(),
          FavoritedRecipesButton(),
        ],
      ),
    );
  }
}
