import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:jobheebuyer/models/seller_model.dart';

import '../constants.dart';

class CurrentSeller{

  final _dataBase = FirebaseDatabase.instance.reference().child(kJob);
  Future<String> getCurrentSeller(String uuid) {
    final seller=_dataBase.child(kSeller).child(uuid).onValue.listen((event) {
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      final result = Seller.fromJson(data);
      return result;
    });

  }
}