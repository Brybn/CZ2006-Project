import 'dart:convert';
import 'dart:io';

import 'package:foodapp/entity/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeAPI {
  RecipeAPI._instantiate();

  static final RecipeAPI instance = RecipeAPI._instantiate();
  final String _baseURL = "api.spoonacular.com";
  static const apiKey = "1d34894957804e3f8fd6288cd7c89e0f";

  Future<List<Recipe>> getRecipeList({String query = "", String ingredientFilters = ""}) async {
    Map<String, String> parameters = {
      'apiKey': apiKey,
      'query': query,
      'instructionsRequired': 'true',
      'fillIngredients': 'true',
      'addRecipeNutrition': 'true',
      'number': '2', // TODO: increase at the end
      'includeIngredients': ingredientFilters,
    };

    Uri uri = Uri.https(
      _baseURL,
      '/recipes/complexSearch',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      var recipeData = jsonDecode(response.body);
      int size =
          recipeData['totalResults'] < 2 ? recipeData['totalResults'] : 2;
      List<Recipe> recipeList = <Recipe>[];
      for (int i = 0; i < size; i++) {
        recipeList.add(Recipe.fromJson(recipeData['results'][i]));
      }
      return recipeList;
    } catch (e) {
      throw e.toString();
    }
  }
}
