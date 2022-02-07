import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/components/new_snake_bar.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../constants.dart';

class CurrentOrder extends StatelessWidget {
  final String sellerData;

  CurrentOrder({Key key, this.sellerData}) : super(key: key);
  final _dataBase = FirebaseDatabase.instance.reference().child(kJob);

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      body: sellerData != null
          ? StreamBuilder(
              stream: _dataBase.child(kSeller).child(sellerData).onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState != null) {
                  if (snapshot.hasData) {
                    final data = new Map<String, dynamic>.from(
                        (snapshot.data as Event).snapshot.value);
                    final result = Seller.fromJson(data);
                    return ListTile(
                      leading: CircleAvatar(
                        child: result.picUrl != null
                            ? NetworkImage(result.picUrl)
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      title: Text(result.name),
                    );
                  } else if (snapshot.hasError) {
                    MySnakeBar.createSnackBar(
                        Colors.deepOrange, snapshot.error, context);
                  }
                }
                return Text('');
              },
            )
          : Center(
              child: pd.show(
                  max: 100,
                  msg: 'Please wait....',
                  progressType: ProgressType.normal,
                  borderRadius: 2.0,
                backgroundColor: Colors.red,
                barrierDismissible: false,
                barrierColor: Colors.deepOrange,
                elevation: 10,
                progressBgColor: Colors.green,


              ),
            ),
    );
  }
}
