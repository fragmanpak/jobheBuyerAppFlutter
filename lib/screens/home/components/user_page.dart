import 'package:flutter/material.dart';
import 'package:jobheebuyer/constants.dart';

class UserPage extends StatelessWidget {
  final String name;

  final String urlImage;

  const UserPage({this.name, this.urlImage, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(name),
      ),
      body: Image.network(
        urlImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}