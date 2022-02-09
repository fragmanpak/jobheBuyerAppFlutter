import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jobheebuyer/components/help.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static BuildContext myContext;

  static initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = AndroidInitializationSettings("jobhee");

    var initSetting = InitializationSettings(android: initAndroid);
    flutterLocalNotificationPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String route) async {
    if (route != null) {
      print('Get  payload: $route ');
    }
    await Navigator.of(myContext).pushNamed(route);
  }
}
