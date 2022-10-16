import 'package:flutter/material.dart';

import 'package:foodapp/boundary/widgets/common_buttons.dart';

class FavoritedRecipesPage extends StatelessWidget {
  const FavoritedRecipesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffefefef),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              CustomBackButton(onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          const Text(
            "Favorites",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
