import 'package:flutter/material.dart';
import 'package:jobheebuyer/constants.dart';

class MySnakeBar {
  static createSnackBar(Color clr, String message, BuildContext context) {
    final snackBar = new SnackBar(
        content: new Text(
          message,
          style: customTextStyle,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: clr);
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
