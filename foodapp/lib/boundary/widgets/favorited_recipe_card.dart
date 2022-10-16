import 'package:flutter/material.dart';

import 'package:foodapp/entity/recipe.dart';
import 'package:foodapp/boundary/screens/recipe_information_page.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: SizedBox(
        height: 124.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 3.0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => RecipeInformationPage(recipe: recipe),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      recipe.image,
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 15.0),
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${recipe.calories} kcal",
                        style: const TextStyle(fontSize: 15.0),
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.orange,
                      size: 38.0,
                    ),
                  ),
                ),
                const SizedBox(width: 7.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
