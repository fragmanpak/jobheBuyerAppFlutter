import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:jobheebuyer/models/seller_model.dart';

import '../constants.dart';
import 'order_status.dart';

class SearchStreamPublisher {
  final _dataBase = FirebaseDatabase.instance.reference().child(kJob);

  Stream<List<Seller>> getSellerStream() {
    final sellerStream = _dataBase.child(kSeller).onValue;
    final streamToPublish = sellerStream.map((event) {
      final sellerMap = Map<String, dynamic>.from(event.snapshot.value);
      final sellerList = sellerMap.entries.map((element) {
        return Seller.fromJson(Map<String, dynamic>.from(element.value));
      }).toList();
      return sellerList;
    });
    return streamToPublish;
  }

  // Stream<OrdersStatusModel> getBuyerOrdersStream(String uuid) {
  //   final sellerStream = _dataBase.child(kAllOrdersStatus).child(uuid).onValue;
  //   final streamToPublish = sellerStream
  //       .map((event) => OrdersStatusModel.fromJson(event.snapshot.value));
  //   return streamToPublish;
  // }
  Stream<List<OrdersStatusModel>> getBuyerOrdersStream(String uuid) {
    final sellerStream = _dataBase.child(kAllOrdersStatus).child(uuid).onValue;
    final streamToPublish = sellerStream.map((event) {
      final sellerMap = Map<String, dynamic>.from(event.snapshot.value);
      final sellerList = sellerMap.entries.map((element) {
        return OrdersStatusModel.fromJson(
            Map<String, dynamic>.from(element.value));
      }).toList();
      return sellerList;
    });
    return streamToPublish;
  }
}
