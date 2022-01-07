import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheebuyer/components/top_snake_bar.dart';
import 'package:jobheebuyer/helper/order_model.dart';
import 'package:jobheebuyer/models/items_model.dart';
import 'package:jobheebuyer/screens/find_seller/seller_find_screen.dart';
import 'package:jobheebuyer/size_config.dart';

import '../../constants.dart';

class AddOrder extends StatefulWidget {
  // const AddOrder({Key? key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  StreamSubscription netSubscription;
  DatabaseReference _dbRef = FirebaseDatabase.instance
      .reference()
      .child(dbTName)
      .child(tbOrderOfBuyers);

  //StreamSubscription _dbRefSubscription;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _textQntController = new TextEditingController();
  String _selectedText = 'kg';
  String uuid = 'kyLErlq5pmMFhSSuLucuj4izpIG3';
  bool hasInternet = false;
  List<ItemModel> allData = [];

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainers = 0;

  @override
  void initState() {
    String orderId = _dbRef.push().key;
    OrderModel.setOrderId(orderId);
    uuid = currentUser();
    super.initState();
    showDataList();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainers = value;
        closeTopContainer = controller.offset > 65;
        print('topContainer = ' + topContainers.toString() + "    "+
            'closeTopContainer = ' + closeTopContainer.toString() );
      });
    });
    netSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      if (hasInternet == true) {
        //  this.uuid=currentUser();
      }
    });
  }

  currentUser() {
    // final User user = FirebaseAuth.instance.currentUser;
    // final uid = user.uid.toString();
    // return uid;
    return 'kyLErlq5pmMFhSSuLucuj4izpIG3';
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.65;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Make Order'),
        backgroundColor: kPrimaryColor,
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          height: SizeConfig.screenHeight,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                  color: Colors.greenAccent,
                  height: closeTopContainer ? 0 : categoryHeight - 40,
                  width: SizeConfig.screenWidth,
                  duration: const Duration(milliseconds: 400),
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.red,
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.all(15.0),
                        height: categoryHeight - 50,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              maxLength: 15,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(textPattern)
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Item Name'),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 5,
                              controller: _textQntController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Item Quantity'),
                            ),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedText,
                                    icon: Icon(Icons.arrow_downward_sharp,
                                        color: Colors.blueAccent, size: 20),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _selectedText = newValue;
                                      });
                                    },
                                    items: <String>[
                                      'kg',
                                      'ml',
                                      'meter',
                                      'other'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.only(left: 12.0),
                                          child: Text(value,
                                              style: customTextStyle),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )),
                            ElevatedButton(
                              style: buttonStyle,
                              onPressed: () async {
                                hasInternet = await InternetConnectionChecker()
                                    .hasConnection;
                                if (hasInternet == false) {
                                  MyInfoBar.success(
                                      message: 'No Internet Connection',
                                      icon: Icon(
                                        Icons.wifi,
                                        size: 30.0,
                                        color: Colors.red,
                                      ),
                                      context: context);
                                } else {
                                 // uuid = currentUser();
                                  if (_nameController.text.length == 0 ||
                                      _textQntController.text.length == 0) {
                                    return showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Alert warning'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: const <Widget>[
                                                  Text('Fields can`t be empty'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Fine',
                                                    style: customTextStyle),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    String orderId = OrderModel.getOrderId;
                                    String itemID = _dbRef
                                        .child(tbOrderOfBuyers)
                                        .child(orderId)
                                        .push()
                                        .key;
                                    final nextOrder = <String, dynamic>{
                                      'itemID': itemID,
                                      'itemName': _nameController.text,
                                      'itemQuantity': _textQntController.text,
                                      'itemUnit': _selectedText,
                                    };
                                    await _dbRef
                                        .child(uuid)
                                        .child(orderId)
                                        .child(itemID)
                                        .set(nextOrder)
                                        .whenComplete(() {
                                      _nameController.clear();
                                      _textQntController.clear();
                                      showDataList();
                                      MyInfoBar.success(
                                          message:
                                              'Item add to cart successfully',
                                          icon: Icon(
                                            Icons.add_task,
                                            size: 30.0,
                                            color: Colors.green,
                                          ),
                                          context: context);
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Add',
                                style: customTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: allData.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // return cardUI(
                      //     index,
                      //     allData[index].itemId,
                      //     allData[index].itemName,
                      //     allData[index].itemQuantity,
                      //     allData[index].itemUnit) ;
                      double scale = 1.0;
                      if (topContainers > 0.5) {
                        scale = index + 0.5 - topContainers;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 1,
                              alignment: Alignment.topCenter,
                              child: cardUI(
                                  index,
                                  allData[index].itemId,
                                  allData[index].itemName,
                                  allData[index].itemQuantity,
                                  allData[index].itemUnit)),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (allData.length == 0) {
            print('list null hey');
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SellerFindScreen(),
              ),
            );
          }
        },
        label: Text('Find Seller'),
        icon: const Icon(Icons.search),
        backgroundColor: kPrimaryColor,
      ),
    ));
  }

  Widget cardUI(int index, String itemId, String itemName, String itemQuantity,
      String itemUnit) {
    return Dismissible(
        key: ValueKey(itemId),
        direction: DismissDirection.endToStart,
        background: SizedBox(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            semanticLabel: 'Delete',
          ),
        ),
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Please Confirm'),
                    content: Text(
                        'Are you sure you want to delete this item: $itemName'),
                    elevation: 10,
                    backgroundColor: kPrimaryColor,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text('Cancel')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text('Delete')),
                    ],
                  ));
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            String itemID = '$itemId';
            _dbRef
                .child(uuid)
                .child(OrderModel.getOrderId)
                .child(itemID)
                .remove()
                .whenComplete(() => MyInfoBar.success(
                    message: 'item deleted successfully',
                    icon: Icon(
                      Icons.delete,
                      size: 30.0,
                      color: Colors.redAccent,
                    ),
                    context: context));
            allData.removeAt(index);
          }
        },
        child: Card(
          margin: EdgeInsets.all(5.0),
          color: kHoverColor,
          shadowColor: kOrangeColor,
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Item Name:  $itemName',
                      style: customTextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Item Quantity:  $itemQuantity',
                      style: customTextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Item Unit:  $itemUnit',
                      style: customTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  showDataList() {
    _dbRef
        .child(uuid)
        .child(OrderModel.getOrderId)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        print(snapshot.value.toString());
      } else {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        allData.clear();

        for (var key in keys) {
          ItemModel d = new ItemModel(
            data[key]['itemID'],
            data[key]['itemName'],
            data[key]['itemQuantity'],
            data[key]['itemUnit'],
          );
          allData.add(d);
        }
      }
      setState(() {
        //
      });
    });
  }

  @override
  void dispose() {
    _textQntController.dispose();
    _nameController.dispose();
    netSubscription.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return allData == null
              ? ''
              : AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text(
                    'Do you want to leave without placing order or save as draft !',
                    style: customTextStyle,
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    ElevatedButton(
                      child: Text('YES'),
                      onPressed: () {
                        if (uuid == null) {
                          Navigator.of(context).pop(true);
                        } else {
                          String orderId = OrderModel.getOrderId;
                          _dbRef.child(uuid).child(orderId).remove();
                          Navigator.of(context).pop(true);
                        }
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
        });
  }
}
