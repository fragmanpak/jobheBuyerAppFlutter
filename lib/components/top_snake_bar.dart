import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MyInfoBar extends Flushbar {
  MyInfoBar({
    String message,
    Icon icon,
    bool shouldIconPulse = false,
    // Other properties here and their default values. If you specify no default value, they will be null.
  }) : super(
          // Now send these properties to the parent which is FlushBar
          message: message,
          icon: icon,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          shouldIconPulse: shouldIconPulse,
          borderColor: Colors.white,
          borderWidth: 2.0,
          borderRadius: BorderRadius.circular(8.0),
          boxShadows: [
            BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0)
          ],
          backgroundGradient:
              LinearGradient(colors: [Colors.blueGrey, Colors.black]),
          isDismissible: false,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(left: 5.0, top: 30.0, right: 5.0),
          padding: EdgeInsets.all(10.0),
          // Etc.
        );

  // So what we are doing here is creating a FlushBar with some default properties and naming it MyInfoBar.
  // Now whenever you instantiate MyInfoBar, you get the default notification and you can of course adjust the properties.

  // Static methods are cleaner in this context as in your example,
  // you are instantiating this class but only using it to instantiate
  // a new FlushBar thus eliminating the purpose of the first object you created.
  static Future success({
    String message,
    Icon icon,
    BuildContext context,
  }) {
    return MyInfoBar(message: message, icon: icon).show(context);
  }
}
