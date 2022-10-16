import 'package:flutter/material.dart';

class RecipeFavoriteButton extends StatefulWidget {
  const RecipeFavoriteButton({
    Key key,
    this.id,
  }) : super(key: key);

  final String id;

  @override
  State<RecipeFavoriteButton> createState() => _RecipeFavoriteButtonState();
}

class _RecipeFavoriteButtonState extends State<RecipeFavoriteButton> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0.0),
      iconSize: 49.0,
      splashRadius: 30.0,
      onPressed: _toggleFavorite,
      icon: _isFavorited
          ? const Icon(Icons.star_rounded, color: Colors.orange)
          : const Icon(Icons.star_border_rounded, color: Colors.grey),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }
}
