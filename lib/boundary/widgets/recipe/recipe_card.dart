import 'package:flutter/material.dart';
import 'package:foodapp/boundary/widgets/recipe/recipe_favorite_button.dart';
import 'package:foodapp/entity/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134.0,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 3.0,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            '/RecipeInformationPage',
            arguments: recipe,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    recipe.image,
                    height: 110.0,
                    width: 110.0,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 12.0),
                _recipeInformationColumn(),
                RecipeFavoriteButton(recipe: recipe),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _recipeInformationColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _readyInMinutes(),
          const SizedBox(height: 3.0),
          _calories(),
        ],
      ),
    );
  }

  Widget _readyInMinutes() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.access_time,
          color: Colors.grey,
          size: 18.0,
        ),
        const SizedBox(width: 3.0),
        Text(
          "${recipe.readyInMinutes} minutes",
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.grey,
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
          color: Colors.grey,
          size: 18.0,
        ),
        const SizedBox(width: 3.0),
        Text(
          "${recipe.calories} kcal",
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
