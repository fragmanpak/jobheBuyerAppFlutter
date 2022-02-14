import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/components/new_snake_bar.dart';
import 'package:jobheebuyer/models/order_status.dart';
import 'package:jobheebuyer/models/searc_stream_publisher.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/services/services.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../constants.dart';

class CurrentOrder extends StatefulWidget {
  final String uuid;

  CurrentOrder({Key key, this.uuid}) : super(key: key);
  final _dataBase = FirebaseDatabase.instance.reference().child(kJob);

  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  String uuid;
  String sellerName;
  String sellerPic;
  String sellerOnline;
  String buyerName;
  String buyerPic;
  String buyerOnline;
  TextEditingController titleMessageController = new TextEditingController();
  TextEditingController descriptionMessageController =
      new TextEditingController();
  TextEditingController buttonMessageController = new TextEditingController();
  bool _status = false;

  @override
  void initState() {
    super.initState();
    descriptionMessageController.addListener(() {
      _printMessages();
    });
  }

  @override
  void didChangeDependencies() {
    //_loadResources();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    titleMessageController.dispose();
    descriptionMessageController.dispose();
    buttonMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);

    return Scaffold(
        body:
            //   StreamBuilder(
            // stream: SearchStreamPublisher().getSellerStream(),
            // builder: (BuildContext context, snapshot1) {
            //   if (snapshot1.connectionState == ConnectionState.waiting) {
            //     if (snapshot1.hasData) {
            //       final seller = snapshot1.data as List<Seller>;
            //       seller.map((event) {
            //         sellerName = event.name;
            //         sellerPic = event.picUrl;
            //         sellerOnline = event.onlineStatus;
            //         print(event.name);
            //       });
            //     }
            //   }
            StreamBuilder(
      stream: SearchStreamPublisher().getBuyerOrdersStream(widget.uuid),
      builder: (context, snapshot) {
        final listTile = <ListTile>[];

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (snapshot.hasData) {
            final data = snapshot.data as List<OrdersStatusModel>;
            listTile.addAll(
              data.map((orderStatus) {
                print(orderStatus.titleMessage);
                titleMessageController.text = orderStatus.titleMessage;
                descriptionMessageController.text = "";
                return ListTile(
                    contentPadding: EdgeInsets.all(8.30),
                    leading: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: sellerPic != null
                              ? NetworkImage(sellerPic)
                              : Center(
                                  child: pd.show(
                                    max: 100,
                                    msg: 'Please wait....',
                                    barrierDismissible: false,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(sellerOnline),
                      ],
                    ),
                    title: Column(
                      children: [
                        Text(sellerName),
                        TextField(
                          controller: titleMessageController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: titleMessageController.text,
                          ),
                          onChanged: (value) {
                            switch (value) {
                              case ORDER_STATUS_MSG_NEW_ORDER:
                                descriptionMessageController.text =
                                    ORDER_DESCRIPTION_STATUS;
                                break;
                              case ORDER_STATUS_MSG_PRICE_ENTERED:
                                break;
                              case ORDER_STATUS_MSG_PRICE_ACCEPTED:
                                break;
                              case ORDER_STATUS_MSG_LOCATION_GRANTED:
                                break;
                              case ORDER_STATUS_DELIVERY_STARTED:
                                break;
                            }
                          },
                        ),
                        Container(
                          child: _status == false
                              ? Text(descriptionMessageController.text)
                              : ElevatedButton(
                                  onPressed: () {
                                    switch (titleMessageController.text) {
                                      case ORDER_STATUS_MSG_NEW_ORDER:
                                        _status = true;

                                        break;
                                      case ORDER_STATUS_MSG_PRICE_ENTERED:
                                        break;
                                      case ORDER_STATUS_MSG_PRICE_ACCEPTED:
                                        break;
                                      case ORDER_STATUS_MSG_LOCATION_GRANTED:
                                        break;
                                      case ORDER_STATUS_DELIVERY_STARTED:
                                        break;
                                    }
                                  },
                                  child: Text(""),
                                ),
                        ),
                        Text(orderStatus.time)
                      ],
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              Tooltip(
                                message: 'Chat',
                              );
                            },
                            icon: Icon(Icons.message)),
                        IconButton(
                            onPressed: () {
                              Tooltip(
                                message: 'Check items prices.',
                              );
                            },
                            icon: Icon(Icons.list_alt)),
                        IconButton(
                            onPressed: () {
                              Tooltip(
                                message: 'Cancel Order',
                              );
                            },
                            icon: Icon(Icons.cancel)),
                      ],
                    ));
              }),
            );
          }
          return ListView(
            children: listTile,
          );
        }
        return Center(child: Text("No current Orders yet"));
      },
    ));
    //return Center(child: Text("No current orders yet."));
    //  },
    // ));
  }

  void _loadResources() async {
    uuid = await MyDatabaseService.getCurrentUser();
    print(uuid);
  }

  void _printMessages() {}
}
// final sellerStream = SearchStreamPublisher().getSellerStream();
// sellerSubscription = sellerStream.listen(
//   (event) {
//     event.map((e) {
//       sellerName = e.name;
//       sellerPic = e.picUrl;
//       sellerOnline = e.onlineStatus;
//     });
//   },
//   onError: (error) {
//     print(error);
//   },
//   cancelOnError: false,
// );
