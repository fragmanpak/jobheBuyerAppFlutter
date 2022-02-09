import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jobheebuyer/main.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'notification_handler.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  //BuildContext _context;

  void setupFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessingListener(context);
    // _context = context;
  }

  void firebaseCloudMessingListener(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print(
        'Notification Authorization Status Settings ${settings.authorizationStatus}');
    //_token = await MyDatabaseService.getDeviceToken();

    _firebaseMessaging
        .subscribeToTopic('subscribe to me')
        .whenComplete(() => print('subscribed ok'));
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('My Remote Message: ${message.data}');
      if (message.notification != null &&
          message.notification.android != null) {
        print(message.notification.body);
        print(message.notification.title);
      }
      if (Platform.isAndroid) {
        showNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print('onMessageOpenedApp : $event');
    //   if (Platform.isAndroid) {
    //     showDialog(
    //         context: _context,
    //         builder: (context) => CupertinoAlertDialog(
    //               title: Text(event.notification.title),
    //               content: Text(event.notification.body),
    //               actions: [
    //                 CupertinoDialogAction(
    //                   isDefaultAction: true,
    //                   child: Text('OK'),
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                     // Navigator.of(context, rootNavigator: true).pop();
    //                   },
    //                 )
    //               ],
    //             ));
    //   }
    // });
  }

  static void showNotification(RemoteMessage message) async {
    try {
      var androidChannel = AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          autoCancel: false,
          ongoing: true,
          importance: Importance.max,
          icon: '@drawable/splash',
          priority: Priority.high);

      var platform = NotificationDetails(
        android: androidChannel,
      );

      await NotificationHandler.flutterLocalNotificationPlugin.show(
          Random().nextInt(1000),
          message.notification.title,
          message.notification.body,
          platform,
          payload: "route");
    } on Exception catch (e) {
      print('Show notification error' + e.toString());
    }
  }

  static Future<bool> sendFcmMessage(
      String title, String message, String fcm, String route) async {
    print(title + message + fcm + route);
    try {
      var url = "https://fcm.googleapis.com/fcm/send";
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key=" + serverKey,
      };
      var request = {
        "to": fcm,
        "direct_boot_ok": true,
        "notification": {
          "title": title,
          "body": message,
          "sound": "default",
          "color": "#990000",
        },
        "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "type": route},
        "priority": "high",
      };
      await http
          .post(Uri.parse(url), headers: header, body: json.encode(request))
          .then((value) {
        //print(value.body);
        // print(value.bodyBytes);
        print(value.statusCode);
        // print(value.contentLength);
        print(value.headers);
        // print(value.isRedirect);
        //print(value.persistentConnection);
        print(value.reasonPhrase);
        //print(value.request);
      });
      return true;
    } catch (e, s) {
      print(e);
      print(s);
      return false;
    }
  }
}
