import 'package:flutter/material.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/services/services.dart';

import '../../constants.dart';
import 'components/body.dart';

class SendOrderScreen extends StatelessWidget {
   final sellerData;
   SendOrderScreen({Key key, this.sellerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () {
            return _onBackPressed(context);
          },
          child: Body(sellerData: sellerData),
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
                    // String orderId = argument;
                    // _dbRef.child(uuid).child(orderId).remove();
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
