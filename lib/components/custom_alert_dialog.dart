import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
class CustomDialog {
  static showProgressDialog(BuildContext context){
    ProgressDialog pd = ProgressDialog(context: context  );
    pd.show(max: 100, msg: 'Wait...',progressType: ProgressType.normal);
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            backgroundColor: Colors.green,
            color: Colors.white,
          ),
          Container(margin: EdgeInsets.only(left: 7), child: Text("Wait...")),
        ],
      ),
    );
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, Animation first, Animation second) {
          return Center(
            child: alert,
          );
        });
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
}
