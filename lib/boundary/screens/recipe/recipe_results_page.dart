import 'package:flutter/material.dart';
import 'package:foodapp/control/recipe_api.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_card.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_search_bar.dart';
import 'package:foodapp/boundary/widgets/common_buttons.dart';
import 'package:foodapp/entity/recipe.dart';

class RecipeResultsPage extends StatefulWidget {
  const RecipeResultsPage({
    Key key,
    this.query = "",
    this.ingredientFilters = "",
    this.maxCalories = "",
  }) : super(key: key);

  final String query;
  final String ingredientFilters;
  final String maxCalories;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    RecipeAPI.getRecipeList(
      query: widget.query,
      ingredientFilters: widget.ingredientFilters,
      maxCalories: widget.maxCalories,
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
      bottomNavigationBar: _bottomBar(),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              child: RecipeSearchBar(onChanged: _searchResults),
            ),
          ),
          _buildResults(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_filteredList.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('No results found.')),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => RecipeCard(recipe: _filteredList[index]),
            childCount: _filteredList.length,
          ),
        ),
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
            double.parse(a.calories).compareTo(double.parse(b.calories))));
        return;
      case 'Time':
        setState(() => _filteredList.sort((a, b) =>
            double.parse(a.readyInMinutes)
                .compareTo(double.parse(b.readyInMinutes))));
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
