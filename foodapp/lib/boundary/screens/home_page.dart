import 'package:flutter/material.dart';
import 'package:foodapp/control/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    @required this.auth,
    @required this.onSignOut,
  }) : super(key: key);

  final Authentication auth;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Text(
                "Hello, \n${auth.currentUser.displayName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/RestaurantPage',
                          arguments: auth.currentUser,
                        );
                      },
                      child: Column(
                        children: const [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/restaurant.jpeg'),
                            radius: 70,
                          ),
                          Text(
                            "Restaurants",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/RecipePage');
                      },
                      child: Column(
                        children: const [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/recipes.jpg'),
                            radius: 70,
                          ),
                          Text(
                            "Recipes",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: _signOutButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: _signOut,
      child: const Text(
        'Logout',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
