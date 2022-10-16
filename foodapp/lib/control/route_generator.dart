import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/favorited_recipes_page.dart';
import 'package:foodapp/boundary/screens/recipe_result_page.dart';
import 'package:foodapp/boundary/screens/recipe_page.dart';
import 'package:foodapp/boundary/screens/restaurant_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/RecipePage':
        return MaterialPageRoute(
            builder: (context) => const RecipePage());
      case '/RecipeResultPage':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (context) => RecipeResultPage(
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
        if (args is User) {
          return MaterialPageRoute(
              builder: (context) => RestaurantPage(user: args));
        }
        return _error();
      default:
        return _error();
    }
  }

  static Route<dynamic> _error() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Text("error")));
  }
}
