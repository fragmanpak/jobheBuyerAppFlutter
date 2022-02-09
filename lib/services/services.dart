import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheebuyer/screens/splash/splash_screen.dart';

import '../constants.dart';

class MyDatabaseService {
  final auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.reference().child(kJob);

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


  static Future<String> getDeviceToken() async{
    return  await FirebaseMessaging.instance.getToken();
  }

}
