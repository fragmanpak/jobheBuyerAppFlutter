import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheebuyer/components/custom_alert_dialog.dart';
import 'package:jobheebuyer/components/new_snake_bar.dart';
import 'package:jobheebuyer/constants.dart';
import 'package:jobheebuyer/handler/firebase_notification_handler.dart';
import 'package:jobheebuyer/models/items_model.dart';
import 'package:jobheebuyer/models/searc_stream_publisher.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/screens/current_order/current_order.dart';
import 'package:jobheebuyer/screens/home/home_screen.dart';
import 'package:jobheebuyer/screens/send_order/SendOrderScreen.dart';
import 'package:jobheebuyer/services/map_services.dart';
import 'package:jobheebuyer/services/services.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../size_config.dart';

class Body extends StatefulWidget {
  final String orderId;

  Body({Key key, this.orderId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child(kJob).child(kSeller);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = new TextEditingController();
  double myLat, myLng = 0.0;
  List<ItemModel> allData = [];
  String uuid;
  double initialRange = 5.0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

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
          child: _loading
              ? Center(child: pd.show(max: 100, msg: 'Loading...'))
              : Column(
                  children: [
                    _searchField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        height: SizeConfig.screenHeight - 220,
                        width: SizeConfig.screenWidth,
                        child: StreamBuilder(
                          stream: SearchStreamPublisher().getSellerStream(),
                          builder: (context, snapshot) {
                            final listTile = <ListTile>[];
                            if (snapshot.hasData) {
                              final sellers = snapshot.data as List<Seller>;
                              listTile.addAll(
                                sellers.map((seller) {
                                  return ListTile(
                                    // shadowColor: kPrimaryColor,
                                    // elevation: 10,
                                    tileColor: Colors.white10,
                                    title: Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenWidth(20),
                                          vertical:
                                              getProportionateScreenHeight(20),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5.0),
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 50,
                                                    child: seller.picUrl != null
                                                        ? NetworkImage(
                                                            seller.picUrl)
                                                        : Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                  ),
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
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                          style:
                                                              customTextStyle,
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          final check =
                                                              InternetConnectionChecker()
                                                                  .hasConnection;
                                                          if (check != null) {
                                                            setState(() {
                                                              _loading = true;
                                                            });
                                                            FirebaseNotifications
                                                                .sendFcmMessage(
                                                                    'New Order',
                                                                    '${seller.name}',
                                                                    '${seller.fcm}',
                                                                     'currentOrder'
                                                            );

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomeScreen(
                                                                          sellerData:
                                                                              seller.uuid),
                                                                ));
                                                          } else {
                                                            MySnakeBar
                                                                .createSnackBar(
                                                                    Colors.red,
                                                                    'No Internet Connection',
                                                                    context);
                                                          }
                                                        },
                                                        child:
                                                            Text('SendOrder'),
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            } else {
                              return Center(
                                child: CustomDialog.showLoaderDialog(context),
                              );
                            }
                            return ListView(
                              children: listTile,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  // showDataList() {
  //   String orderId = OrderModel.getOrderId;
  //   _dbRef.child(uuid).child(orderId).once().then((DataSnapshot snapshot) {
  //     if (snapshot.value == null) {
  //       print(snapshot.value.toString());
  //     } else {
  //       var keys = snapshot.value.keys;
  //       var data = snapshot.value;
  //       allData.clear();
  //     }
  //   });
  //   print(allData);
  // }

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
            var result = await MapService.instance.getCurrentPosition();
            //result.latLng;

            if (_formKey.currentState.validate()) {
              debugPrint("Valid");
              print('valid');
            }
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
    var result = await MapService.instance.getCurrentPosition();
    setState(() {
      myLat = result.latLng.latitude;
      myLng = result.latLng.longitude;
    });
  }
}
