// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/provider/post_provider.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens.dart/comment.dart';
import 'package:instagram/screens.dart/login.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  final data;

  Post({required this.data, super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int commentCount = 0;
  getData() async {
    QuerySnapshot commentData = await FirebaseFirestore.instance
        .collection('postSSS')
        .doc(widget.data['postId'])
        .collection('commentSSS')
        .get();
    setState(() {
      commentCount = commentData.docs.length;
    });
  }

  late bool liked;
  likedFun() {
    liked =
        widget.data['likes'].contains(FirebaseAuth.instance.currentUser!.uid);
  }

  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            widget.data['uid'] == FirebaseAuth.instance.currentUser!.uid
                ? SimpleDialogOption(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('postSSS')
                          .doc(widget.data['postId'])
                          .delete();
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Delete post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Can not delte a post of anothter user",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    likedFun();
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    print('***********');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.data['profileImg']),
                      backgroundColor: const Color.fromARGB(255, 49, 49, 47),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.data['username'],
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showmodel();
              },
              icon: Icon(
                Icons.more_vert,
              ),
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Image.network(
          widget.data['imgPost'],
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () async{
                      liked?
                        await FirebaseFirestore.instance
                            .collection('postSSS')
                            .doc(widget.data['postId'])
                            .update({
                          "likes": FieldValue.arrayRemove([allDataFromDB!.uid])
                        }):
                        await FirebaseFirestore.instance
                            .collection('postSSS')
                            .doc(widget.data['postId'])
                            .update({
                          "likes": FieldValue.arrayUnion([allDataFromDB!.uid])
                        });
                    setState(() {
                      likedFun();
                    });
                  
                    },
                    icon: liked
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    postData: widget.data,
                                    showTextField: true,
                                  )));
                    },
                    icon: Icon(Icons.comment)),
                IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              ],
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
          ],
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 5),
            width: double.infinity,
            child: Text(
              widget.data['likes'].length.toString(),
              style: TextStyle(
                  color: Color.fromARGB(90, 255, 255, 255), fontSize: 18),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Text(
                widget.data['username'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10),
              Text(widget.data['description'], style: TextStyle(fontSize: 16))
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentScreen(
                          postData: widget.data, showTextField: false)));
            },
            child: Text(
              'view all $commentCount comments',
              style: TextStyle(
                  fontSize: 17, color: const Color.fromARGB(99, 255, 255, 255)),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 7),
          child: Text(
              DateFormat.yMMMd().format(widget.data['datePublished'].toDate()),
              style: TextStyle(
                  fontSize: 17,
                  color: const Color.fromARGB(99, 255, 255, 255))),
        ),
      ],
    );
  }
}
