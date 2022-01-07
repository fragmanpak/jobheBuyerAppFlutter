import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            "Jobhee",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(25),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
          ),

          Image.asset(
            image,
            height: getProportionateScreenHeight(265),
            width: getProportionateScreenWidth(235),
          ),

        ],
      ),

    );
  }
}
