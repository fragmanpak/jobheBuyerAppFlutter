import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobheebuyer/components/custom_list_tile.dart';
import 'package:jobheebuyer/models/current_seller.dart';
import 'package:jobheebuyer/models/order_status.dart';
import 'package:jobheebuyer/models/searc_stream_publisher.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/utils/image_assets.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../constants.dart';

class CurrentOrder extends StatefulWidget {
  final String uid;

  CurrentOrder({Key key, this.uid}) : super(key: key);
  final _dataBase = FirebaseDatabase.instance.reference().child(kJob);

  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  String uuidSeller;
  String sellerName;
  String sellerPic;
  String sellerOnline;
  String buyerName;
  String buyerPic;
  String buyerOnline;
  String orderId;
  TextEditingController titleMessageController = new TextEditingController();
  TextEditingController descriptionMessageController =
      new TextEditingController();
  TextEditingController buttonMessageController = new TextEditingController();
  bool _status = false;

  @override
  void initState() {
    super.initState();
    descriptionMessageController.addListener(() {
      //_printMessages();
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
    return StreamBuilder(
        stream: SearchStreamPublisher().getBuyerOrdersStream(widget.uid),
        builder: (context, snapshot) {
          final data = snapshot.data as List<OrdersStatusModel>;
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("this Buyer data =" + data.toString());
            if (!snapshot.hasData) {
              return Center(
                child: Text("No current orders yet"),
              );
            } else {}
          } else {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data == null
              ? Text("No Current Orders yet")
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    OrdersStatusModel ordersStatusData =
                        snapshot.data.elementAt(index);
                    Future<void>.delayed(const Duration(seconds: 10));
                    return Column(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        StreamBuilder(
                            initialData: CircularProgressIndicator(),
                            stream: CurrentSeller()
                                .getCurrentSeller(ordersStatusData.sellerId),
                            builder: (context, snap) {
                              Seller yoSeller = snap.data;
                              if (snap.hasData) {
                                pd.close();
                                return CustomListItem(
                                  user: ordersStatusData.titleMessage,
                                  viewCount: ordersStatusData.time,
                                  thumbnail: Column(
                                    children: [
                                      CircleAvatar(
                                          radius: 30,
                                          backgroundImage: yoSeller.picUrl !=
                                                  null
                                              ? NetworkImage(yoSeller.picUrl)
                                              : AssetImage(
                                                  ImagesAsset.profileImage)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(yoSeller.onlineStatus),
                                    ],
                                  ),
                                  title: yoSeller.name,
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                      ],
                    );
                  });
        });
  }
}
