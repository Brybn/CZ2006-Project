import 'package:flutter/material.dart';

class _BaseButton extends StatelessWidget {
  const _BaseButton({this.onPressed, this.iconData});

  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0.0),
      splashRadius: 28.0,
      iconSize: 38.0,
      icon: Icon(iconData, color: Colors.orange),
      onPressed: onPressed,
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
      _BaseButton(iconData: Icons.arrow_back_ios_new, onPressed: onPressed);
}

class SearchFilterButton extends StatelessWidget {
  const SearchFilterButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
      _BaseButton(iconData: Icons.filter_alt_outlined, onPressed: onPressed);
}

class FavoritedRecipesButton extends StatelessWidget {
  const FavoritedRecipesButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _BaseButton(
      iconData: Icons.stars_rounded,
      onPressed: () =>
          Navigator.of(context).pushNamed('/FavoritedRecipesPage'));
}

class HomeButton extends StatelessWidget {
  const HomeButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
      _BaseButton(iconData: Icons.home, onPressed: onPressed);
}

class RecipeSearchButton extends StatelessWidget {
  const RecipeSearchButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
        child: Text(
          "Search Recipes",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }
}
