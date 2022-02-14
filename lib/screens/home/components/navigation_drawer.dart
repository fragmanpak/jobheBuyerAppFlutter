import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheebuyer/components/about_us.dart';
import 'package:jobheebuyer/components/app_updates.dart';
import 'package:jobheebuyer/components/help.dart';
import 'package:jobheebuyer/components/new_snake_bar.dart';
import 'package:jobheebuyer/components/share_with_friends.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheebuyer/screens/completed_orders/complete_orders.dart';
import 'package:jobheebuyer/screens/current_order/current_order.dart';
import 'package:jobheebuyer/screens/home/components/user_page.dart';
import 'package:jobheebuyer/screens/payments/your_payments.dart';
import 'package:jobheebuyer/screens/splash/splash_screen.dart';
import 'package:jobheebuyer/services/services.dart';
import 'package:jobheebuyer/utils/image_assets.dart';

import '../../../constants.dart';
import '../home_screen.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final _auth = FirebaseAuth.instance;
  String name = 'No data';
  String urlImage;

  @override
  void didChangeDependencies() {
    drawerHeaderData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kPrimaryWhiteColor,
        child: ListView(
          children: [
            buildHeader(
                urlImage: urlImage,
                name: name,
                onClicked: () {
                  //getDrawerHeaderFroDB();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserPage(
                        name: name,
                        urlImage: urlImage,
                      ),
                    ),
                  );
                }), // end buildHeader
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: padding,
              color: kPrimaryWhiteColor,
              child: Column(
                children: [
                  Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  buildMenuItem(
                    text: 'Profile',
                    icon: Icons.account_circle_outlined,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  buildMenuItem(
                    text: 'Current Orders',
                    icon: Icons.assignment,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  buildMenuItem(
                    text: 'Completed Orders',
                    icon: Icons.done_outline,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  buildMenuItem(
                    text: 'Payments',
                    icon: Icons.payment,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  buildMenuItem(
                    text: 'Help',
                    icon: Icons.help,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  buildMenuItem(
                    text: 'Share with friends',
                    icon: Icons.share,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  buildMenuItem(
                    text: 'Updates',
                    icon: Icons.update,
                    onClicked: () => selectedItem(context, 7),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(height: 10),
                  buildMenuItem(
                    text: 'About us',
                    icon: Icons.info,
                    onClicked: () => selectedItem(context, 8),
                  ),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 9),
                  ),
                  Divider(color: Colors.black),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      'v 1.0.0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({String text, IconData icon, VoidCallback onClicked}) {
    final color = Colors.black;
    final hoverColor = Colors.black26;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, HomeScreen.routeName);
        break;
      case 1:
        Navigator.pushNamed(context, CompleteProfileScreen.routeName);
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CurrentOrder(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompletedOrders(),
          ),
        );
        break;

      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Payments(),
          ),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Help(),
          ),
        );
        break;
      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShareWithFriends(),
          ),
        );
        break;
      case 7:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Updates(),
          ),
        );
        break;
      case 8:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AboutUs(),
          ),
        );
        break;
      case 9:
        await _auth.signOut();
        Navigator.pushNamed(context, SplashScreen.routeName);
        break;
    }
  }

  Widget buildHeader({
    String urlImage,
    String name,
    VoidCallback onClicked,
  }) =>
      InkWell(
        hoverColor: Colors.greenAccent,
        focusColor: Colors.red,
        onTap: onClicked,
        child: Container(
          color: Colors.white,
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 60,
                  backgroundImage: (urlImage == null)
                      ? AssetImage(ImagesAsset.profileImage)
                      : NetworkImage(urlImage)),
              SizedBox(width: 20),
              Container(
                child: name != null
                    ? Flexible(
                        child: new Container(
                          child: new Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontFamily: 'Roboto',
                              color: new Color(0xFF212121),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'No data',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      );

  void drawerHeaderData() async {
    var check = await InternetConnectionChecker().hasConnection;
    if (check == true) {
      DatabaseReference _firebaseDatabase =
          FirebaseDatabase.instance.reference().child(kJob).child(kSeller);
      String uid = await MyDatabaseService.getCurrentUser();
      if (uid != null) {
        _firebaseDatabase.child(uid).onValue.listen((event) {
          final data = new Map<String, dynamic>.from(event.snapshot.value);
          final result = Seller.fromJson(data);
          print('drawer Header Data : ' + result.toString());
          if (result != null) {
            setState(() {
              name = result.name;
              urlImage = result.picUrl;
            });
          }
        });
      }
    } else {
      MySnakeBar.createSnackBar(
          Colors.black12, 'No Internet Connections', context);
    }
  }
}
