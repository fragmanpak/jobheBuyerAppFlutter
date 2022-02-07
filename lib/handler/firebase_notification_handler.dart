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
  BuildContext _context;
  var _token;

  void setupFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessingListener(context);
    _context = context;
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
    print('Settings ${settings.authorizationStatus}');
    _token = _firebaseMessaging
        .getToken()
        .then((token) => print('My Token : $token'));

    // _firebaseMessaging
    //     .subscribeToTopic('subscribe to me')
    //     .whenComplete(() => print('subscribed ok'));

    FirebaseMessaging.onMessage.listen((event) {
      print('My Remote Message: $event');
      if (Platform.isAndroid) {
        showNotification(event.data['title'], event.data['body']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('onMessageOpenedApp : $event');
      if (Platform.isAndroid) {
        showDialog(
            context: _context,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(event.notification.title),
                  content: Text(event.notification.body),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.of(context, rootNavigator: true).pop();
                      },
                    )
                  ],
                ));
      }
    });
  }

  static void showNotification(title, body) async {
    var androidChannel = AndroidNotificationDetails(
        'high_importance_channel_id', 'my channel',
        channelDescription: channel.description,
        autoCancel: false,
        ongoing: true,
        importance: Importance.max,
        icon: '@mipmap/ic_launcher',
        priority: Priority.high);

    var platform = NotificationDetails(
      android: androidChannel,
    );

    await NotificationHandler.flutterLocalNotificationPlugin
        .show(Random().nextInt(1000), title, body, platform, payload: "route");
  }

  int _messageCount = 0;

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> sendFcmMessage(
      String title, String message, String fcm, String route) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": serverKey,
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'type': route},
        "priority": "high",
        "to": fcm,
      };
      // var request2 = {
      //   'notification': {'title': title, 'body': message, "sound": "default"},
      //   'data': {
      //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      //     'type': 'COMMENT'
      //   },
      //   'to': fcm,
      // };
      await http.post(Uri.parse(url),
          headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }
}
