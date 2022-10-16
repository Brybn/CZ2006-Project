import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/login_page.dart';
import 'package:foodapp/control/authentication.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final Authentication auth;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return LoginPage(onSignIn: _updateUser, auth: widget.auth);
    } else {
      return HomePage(onSignOut: () => _updateUser(null), auth: widget.auth);
    }
  }
}
