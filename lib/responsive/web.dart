// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/screens.dart/add_post.dart';
import 'package:instagram/screens.dart/home.dart';
import 'package:instagram/screens.dart/profile.dart';
import 'package:instagram/screens.dart/search.dart';
import 'package:instagram/shared/colors.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final PageController _pageController = PageController();

  navigateToScreen(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      a = index;
    });
  }
var a;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/img/svg/instagram-text-icon.svg',
          height: 33,
        ),
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                navigateToScreen(0);
              },
              icon: Icon(
                Icons.home,
                color: (a==0)? primaryColor: secondaryColor,
              )),
          IconButton(
              onPressed: () {
                navigateToScreen(1);
              },
              icon: Icon(
                Icons.search,
                color: (a==1)? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                navigateToScreen(2);
              },
              icon: Icon(
                Icons.add_a_photo,
                color: (a==2)? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                navigateToScreen(3);
              },
              icon: Icon(
                Icons.favorite,
                color: (a==3)? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                navigateToScreen(4);
              },
              icon: Icon(
                Icons.person,
                color: (a==4)? primaryColor : secondaryColor,
              )),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {},
        physics: NeverScrollableScrollPhysics(),
        //  controller: _pageController,
        children: [
          Home(),
          Search(),
          AddPost(),
          Profile(),
        ],
      ),
    );
  }
}
