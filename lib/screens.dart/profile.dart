// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/post_provider.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens.dart/register.dart';
import 'package:instagram/shared/colors.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var postNum;

  Map userData = {};
  bool isGettingData = true;
  getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userSSS')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = snapshot.data()!;
      setState(() {
        isGettingData = false;
      });
    } catch (e) {
      print(e.toString());
    }
    var a = await FirebaseFirestore.instance
        .collection('postSSS')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      postNum = a.docs.length;
    });
    print('##############');
    print(a);
    print(a.docs);
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
                          userData['followers'].length.toString() == null
                              ? '0'
                              : userData['followers'].length.toString(),
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
                          userData['following'].length.toString() == null
                              ? '0'
                              : userData['following'].length.toString(),
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
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        size: 24.0,
                      ),
                      label: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(mobileBackgroundColor),
                        padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: secondaryColor))),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Register()));
                      },
                      icon: Icon(
                        Icons.logout,
                        size: 24.0,
                      ),
                      label: Text(
                        "Logout",
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(68, 255, 7, 7)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: secondaryColor))),
                      ),
                    ),
                  ],
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
                      .where("uid",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
