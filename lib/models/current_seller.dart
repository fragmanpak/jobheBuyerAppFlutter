import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:jobheebuyer/models/seller_model.dart';

import '../constants.dart';

class CurrentSeller{

  final _dataBase = FirebaseDatabase.instance.reference().child(kJob);
  Stream getCurrentSeller(String uuid) {
    final seller=_dataBase.child(kSeller).child(uuid).onValue.map((event){
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      final result = Seller.fromJson(data);
       return result;
    });
     return seller;


    // listen((event) {
    //   final data = new Map<String, dynamic>.from(event.snapshot.value);
    //   final result = Seller.fromJson(data);
    //   return result;
    // });
    // return seller;
  }
}