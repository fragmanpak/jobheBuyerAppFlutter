import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/components/about_us.dart';
import 'package:jobheebuyer/components/app_updates.dart';
import 'package:jobheebuyer/components/help.dart';
import 'package:jobheebuyer/components/share_with_friends.dart';
import 'package:jobheebuyer/models/items_model.dart';
import 'package:jobheebuyer/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheebuyer/screens/completed_orders/complete_orders.dart';
import 'package:jobheebuyer/screens/current_order/current_order.dart';
import 'package:jobheebuyer/screens/home/components/user_page.dart';
import 'package:jobheebuyer/screens/otp/otp_registration.dart';
import 'package:jobheebuyer/screens/payments/your_payments.dart';

import '../../../constants.dart';
import '../home_screen.dart';

class NavigationDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .reference()
      .child(dbTName)
      .child(tbBuyer);
  @override
  Widget build(BuildContext context) {
    final name = 'test1';
    final email = 'test@gamil.com';
    final urlImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPlqk-tNmFTjT7q_edAjaYLU5qf2cFUM9vfrweUbqnS_58LqF7AMp67KVdslIubuzy9b4&usqp=CAU';

    return Drawer(
      child: Container(
        color: kPrimaryWhiteColor,
        child: ListView(
          children: [
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: (){
                getDrawerHeaderFroDB();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserPage(
                      name: 'Himura Kenshan',
                      urlImage: urlImage,
                    ),
                  ),
                );
              }
            ), // end buildHeader
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
        Navigator.pushNamed(context, OtpRegistration.routeName);
        break;
    }
  }


  Widget buildHeader({
    String urlImage,
    String name,
    String email,
    VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          color: Colors.white,
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 50, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  void getDrawerHeaderFroDB() {
    String uid= currentUser();
    _dbRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        print(snapshot.value.toString());
      } else {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        //allData.clear();

        for (var key in keys) {
          if(uid == key){

          }
          ItemModel d = new ItemModel(
            data[key]['itemID'],
            data[key]['itemName'],
            data[key]['itemQuantity'],
            data[key]['itemUnit'],
          );
          //allData.add(d);
        }
      }
    });

  }
  String currentUser() {
    String uuid;
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        uuid = currentUser.uid;
        print('Uuid of current user = ' + uuid);
        return uuid;
      }
    } catch (e) {
      print('current user error hy+ ' + e);
      return null;
    }
    return null;
  }

}
