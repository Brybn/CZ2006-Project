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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: SizedBox(
          width: 200,
          height: 50,
          child: MaterialButton(
            onPressed: () =>
                Database.addRestaurantReview(restaurant, _textController.text),
            color: Colors.orange,
            child: const Text(
              'Add Review',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 300.0,
            height: 100.0,
            alignment: Alignment.center,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Add Review",
                suffixIcon: IconButton(
                  onPressed: () => _textController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: StreamBuilder(
              stream: Database.restaurantReviewsStream(restaurant),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => buildItemRow(
                      context,
                      snapshot.data[index]['review'],
                      snapshot.data[index]['user_img'],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildItemRow(BuildContext context, String review, String imageUrl) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150,
            child: Text(
              review,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
