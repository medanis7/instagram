import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_services/storage.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/shared/post.dart';
import 'package:instagram/shared/snackbar.dart';

class Auth {
  register(
      {required String email,
      required String password,
      required context,
      required String title,
      required String username,
      required imgName,
      required imgPath}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

//_____________________________
      getImgUrl(imgName: imgName, imgPath: imgPath);
      String url = await getImgUrl(imgName: imgName, imgPath: imgPath);

      CollectionReference users =
          FirebaseFirestore.instance.collection('userSSS');

      UserData user = UserData(
          email: email,
          password: password,
          title: title,
          username: username,
          profileImg: url,
          uid: credential.user!.uid,
          followers: [''],
          following: ['']);

      users
          .doc(credential.user!.uid)
          .set(user.convertToMap())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showSnackBar(context, 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      print('*************');
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  login({required emailAddress, required password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
 // functoin to get user details from Firestore (Database)
Future<UserData> getUserDetails() async {
   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('userSSS').doc(FirebaseAuth.instance.currentUser!.uid).get(); 
   return UserData.convertSnap2Model(snap);
 }
 


}

