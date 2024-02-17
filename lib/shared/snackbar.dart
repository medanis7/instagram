import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      content: Text(text),
      action: SnackBarAction(label: "Close", onPressed: () {}),
    ));
 }