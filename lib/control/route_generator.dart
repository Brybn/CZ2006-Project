import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/landing_page.dart';
import 'package:foodapp/boundary/screens/recipe/favorited_recipes_page.dart';
import 'package:foodapp/boundary/screens/recipe/recipe_information_page.dart';
import 'package:foodapp/boundary/screens/recipe/recipe_results_page.dart';
import 'package:foodapp/boundary/screens/recipe/recipe_page.dart';
import 'package:foodapp/boundary/screens/restaurant/favorited_restaurants_page.dart';
import 'package:foodapp/boundary/screens/restaurant/restaurant_page.dart';
import 'package:foodapp/boundary/screens/restaurant/restaurant_results_page.dart';
import 'package:foodapp/boundary/screens/restaurant/restaurant_reviews_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/LandingPage':
        return MaterialPageRoute(builder: (context) => const LandingPage());
      case '/RecipePage':
        return MaterialPageRoute(builder: (context) => const RecipePage());
      case '/RecipeResultsPage':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (context) => RecipeResultsPage(
              query: args['query'],
              ingredientFilters: args['ingredientFilters'],
              maxCalories: args['maxCalories'],
            ),
          );
        }
        return _error();
      case '/FavoritedRecipesPage':
        return MaterialPageRoute(
            builder: (context) => const FavoritedRecipesPage());
      case '/RecipeInformationPage':
        return MaterialPageRoute(
            builder: (context) => RecipeInformationPage(recipe: args));
      case '/RestaurantPage':
        return MaterialPageRoute(builder: (context) => const RestaurantPage());
      case '/RestaurantResultsPage':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (context) => RestaurantResultsPage(
              cuisine: args['cuisine'],
              preferences: args['preferences'],
              rangeValue: args['rangeValue'],
              userLatitude: args['userLatitude'],
              userLongitude: args['userLongitude'],
            ),
          );
        }
        return _error();
      case '/FavoritedRestaurantsPage':
        return MaterialPageRoute(
            builder: (context) => const FavoritedRestaurantsPage());
      case '/RestaurantReviewsPage':
        return MaterialPageRoute(
            builder: (context) => RestaurantReviewsPage(restaurant: args));
      default:
        return _error();
    }
  }

  static Route<dynamic> _error() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text("error"))));
  }
}
