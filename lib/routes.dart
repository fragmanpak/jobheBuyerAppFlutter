import 'package:flutter/widgets.dart';
import 'package:jobheebuyer/screens/add_order/add_order.dart';
import 'package:jobheebuyer/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheebuyer/screens/details/details_screen.dart';
import 'package:jobheebuyer/screens/home/home_screen.dart';
import 'package:jobheebuyer/screens/otp/components/otp_verification.dart';
import 'package:jobheebuyer/screens/otp/otp_registration.dart';
import 'package:jobheebuyer/screens/splash/splash_screen.dart';



// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  OtpRegistration.routeName: (context) => OtpVerification(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpVerification.routeName: (context) => OtpVerification(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  //AddOrder.routeName: (context) => AddOrder(),
  //AddOrder.routeName: (context) => AddOrder(),
  //ProfileScreen.routeName: (context) => ProfileScreen(),
};
