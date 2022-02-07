import 'package:flutter/material.dart';

import '../constants.dart';

class Help extends StatefulWidget {
  final String payload;
  const Help( this.payload, {Key key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Customer Support"),
        centerTitle: true,
      ),
    body: Center(
      child: Text(widget.payload),
    ),
    );
  }
}
