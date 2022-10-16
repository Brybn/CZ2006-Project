import 'package:flutter/material.dart';
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
          IconButton(onPressed: () => {}, icon: const Icon(Icons.star)),
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
              Text(
                recipe.ingredients,
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 30.0),
              const Text(
                "Instructions",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ..._instructionsList(recipe.analyzedInstructions),
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
}

List<Widget> _instructionsList(List<String> instructions) {
  return instructions
      .map((e) => Text(e, style: const TextStyle(fontSize: 18.0)))
      .toList();
}
