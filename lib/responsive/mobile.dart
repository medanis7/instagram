// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens.dart/add_post.dart';
import 'package:instagram/screens.dart/comment.dart';
import 'package:instagram/screens.dart/home.dart';
import 'package:instagram/screens.dart/profile.dart';
import 'package:instagram/screens.dart/search.dart';
import 'package:instagram/shared/colors.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final PageController _pageController = PageController();

  var a ;
@override
void dispose() {
   _pageController.dispose();
   super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar:
          CupertinoTabBar(
            backgroundColor: mobileBackgroundColor,
            onTap: (index) {
              print(index);
              // navigate to the tabed page
              setState(() {
                a = index;
              });
              print(index);
   _pageController.jumpToPage(index);
            },
             items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (a==0)?primaryColor : secondaryColor,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: (a==1)?primaryColor : secondaryColor,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: (a==2)?primaryColor : secondaryColor,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (a==3)?primaryColor : secondaryColor,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (a==4)?primaryColor : secondaryColor,
            ),
            label: ''),
      ]),
      body: PageView(
   onPageChanged: (index) {
  
   },
   physics: NeverScrollableScrollPhysics(),      
   controller: _pageController,
   children: [
    Home(),
    Search(),
    AddPost(),
    Profile()
    
   ],
),
    );
  }
}
