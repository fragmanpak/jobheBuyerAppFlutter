import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jobheebuyer/components/new_snake_bar.dart';
import 'package:jobheebuyer/constants.dart';
import 'package:jobheebuyer/handler/firebase_notification_handler.dart';
import 'package:jobheebuyer/models/searc_stream_publisher.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/screens/home/home_screen.dart';
import 'package:jobheebuyer/services/map_services.dart';
import 'package:jobheebuyer/services/services.dart';
import 'package:jobheebuyer/utils/image_assets.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../size_config.dart';

class Body extends StatefulWidget {
  final String orderId;

  Body({Key key, this.orderId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = new TextEditingController();
  double myLat, myLng = 0.0;
  String uuid;
  DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.reference().child(kJob);

  //double initialRange = 5.0;

  @override
  void didChangeDependencies() {
    _loadResources();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(search_nearby_sellers),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              _searchField(),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  height: SizeConfig.screenHeight - 220,
                  width: SizeConfig.screenWidth,
                  child: StreamBuilder(
                    stream: SearchStreamPublisher().getSellerStream(),
                    builder: (context, snapshot) {
                      final listTile = <ListTile>[];
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                        if (snapshot.hasData) {
                          final sellers = snapshot.data as List<Seller>;
                          listTile.addAll(
                            sellers.map((seller) {
                              return ListTile(
                                selectedTileColor: Colors.white38,
                                tileColor: Colors.white10,
                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(20),
                                    vertical: getProportionateScreenHeight(20),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 5.0),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                                radius: 30,
                                                backgroundImage:
                                                    (seller.picUrl != null)
                                                        ? NetworkImage(
                                                            seller.picUrl)
                                                        : AssetImage(ImagesAsset
                                                            .profileImage)),
                                            Text(
                                              '${seller.onlineStatus}',
                                              style: customTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.only(left: 5.0),
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Name: ${seller.name}',
                                                  style: customTextStyle,
                                                ),
                                                Text(
                                                  'Complete Orders: ${seller.completeOrders}',
                                                  style: customTextStyle,
                                                ),
                                                Text(
                                                  'Ratings: ${seller.rating}',
                                                  style: customTextStyle,
                                                ),
                                                Text(
                                                  'BusinessType: ${seller.businessType}',
                                                  style: customTextStyle,
                                                ),
                                                Text(
                                                  'Description: ${seller.description}',
                                                  style: customTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 300,
                                                  child: Text(
                                                    'Address: ${seller.address}',
                                                    maxLines: 3,
                                                    style: customTextStyle,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    pd.show(
                                                        max: 100,
                                                        msg: 'Please wait...',
                                                        barrierDismissible:
                                                            false);
                                                    final check =
                                                        await InternetConnectionChecker()
                                                            .hasConnection;
                                                    if (check == true) {
                                                      try {
                                                        await _firebaseDatabase
                                                            .child(
                                                                kAllOrdersStatus)
                                                            .child(uuid)
                                                            .child(
                                                                widget.orderId)
                                                            .set({
                                                              'buyerId': uuid,
                                                              'titleMessage':
                                                                  ORDER_STATUS_MSG_NEW_ORDER,
                                                              'orderId': widget
                                                                  .orderId,
                                                              'sellerId':
                                                                  seller.uuid,
                                                              'localTime':
                                                                  DateFormat
                                                                          .yMd()
                                                                      .add_jm()
                                                                      .toString(),
                                                            })
                                                            .timeout(Duration(
                                                                minutes: 1))
                                                            .whenComplete(
                                                                () async {
                                                              var status = await FirebaseNotifications.sendFcmMessage(
                                                                  'New Order',
                                                                  'From Buyer ${seller.name}',
                                                                  '${seller.fcm}',
                                                                  'HomeScreen');

                                                              print("Order Id : " +
                                                                  widget
                                                                      .orderId);
                                                              if (status ==
                                                                  true) {
                                                                pd.close();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen(),
                                                                    ));
                                                              } else {
                                                                pd.close();
                                                                MySnakeBar.createSnackBar(
                                                                    Colors
                                                                        .blueGrey,
                                                                    '${seller.name} is not responding',
                                                                    context);
                                                              }
                                                            });
                                                      } on Exception catch (e) {
                                                        pd.close();
                                                        print(e);
                                                      }
                                                    } else {
                                                      pd.close();
                                                      MySnakeBar.createSnackBar(
                                                          Colors.red,
                                                          'No Internet Connection! try again later',
                                                          context);
                                                    }
                                                  },
                                                  child: Text('SendOrder'),
                                                )
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                      return ListView(
                        children: listTile,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _searchField() {
    return TextFormField(
      maxLength: 2,
      inputFormatters: [FilteringTextInputFormatter.allow(numberPattern)],
      controller: _searchController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please entered the number \n  between 1 to 35 km';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Search Seller',
        hintText: 'search within 55 km',
        suffixIcon: IconButton(
          onPressed: () async {
            // var result = await MapService.instance.getCurrentPosition();
            // var dd = result.latLng.latitude;
            // var dd2 = result.latLng.longitude;
            // print(dd + dd2);
            // if (_formKey.currentState.validate()) {
            //   debugPrint("Valid");
            //   print('valid');
            // }
            //_searchController.clear();
          },
          icon: Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _loadResources() async {
    uuid = await MyDatabaseService.getCurrentUser();
  }
}
