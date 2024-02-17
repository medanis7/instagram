import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/firebase_services/storage.dart';
import 'package:instagram/models/post.dart';

import 'package:uuid/uuid.dart';


class FirestoreMethods {
  
  post(
      {required profileImg,
      required username, 
      required description,
      required postId,
      required imgName,
      required imgPath, required  context}) async {
    getImgUrl(imgName: imgName, imgPath: imgPath);
    String url = await getImgUrl(imgName: imgName, imgPath: imgPath);
    CollectionReference posts =
        FirebaseFirestore.instance.collection('postSSS');

    PostData post = PostData(
        profileImg: profileImg,
        username: username,
        description: description,
        imgPost: url,
        uid: FirebaseAuth.instance.currentUser!.uid,
        postId: const Uuid().v1(),
        datePublished: DateTime.now(),
        likes: []);

    posts
        .doc(post.postId)
        .set(post.convertToMap())
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));

  }


}
