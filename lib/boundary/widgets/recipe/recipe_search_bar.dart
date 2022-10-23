import 'package:flutter/material.dart';

class RecipeSearchBar extends StatelessWidget {
  const RecipeSearchBar({
    Key key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(50.0),
      color: Colors.white,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: "Search",
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          prefixIcon: Icon(Icons.search, color: Colors.orange, size: 27.0),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
