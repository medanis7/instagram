// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagram/firebase_services/auth.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/screens.dart/login.dart';
import 'package:instagram/shared/colors.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
  
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? imgPath;
  String? imgName;
  
  bool isLoading = false;
  bool startedEnteringtPassword = false;
  final emailAddress = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final title = TextEditingController();
 
  @override
   dispose() {
    // TODO: implement dispose
    emailAddress.dispose();
    password.dispose();
    super.dispose();
  }
   uploadImage2Screen(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() async {
          // imgPath = File(pickedImg.path);
          imgPath = await pickedImg.readAsBytes();
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Register'),
      ),
      body: Padding(
        padding: widthScreen > 600
            ? EdgeInsets.symmetric(horizontal: widthScreen / 4)
            : EdgeInsets.all(38),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color:   Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          imgPath == null?
                              const CircleAvatar(
                                  // backgroundColor:
                                  //     Color.fromARGB(255, 225, 225, 225),
                                  radius: 71,
                                  backgroundImage: AssetImage("assets/img/avatar.jpg"),
                                 
                                )
                              :CircleAvatar(
                                  // backgroundColor:
                                  //     Color.fromARGB(255, 225, 225, 225),
                                  radius: 71,
                                  backgroundImage: MemoryImage(imgPath!)
                                 
                                ),
                          Positioned(
                            left: 99,
                            bottom: -10,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(22),
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: ()async  {
                                           await  uploadImage2Screen(
                                                ImageSource.camera);
                                            setState(() {
                                              
                                            });
                                          },
                                          child: Row(children: [
                                            Icon(Icons.camera),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Text('Camera')
                                          ]),
                                        ),
                                        SizedBox(
                                          height: 22,
                                        ),
                                        GestureDetector(
                                          onTap: ()async {
                                           await uploadImage2Screen(ImageSource.gallery);
                                           setState(() {
                                             
                                           });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.folder),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              Text('Gallery')
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 22,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              // uploadImage();
                            
                                
                              },
                              icon: const Icon(Icons.add_a_photo),
                              color: const Color.fromARGB(255, 94, 115, 128),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                ),
                // child: Image.asset('name'),)
                TextField(
                  controller: username,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.person),
                    hintText: 'Enter your username',
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.work),
                    hintText: 'Enter your title',
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                TextFormField(
                  
                  // we return "null" when something is valid
                  validator: (value) {
                    return value!.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        ? null
                        : "Enter a valid email";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  controller: emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(8),  
                    suffixIcon: Icon(Icons.email),
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                TextFormField(
                  onChanged: (value) {
                    startedEnteringtPassword = true;
                    setState(() {
                      if (value!.contains(RegExp(r'.{8,}')) &&
                          value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) &&
                          value.contains(RegExp(r'[a-z]')) &&
                          value.contains(RegExp(r'[0-9]')) &&
                          value.contains(RegExp(r'[A-Z]'))) {
                        startedEnteringtPassword = false;
                      }
                    });
                  },

                  // we return "null" when something is valid
                  validator: (value) {
                    return value!.contains(RegExp(r'.{8,}')) &&
                            value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) &&
                            value.contains(RegExp(r'[a-z]')) &&
                            value.contains(RegExp(r'[0-9]')) &&
                            value.contains(RegExp(r'[A-Z]'))
                        ? null
                        : "Enter a valid password";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.visibility),
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                startedEnteringtPassword
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password should contains:',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Uppercase',
                            style: TextStyle(
                                color: password.text.contains(RegExp(r'[A-Z]'))
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          Text(
                            'Lowercase',
                            style: TextStyle(
                                color: password.text.contains(RegExp(r'[a-z]'))
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          Text(
                            'number',
                            style: TextStyle(
                                color: password.text.contains(RegExp(r'[0-9]'))
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          Text(
                            'Special character',
                            style: TextStyle(
                                color: password.text.contains(
                                        RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          Text(
                            'At least 8 charachters',
                            style: TextStyle(
                                color: password.text.contains(RegExp(r'.{8,}'))
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      )
                    : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 17),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                        },
                        child: Text('Sign in', style: TextStyle(fontSize: 17)))
                  ],
                ),
                SizedBox(
                  height: 54,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        setState(()  {
                          isLoading = true;
                        });
                       await Auth().register(email: emailAddress.text, password: password.text, context: context, title: title.text, username: username.text, imgName: imgName, imgPath: imgPath, );
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Responsive()));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 3, 96, 236)),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Sign up",
                            style: TextStyle(fontSize: 19),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
