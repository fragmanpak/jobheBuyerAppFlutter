import 'package:flutter/material.dart';

import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    DateTime preBackPress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timeGap = DateTime.now().difference(preBackPress);
        final cantExit = timeGap >= Duration(seconds: 2);
        preBackPress = DateTime.now();
        if (cantExit) {
          //show snack bar
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
