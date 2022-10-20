import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/landing_page.dart';
import 'package:foodapp/boundary/screens/recipe/favorited_recipes_page.dart';
import 'package:foodapp/boundary/screens/recipe/recipe_results_page.dart';
import 'package:foodapp/boundary/screens/recipe/recipe_page.dart';
import 'package:foodapp/boundary/screens/restaurant/restaurant_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/LandingPage':
        return MaterialPageRoute(builder: (context) => LandingPage());
      case '/RecipePage':
        return MaterialPageRoute(builder: (context) => const RecipePage());
      case '/RecipeResultsPage':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (context) => RecipeResultsPage(
              query: args['query'],
              ingredientFilters: args['ingredientFilters'],
            ),
          );
        }
        return _error();
      case '/FavoritedRecipesPage':
        return MaterialPageRoute(
            builder: (context) => const FavoritedRecipesPage());
      case '/RestaurantPage':
        return MaterialPageRoute(builder: (context) => const RestaurantPage());
      default:
        return _error();
    }
  }

  static Route<dynamic> _error() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text("error"))));
  }
}
