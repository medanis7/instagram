import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserData {
  String email;
  String password;
  String title;
  String username;
  String profileImg;
  String uid;
  List followers;
  List following;
  UserData(
      {required this.email,
      required this.password,
      required this.title,
      required this.username,
      required this.profileImg,
      required this.uid,
      required this.followers,
      required this.following});

  Map<String, dynamic> convertToMap() {
    return {
      'password': password,
      'email': email,
      'title': title,
      'username': username,
      'userImg': profileImg,
      'uid': uid,
      'followers': followers,
      'following': following
    };
  }
  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      email: snapshot["email"],
      username: snapshot["username"],
      password: snapshot['password'],
      title: snapshot["title"],
      profileImg: snapshot["userImg"],
      uid: snapshot['uid'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
