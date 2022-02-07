import 'package:flutter/material.dart';
import 'package:jobheebuyer/models/card_model.dart';
import 'package:jobheebuyer/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'navigation_drawer.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      drawer: NavigationDrawer(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ChangeNotifierProvider<CardModel>(
                create: (_) => CardModel(),
                child: Consumer<CardModel>(
                  builder: (context, model, child) {
                    if (model.seller != null) {
                      return Expanded(
                        flex: 1,
                        child: ListView(
                          children: [
                            ...model.seller.map(
                              (seller) => Card(
                                shadowColor: kPrimaryColor,
                                elevation: 10,
                                child: Expanded(
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
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
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
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
