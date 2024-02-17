// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/post_provider.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens.dart/register.dart';
import 'package:instagram/shared/colors.dart';
import 'package:provider/provider.dart';

class ProfileSearched extends StatefulWidget {
  final uid;
  ProfileSearched({required this.uid, super.key});

  @override
  State<ProfileSearched> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileSearched> {
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');
  final credential = FirebaseAuth.instance.currentUser;
  var postNum;
    
   bool  followed = true ;
      
  Map userData = {};
  Map currentUserData = {};
  bool isGettingData = true;
  getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userSSS')
          .doc(widget.uid)
          .get();
      userData = snapshot.data()!;
      setState(() {
        isGettingData = false;
      });
    } catch (e) {
      print(e.toString());
    }

try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userSSS')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      currentUserData = snapshot.data()!;
      setState(() {
        isGettingData = false;
      });
    } catch (e) {
      print(e.toString());
    }


    var a = await FirebaseFirestore.instance
        .collection('postSSS')
        .where("uid", isEqualTo: widget.uid)
        .get();
    setState(() {
      postNum = a.docs.length;
    });
    print('##############');
    print(a);
    print(a.docs);

     followed = currentUserData['following'].contains(widget.uid);





  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return isGettingData
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              title: Text(
                userData['username'],
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(userData['userImg']),
                        backgroundColor: const Color.fromARGB(255, 22, 22, 21),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          postNum.toString(),
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(fontSize: 17, color: secondaryColor),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          userData['followers'].length.toString(),
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(fontSize: 17, color: secondaryColor),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          userData['following'].length.toString(),
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          'Following',
                          style: TextStyle(fontSize: 17, color: secondaryColor),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    userData['title'],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: followed
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                followed = false;
         users.doc(credential!.uid).update({"following": FieldValue.arrayRemove([userData['uid']])});
         users.doc(widget.uid).update({"followers": FieldValue.arrayRemove([currentUserData['uid']])});                   
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(153, 0, 0, 0)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: secondaryColor))),
                            ),
                            child: Text(
                              "Unfollow",
                              style: TextStyle(fontSize: 19),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              print('++++++++++++');
                              print( currentUserData['following']);
                              setState(() {
                            followed = true;
                                
                                 users.doc(credential!.uid).update({"following": FieldValue.arrayUnion([userData['uid']])});
                               users.doc(widget.uid).update({"followers": FieldValue.arrayUnion([currentUserData['uid']])});
                                 print('++++++++++++');
                              print( currentUserData['following']);
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[700]),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: secondaryColor))),
                            ),
                            child: Text(
                              "Follow",
                              style: TextStyle(fontSize: 19),
                            ),
                          )),
                SizedBox(
                  width: 14,
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: secondaryColor,
                  thickness: 0.44,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('postSSS')
                      .where("uid", isEqualTo: widget.uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      print('#############');
                      print(snapshot.data.docs);
                      return Expanded(
                        child: Padding(
                          padding: maxWidth > 600
                              ? EdgeInsets.symmetric(
                                  horizontal: maxWidth / 3.5, vertical: 10)
                              : EdgeInsets.all(0),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 3.4,
                                      mainAxisSpacing: 3.8),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        snapshot.data!.docs[index]['imgPost'],
                                        fit: BoxFit.cover,
                                      ),
                                    ));
                              }),
                        ),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}
