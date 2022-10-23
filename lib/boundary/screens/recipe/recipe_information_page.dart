import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_favorite_button.dart';
import 'package:foodapp/entity/recipe.dart';

class RecipeInformationPage extends StatelessWidget {
  const RecipeInformationPage({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefefef),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Results"),
        actions: <Widget>[
          RecipeFavoriteButton(recipe: recipe, color: Colors.white),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                recipe.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  recipe.image,
                  fit: BoxFit.fill,
                  height: 250.0,
                ),
              ),
              const SizedBox(height: 20.0),
              _recipeInformationBar(),
              const SizedBox(height: 20.0),
              const Text(
                "Description",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                recipe.summary,
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 30.0),
              const Text(
                "Ingredients",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ..._ingredientList(recipe.ingredients),
              const SizedBox(height: 30.0),
              const Text(
                "Instructions",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ..._instructionList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recipeInformationBar() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(width: 5.0),
          _servings(),
          const SizedBox(width: 5.0),
          _readyInMinutes(),
          const SizedBox(width: 5.0),
          _calories(),
          const SizedBox(width: 5.0),
        ],
      ),
    );
  }

  Widget _servings() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.person,
          color: Colors.orange,
          size: 18.0,
        ),
        const SizedBox(width: 3.0),
        Text(
          "${recipe.servings} servings",
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _readyInMinutes() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.access_time,
          color: Colors.orange,
          size: 18.0,
        ),
        const SizedBox(width: 3.0),
        Text(
          "${recipe.readyInMinutes} minutes",
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _calories() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.local_fire_department,
          color: Colors.orange,
          size: 18.0,
        ),
        const SizedBox(width: 3.0),
        Text(
          "${recipe.calories} kcal",
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  List<Widget> _ingredientList(List<dynamic> list) {
    return list
        .map((e) => Text(e.toString(), style: const TextStyle(fontSize: 18.0)))
        .toList();
  }

  List<Widget> _instructionList() {
    final List<Widget> instructionList = [];
    for (int i = 0; i < recipe.analyzedInstructions.length; i++) {
      instructionList.add(
        Text(
          'Step ${i + 1}:',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
      );
      instructionList.add(
        Text(
          recipe.analyzedInstructions[i],
          style: const TextStyle(fontSize: 18.0),
        ),
      );
    }
    return instructionList;
  }
}
