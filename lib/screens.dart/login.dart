// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instagram/firebase_services/auth.dart';
import 'package:instagram/screens.dart/register.dart';
import 'package:instagram/shared/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
   final emailAddress = TextEditingController();
  final password = TextEditingController();
  
 
  @override
   dispose() {
    // TODO: implement dispose
    emailAddress.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
       backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Sign in'),
      ),
      body: Padding(
        padding:  widthScreen>600 ?  EdgeInsets.all(158.0) : EdgeInsets.all(38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextField(
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
                  SizedBox(height: 22,),
                TextField(
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
                  SizedBox(height: 22,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text('Do not have an account?',style: TextStyle(fontSize: 17),),
                    TextButton(onPressed: () {
                      Navigator.pushReplacement(
                context,
                 MaterialPageRoute(
                    builder: (BuildContext context) =>  Register()));
                    }, 
                    child: Text('Sign up',style: TextStyle(fontSize: 17)))
                  ],),
                  SizedBox(height: 54,),
                  ElevatedButton(
   onPressed: (){
    Auth().login(emailAddress: emailAddress.text, password: password.text);
   },
   style: ButtonStyle(
     backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 3, 96, 236)),
     padding: MaterialStateProperty.all(EdgeInsets.all(12)),
     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  ),
   child: Text("Sign in", style: TextStyle(fontSize: 19),),
),
            ],
            
          ),
      ),
      
    );
  }
}