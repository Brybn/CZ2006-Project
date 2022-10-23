import 'dart:convert';
import 'dart:io';
import 'package:foodapp/entity/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeAPI {
  static const String _baseUrl = "api.spoonacular.com";
  static const apiKey = "1d34894957804e3f8fd6288cd7c89e0f";

  static Future<List<Recipe>> getRecipeList({
    String query = "",
    String ingredientFilters = "",
    String maxCalories = "",
  }) async {
    Map<String, String> parameters = {
      'apiKey': apiKey,
      'query': query,
      'instructionsRequired': 'true',
      'fillIngredients': 'true',
      'addRecipeNutrition': 'true',
      'number': '4', // TODO: increase at the end
      'includeIngredients': ingredientFilters,
      if (maxCalories.isNotEmpty) 'maxCalories': maxCalories,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/recipes/complexSearch',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      var recipeData = jsonDecode(response.body);
      List<Recipe> recipeList = <Recipe>[];
      for (var recipeJson in recipeData['results']) {
        recipeList.add(Recipe.fromJson(recipeJson));
      }
      return recipeList;
    } catch (e) {
      throw e.toString();
    }
  }
}
