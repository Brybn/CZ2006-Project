import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/boundary/widgets/recipe/favorited_recipe_card.dart';
import 'package:foodapp/boundary/widgets/restaurant/favorited_restaurant_card.dart';
import 'package:foodapp/entity/recipe.dart';
import 'package:foodapp/entity/restaurant.dart';

class Database {
  static Future<void> addFavoritedRecipe(Recipe recipe) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_recipes/${recipe.id}';
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(recipe.toMap());
  }

  static Future<void> removeFavoritedRecipe(Recipe recipe) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_recipes/${recipe.id}';
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  static Stream<List<FavoritedRecipeCard>> favoritedRecipesStream() {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_recipes';
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((doc) => doc.data() != null
            ? FavoritedRecipeCard(recipe: Recipe.fromMap(doc.data()))
            : null)
        .toList());
  }

  static Stream<bool> isRecipeFavorited(Recipe recipe) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_recipes/${recipe.id}';
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.data() != null);
  }

  static Future<void> addFavoritedRestaurant(Restaurant restaurant) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_restaurants/${restaurant.id}';
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(restaurant.toMap());
  }

  static Future<void> removeFavoritedRestaurant(Restaurant restaurant) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_restaurants/${restaurant.id}';
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  static Stream<List<FavoritedRestaurantCard>> favoritedRestaurantsStream() {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_restaurants';
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((doc) => doc.data() != null
            ? FavoritedRestaurantCard(
                restaurant: Restaurant.fromMap(doc.data()))
            : null)
        .toList());
  }

  static Stream<bool> isRestaurantFavorited(Restaurant restaurant) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/favorited_restaurants/${restaurant.id}';
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.data() != null);
  }

  static Future<void> addRestaurantReview(
      Restaurant restaurant, String review) {
    final user = FirebaseAuth.instance.currentUser;
    final path = 'restaurants/${restaurant.id}/reviews';
    final reference = FirebaseFirestore.instance.collection(path);
    return reference.add({
      'review': review,
      'user_img': user.photoURL,
      'user': user.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Stream<List<Map<String, dynamic>>> restaurantReviewsStream(
      Restaurant restaurant) {
    final path = 'restaurants/${restaurant.id}/reviews';
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots =
        reference.orderBy('timestamp', descending: true).snapshots();
    return snapshots
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
