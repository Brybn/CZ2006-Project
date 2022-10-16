import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget{
  final User _user;
  final String title;
  final String subtitle;
  final String url;
  final dynamic rating;

  const FavoriteWidget({Key key, @required User user, @required String ptitle,
    @required String psubtitle, @required String purl, @required prating})
      :
        _user = user,
        title = ptitle,
        subtitle = psubtitle,
        url = purl,
        rating = prating,
        super(key : key);

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget>{
  User _user;
  String title;
  String subtitle;
  String url;
  dynamic rating;
  String foodId;

  @override
  void initState(){
    _user = widget._user;
    title = widget.title;
    subtitle = widget.subtitle;
    url = widget.url;
    rating = widget.rating;

  }

  bool _isFavorited = false;
  @override
  Widget build(BuildContext context) {
    return (
    IconButton(
      icon: (_isFavorited ? const Icon(Icons.star) : const Icon(Icons.star_border)),
      onPressed:(){
        _toggleFavorite();
        if(_isFavorited == true){
          addData();
        }
        if(_isFavorited == false){
          removeData();
        }

      }
      )
    );
  }

  Future<void> addData()async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.doc(_user.uid).collection("favourites").add({
      'title': title,
      'subtitle': subtitle,
      'url': url,
      'rating': rating
    })
        .then((value) => print(value.id))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> removeData()async
  {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(_user.uid).collection("favourites").doc().delete()
        .then((value) => print("User deleted"))
        .catchError((error) => print("Failed to delete user: $error"));

  }
  void _toggleFavorite(){
    setState((){
      if(_isFavorited){
          _isFavorited = false;
      } else{
        _isFavorited = true;
      }
    });

  }
}

