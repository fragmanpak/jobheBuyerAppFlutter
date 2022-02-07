import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jobheebuyer/routes.dart';
import 'package:jobheebuyer/screens/splash/splash_screen.dart';
import 'package:jobheebuyer/size_config.dart';
import 'package:jobheebuyer/theme.dart';

import 'constants.dart';
import 'handler/firebase_notification_handler.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  // firebase appCheck
  await FirebaseAppCheck.instance.activate();
  // for background notification
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  if (!kIsWeb) {
    channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'your channel description',
        enableLights: true,
        enableVibration: true,
        importance: Importance.high,
        playSound: true);
  }
  // for foreground notification
  // final List<PendingNotificationRequest> pendingNotificationRequests =
  //     await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      .createNotificationChannel(channel);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JobHee Buyer',
      theme: theme(),
      //home: InitializerWidget(),
      //We use routeName so that we don`t need to remember the name
      initialRoute: InitializerWidget.routeName,
      routes: routes,
    );
  }
}

class InitializerWidget extends StatefulWidget {
  static String routeName = "/";

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  bool isLoading = true;
  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SplashScreen();
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  print('Handle Background Service : $message');
  dynamic data = message.data['data'];

  FirebaseNotifications.showNotification(data['title'], data['body']);
}
