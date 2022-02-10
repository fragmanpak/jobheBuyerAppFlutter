import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheebuyer/screens/splash/splash_screen.dart';

import '../constants.dart';

class MyDatabaseService {
  final auth = FirebaseAuth.instance;
  static final _database = FirebaseDatabase.instance.reference().child(kJob);

  Stream<List<Seller>> getSellersStream() {
    final sellerStream = _database.child('seller').onValue;

    final streamToPublish = sellerStream.map((event) {
      final sellerMap = Map<String, dynamic>.from(event.snapshot.value);
      final sellerList = sellerMap.entries.map((e) {
        return Seller.fromJson(Map<String, dynamic>.from(e.value));
      }).toList();
      return sellerList;
    });
    return streamToPublish;
  }

  createUser(email, password, context) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) =>
              Navigator.pushNamed(context, CompleteProfileScreen.routeName));
    } catch (e) {
      error(context, e);
    }
  }

  loginUser(email, password, context) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
              (value) => Navigator.pushNamed(context, SplashScreen.routeName));
    } catch (e) {
      error(context, e);
    }
  }

  error(context, e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          );
        });
  }

  static Future<String> getCurrentUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return currentUser.uid;
      }
    } catch (e) {
      print('current user error hy+ ' + e);
      return null;
    }
    return null;
  }

  static Future<String> getDeviceToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  static Future<bool> saveDeviceToken(String token) async {
    var check = await InternetConnectionChecker().hasConnection;
    if (check == true) {
      try {
        var uuid = await MyDatabaseService.getCurrentUser();
        _database.child(kBuyer).child(uuid).onValue.listen((event) async {
          final data = new Map<String, dynamic>.from(event.snapshot.value);
          final result = Seller.fromJson(data);
          if (result.fcm != null) {
            int res = token.compareTo(result.fcm);
            print(res);
            if (res != 0) {
              await _database.child(kBuyer).child(uuid).update({'fcm': token});
            }
          }
        });
        return true;
      } on Exception catch (e) {
        print('Saving token to database failed :' + e.toString());
        return false;
      }
    }
    return false;
  }
}
