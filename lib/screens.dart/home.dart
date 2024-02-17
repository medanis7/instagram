// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/provider/post_provider.dart';
import 'package:instagram/shared/colors.dart';
import 'package:instagram/shared/post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {

    double ScreenWidth = MediaQuery.of(context).size.width;
    // return allDataFromDB==null? CircularProgressIndicator() :
    return Scaffold(
      
      backgroundColor: ScreenWidth<600? mobileBackgroundColor: webBackgroundColor,
      
      appBar:(ScreenWidth<600)? AppBar(
        title: SvgPicture.asset(
          'assets/img/svg/instagram-text-icon.svg',
          color: Colors.white,
          height: 33,
        ),
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.messenger_outline,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ):null,
      body:  StreamBuilder<QuerySnapshot>(
      stream:  FirebaseFirestore.instance.collection('postSSS').snapshots(),

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return  Post(data: data,);
          }).toList(),
        );
      },
    )
    );
  }
}
