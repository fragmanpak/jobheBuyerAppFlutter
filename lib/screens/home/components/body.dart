import 'package:flutter/material.dart';
import 'package:jobheebuyer/components/custom_tab_bar.dart';
import 'package:jobheebuyer/screens/add_order/order_add.dart';
import 'package:jobheebuyer/screens/completed_orders/complete_orders.dart';
import 'package:jobheebuyer/screens/current_order/current_order.dart';
import 'package:jobheebuyer/screens/find_seller/seller_find_screen.dart';

import '../../../constants.dart';
import 'navigation_drawer.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: NavHeader(),
    );
  }
}

class NavHeader extends StatefulWidget {
  //const NavHeader({Key key}) : super(key: key);

  @override
  _NavHeaderState createState() => _NavHeaderState();
}

class _NavHeaderState extends State<NavHeader> {
  int _currentIndex = 0;

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      drawer: NavigationDrawer(),
      body: <Widget>[
        CurrentOrder(),
        CompletedOrders(),
      ][_currentIndex],
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => AddOrder()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            TabItem(
                text: 'CurrentOrders',
                icon: 'assets/icons/Flash Icon.svg',
                isSelected: _currentIndex == 0,
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                }),
            Spacer(),
            TabItem(
                text: 'CompleteOrders',
                icon: 'assets/icons/Gift Icon.svg',
                isSelected: _currentIndex == 1,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
