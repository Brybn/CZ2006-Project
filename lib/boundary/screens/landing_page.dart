import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/boundary/screens/login_page.dart';
import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateUser(FirebaseAuth.instance.currentUser),
    );
  }

  void _updateUser(User user) {
    setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return LoginPage(onSignIn: _updateUser);
    } else {
      return HomePage(onSignOut: () => _updateUser(null));
    }
  }
}
