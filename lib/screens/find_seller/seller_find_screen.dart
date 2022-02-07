import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/screens/find_seller/body.dart';
import 'package:jobheebuyer/services/services.dart';

import '../../constants.dart';

class SellerFindScreen extends StatelessWidget {
  final argument;

  SellerFindScreen({Key key, this.argument}) : super(key: key);
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child(kJob).child(kOrderOfBuyers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () {
        return _onBackPressed(context);
      },
      child: Body(orderId: argument),
    ));
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to cancel order !',
              style: customTextStyle,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              ElevatedButton(
                child: Text('cancel'),
                onPressed: () async {
                  String uuid = await MyDatabaseService.getCurrentUser();
                  if (uuid == null) {
                    Navigator.of(context).pop(true);
                  } else {
                    String orderId = argument;
                    _dbRef.child(uuid).child(orderId).remove();
                    Navigator.of(context).pop(true);
                  }
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}
