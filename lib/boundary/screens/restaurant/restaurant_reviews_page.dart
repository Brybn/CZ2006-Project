import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/control/database.dart';
import 'package:foodapp/entity/restaurant.dart';

class RestaurantReviewsPage extends StatelessWidget {
  RestaurantReviewsPage({Key key, this.restaurant}) : super(key: key);

  final Restaurant restaurant;

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Reviews"),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add_comment),
        iconSize: 38.0,
        splashRadius: 38.0,
        color: Colors.orange,
        tooltip: "Add/Edit Review",
        onPressed: () => _addReviewDialog(context),
      ),
      body: StreamBuilder(
        stream: Database.restaurantReviewsStream(restaurant),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
            _buildTopImage(),
            _buildReviews(snapshot),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopImage() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          height: 200.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                Color.fromRGBO(250, 250, 250, 0.75),
                Color.fromRGBO(250, 250, 250, 0.5),
                Color.fromRGBO(250, 250, 250, 0.25),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              restaurant.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        titlePadding: const EdgeInsets.all(0.0),
        centerTitle: true,
        background: Image(
          fit: BoxFit.cover,
          image: NetworkImage(restaurant.imageUrl),
        ),
      ),
    );
  }

  Widget _buildReviews(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.length > 0) {
        return SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildItemRow(snapshot.data[index]),
              childCount: snapshot.data.length,
            ),
          ),
        );
      }
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text("There are no reviews for this restaurant yet."),
        ),
      );
    }
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> reviewData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(reviewData['user_img']),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              reviewData['user_name'] ?? 'Anonymous',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (FirebaseAuth.instance.currentUser.uid == reviewData['uid'])
              PopupMenuButton(
                tooltip: '',
                position: PopupMenuPosition.under,
                elevation: 2.0,
                splashRadius: 24.0,
                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: reviewData['uid'],
                    height: 36.0,
                    child: const Text("Delete Review"),
                  ),
                ],
                onSelected: (value) =>
                    Database.removeRestaurantReview(restaurant, value),
              )
            else
              const SizedBox(height: 48.0),
          ],
        ),
        Text(
          _formatDate(reviewData['timestamp']),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4.0),
        Text(reviewData['review']),
        const SizedBox(height: 4.0),
        const Divider(thickness: 1.0),
      ],
    );
  }

  String _formatDate(int millisecondsSinceEpoch) {
    final date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Add/Edit Review"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FutureBuilder(
                  future: Database.getRestaurantReview(restaurant),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _textController.text = snapshot.data);
                      return TextFormField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: "Write a review",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        minLines: 3,
                        maxLines: 10,
                        maxLength: 1000,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 20.0),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textController,
                  builder: (context, value, child) =>
                      MaterialButton(
                        height: 50,
                        onPressed: value.text.isEmpty
                            ? null
                            : () {
                          Database.addRestaurantReview(
                              restaurant, _textController.text);
                          _textController.clear();
                          Navigator.pop(context);
                        },
                        disabledColor: Colors.grey,
                        color: Colors.orange,
                        child: const Text(
                          'Post Review',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                ),
              ],
            ),
          ),
    );
  }
}
