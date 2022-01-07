
import 'package:flutter/material.dart';

import '../constants.dart';

class AboutUs extends StatefulWidget {
  //const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("About Us"),
        centerTitle: true,
      ),
    );
  }
}
