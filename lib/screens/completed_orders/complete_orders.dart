import 'package:flutter/material.dart';

class CompletedOrders extends StatefulWidget {

  @override
  _CompletedOrdersState createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("No completed orders yet"),
      ),
    );
  }
}
