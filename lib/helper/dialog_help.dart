import 'package:flutter/material.dart';
import 'package:jobheebuyer/models/items_model.dart';
import 'package:jobheebuyer/screens/add_order/add_dialog.dart';

class DialogHelp {
  static addItem(context, String uuid, String orderID) =>
      showDialog( builder: (context) => AddItemDialog(uuid: uuid, orderId: orderID), context: context);
}
