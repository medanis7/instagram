// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens.dart/profile.dart';
import 'package:instagram/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatefulWidget {
  final postData;
  final showTextField;
  CommentScreen({required this.postData,required this.showTextField, super.key});

  @override
  State<CommentScreen> createState() => _CommentState();
}

class _CommentState extends State<CommentScreen> {
  final commentText = TextEditingController();
  bool isGettingData = true;
  Map commentData = {};

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comment'),
      ),
      body: allDataFromDB == null
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('postSSS')
                      .doc(widget.postData['postId'])
                      .collection('commentSSS').orderBy('datePublished',descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profilePic']),
                                  radius: 26,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data['username'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data['textComment'],
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(DateFormat.yMMMd()
                                        .format(data['datePublished'].toDate()))
                                  ],
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
               widget.showTextField? Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(allDataFromDB!.profileImg),
                          radius: 26,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: TextField(
                              controller: commentText,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(8),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      String commentId = const Uuid().v1();

                                      FirebaseFirestore.instance
                                          .collection('postSSS')
                                          .doc(widget.postData['postId'])
                                          .collection('commentSSS')
                                          .doc(commentId)
                                          .set({
                                        'profilePic': allDataFromDB.profileImg,
                                        'textComment': commentText.text,
                                        'datePublished': DateTime.now(),
                                        'uid': allDataFromDB.uid,
                                        'commentId': commentId,
                                        'postId': widget.postData['imgPost'],
                                        'username': allDataFromDB.username
                                      });
                                      commentText.clear();
                                    },
                                    icon: Icon(Icons.comment)),
                                hintText: 'Enter your comment',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ): SizedBox()
              ],
            ),
    );
  }
}
