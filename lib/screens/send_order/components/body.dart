import 'package:flutter/material.dart';
import 'package:jobheebuyer/models/seller_model.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  final Seller sellerData;
  const Body({Key key, this.sellerData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Send Order'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Padding(padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.sellerData.name),
            )
          ],
        ),
      )
    );
  }
}
