// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens.dart/profile.dart';
import 'package:instagram/screens.dart/profile_searched.dart';
import 'package:instagram/shared/colors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final username = TextEditingController();
  bool bb = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                
                decoration: InputDecoration(
                  hintText: 'Search',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(33)),
                      
                ),
                onChanged: (value) {
                  setState(() {
                    bb = true;
                  });
                },
                controller: username,
              ),
            ),
            bb
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('postSSS')
                        .where("username", isEqualTo: username.text)
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data.docs.length != 0) {
                        return GestureDetector(
                          onTap: () {
                             Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSearched(uid: snapshot.data.docs[0]['uid'],),
                          ),
                        );
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  CircleAvatar(
                                    radius: 33,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[0]['profileImg']),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(snapshot.data!.docs[0]['username'],style: TextStyle(fontSize: 20),)
                                ],
                              ),
                              SizedBox(height: 5,),
                              Divider(thickness: 3,)
                            ],
                          ),
                        );
                      
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    },
                  )
                : SizedBox()
          ],
        ));
  }
}
