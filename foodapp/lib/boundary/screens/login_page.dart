import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodapp/boundary/widgets/google_sign_in_button.dart';

import 'package:foodapp/control/authentication.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key key,
    @required this.onSignIn,
    @required this.auth,
  }) : super(key: key);

  final Authentication auth;
  final void Function(User) onSignIn;

  Future<void> _signInWithGoogle() async {
    try {
      final user = await auth.signInWithGoogle();
      onSignIn(user);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app-logo.png',
                height: 200,
                width: 200,
              ),
              Text(
                'EasyFood',
                style: GoogleFonts.bebasNeue(fontSize: 52),
              ),
              const SizedBox(height: 10),
              const Text(
                'Get Your preferred restaurants and recipes',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GoogleSignInButton(onPressed: _signInWithGoogle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
