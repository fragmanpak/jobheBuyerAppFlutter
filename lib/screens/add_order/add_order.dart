import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheebuyer/components/top_snake_bar.dart';
import 'package:jobheebuyer/helper/order_model.dart';
import 'package:jobheebuyer/models/items_model.dart';
import 'package:jobheebuyer/screens/find_seller/seller_find_screen.dart';

import '../../constants.dart';

class AddOrder extends StatefulWidget {
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

  @override
  void initState() {
    String orderId = _dbRef.push().key;
    OrderModel.setOrderId(orderId);
    super.initState();

    showDataList();
    netSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      if (hasInternet == true) {
        //  this.uuid=currentUser();
      }
    });
  }

  currentUser() {
    //final User user = FirebaseAuth.instance.currentUser;
    //final uid = user.uid.toString();
    return 'kyLErlq5pmMFhSSuLucuj4izpIG3';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Order Details'),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.greenAccent,
            centerTitle: true,
            title: SizedBox(
              // height: SizeConfig.screenHeight * 0.60,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: false,
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
                          autofocus: false,
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
                      ],
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
                            items: <String>['kg', 'ml', 'meter', 'other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Text(value, style: customTextStyle),
                                ),
                              );
                            }).toList(),
                          ),
                        )),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {
                        hasInternet =
                            await InternetConnectionChecker().hasConnection;
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
                          uuid = currentUser();
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
                                  message: 'Item add to cart successfully',
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
            floating: true,
            toolbarHeight: 360,
          ),
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) {
                return cardUI(
                    index,
                    allData[index].itemId,
                    allData[index].itemName,
                    allData[index].itemQuantity,
                    allData[index].itemUnit);
              },
              // Builds 1000 ListTiles
              childCount: allData.length,
            ),
          ),
        ]),
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
    );
  }

  @override
  void dispose() {
    _textQntController.dispose();
    _nameController.dispose();
    netSubscription.cancel();
    super.dispose();
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
}
