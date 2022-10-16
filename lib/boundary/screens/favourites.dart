import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Favourites extends StatefulWidget {

  const Favourites({Key  key, User user})
      : _user = user,
        super(key: key);
  final User _user;


  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  User _user;

  @override
  void initState(){
    _user =widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          backgroundColor: Colors.orange,
          title:
           Text("Favorites"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                       .collection('users').doc(_user.uid)
                       .collection('favourites').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> favSnapshot) {
                  return favSnapshot.hasData ?
                  Expanded(
                    child: ListView.builder(
                        itemCount: favSnapshot.data.docs.length,
                        itemBuilder: (context,index){
                          DocumentSnapshot data = favSnapshot.data.docs[index];
                          return buildItem(data.get('title'), data.get('subtitle'),
                              data.get('url'), data.get('rating'), data.id);
                        }),
                  ) : Container();
                }

                  ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildItem(String title, String subTitle, String url,
      rating, String dataId) {

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: url,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(

                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2.0, spreadRadius: 1.0, color: Colors.grey)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 80,
                              child: Text(
                                title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                            ),
                            Container(
                              width: 120,
                              child: Text(
                                subTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),
                  Row(children: [
                    IconButton(
                      icon: Icon(Icons.delete_outlined),
                      onPressed:() {
                        removeData(dataId);
                      }
                    )
                    ,]
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );


  }

  Future<void> removeData(String docId)async {
    await FirebaseFirestore.instance.collection('users')
        .doc(_user.uid).collection("favourites").doc(docId).delete()
        .then((value) => print("food deleted"))
        .catchError((error) => print("Failed to delete user: $error"));

  }



}
