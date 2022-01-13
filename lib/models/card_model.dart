import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/models/seller_model.dart';

import '../constants.dart';

class CardModel extends ChangeNotifier {
  List<Seller> _sellerList = [];
  final _db = FirebaseDatabase.instance.reference().child(dbTName);
  StreamSubscription _sellerStream;
  static const SELLER_PATH = 'seller';

  List<Seller> get seller => _sellerList;

  CardModel() {
    _listenToSeller();
  }

  void _listenToSeller() {
    _sellerStream = _db.child(SELLER_PATH).onValue.listen((event) {
      final allSellers = Map<String, dynamic>.from(event.snapshot.value);
      _sellerList = allSellers.values
          .map((sellerAsJson) =>
              Seller.fromRTDB(Map<String, dynamic>.from(sellerAsJson)))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sellerStream.cancel();
    super.dispose();
  }
}
