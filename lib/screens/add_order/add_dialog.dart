import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/components/top_snake_bar.dart';
import 'package:jobheebuyer/constants.dart';
import 'package:jobheebuyer/models/items_model.dart';
import 'package:jobheebuyer/size_config.dart';

class AddItemDialog extends StatefulWidget {
  final String uuid;
  final String orderId;
  final List<ItemModel> orderList;
  AddItemDialog({Key key, this.uuid, this.orderId, this.orderList}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  List<ItemModel> allData = [];

  DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child(kJob).child(kOrderOfBuyers);
  //StreamSubscription<DatabaseEvent> _dbRefSubscription;


  @override
  void initState() {
    super.initState();
    showDataList();
  }

  void showDataList() {
    _dbRef
        .child(widget.uuid)
        .child(widget.orderId)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.key == null) {
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
        setState(() {
          //
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialog(),
    );
  }

  Widget _buildDialog() =>
      SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              shape: BoxShape.rectangle),
          child: allData.length == 0
                ? Center(
                    child: Text(
                    'Please add some items',
                  ))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: allData.length,
                        itemBuilder: (_, index) {
                          return cardUI(
                              index,
                              allData[index].itemId,
                              allData[index].itemName,
                              allData[index].itemQuantity,
                              allData[index].itemUnit);
                        },
                      ),
                    )
                  ],
                ),
        ),
      );

  Widget cardUI(int index, String itemId, String itemName, String itemQuantity,
      String itemUnit) {
    return Dismissible(
        key: ValueKey(itemId),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.redAccent,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            semanticLabel: 'Delete',
          ),
          padding: EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
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
                .child(widget.uuid)
                .child(widget.orderId)
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
          margin: EdgeInsets.all(13.0),
          color: kHoverColor,
          shadowColor: kOrangeColor,
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'ItemName:  $itemName',
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
}
