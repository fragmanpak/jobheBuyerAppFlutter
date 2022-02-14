import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheebuyer/components/new_snake_bar.dart';
import 'package:jobheebuyer/models/seller_model.dart';
import 'package:jobheebuyer/screens/home/home_screen.dart';
import 'package:jobheebuyer/services/services.dart';
import 'package:jobheebuyer/user_register/user_registration.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OtpVerification extends StatefulWidget {
  static String routeName = "/otp";

  final String phone;
  final String codeDigits;

  OtpVerification({this.phone, this.codeDigits});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOtpCodController = TextEditingController();
  final FocusNode _pinOtpCodeFocus = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode;
  DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.reference().child(kJob).child(kBuyer);
  BoxDecoration pinOtpCodeDecoration = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey));
  bool _status = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    verifyPhoneNumber();
  }

  @override
  void dispose() {
    _pinOtpCodController.dispose();
    _pinOtpCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset("assets/images/wireless headset.png",
                  width: getProportionateScreenWidth(300),
                  height: getProportionateScreenHeight(265)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
              ),
            ),
            Text("We sent your code to ${widget.codeDigits}-${widget.phone}"),
            buildTimer(),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: PinPut(
                fieldsCount: 6,
                textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinOtpCodeFocus,
                controller: _pinOtpCodController,
                selectedFieldDecoration: pinOtpCodeDecoration,
                submittedFieldDecoration: pinOtpCodeDecoration,
                followingFieldDecoration: pinOtpCodeDecoration,
                pinAnimationType: PinAnimationType.rotation,
                onSubmit: (pin) async {
                  var check = await InternetConnectionChecker().hasConnection;
                  if (check == true) {
                    pd.show(
                        max: 100,
                        msg: 'Please wait...',
                        barrierDismissible: false);
                    try {
                      await _auth
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode, smsCode: pin))
                          .then(
                        (value) async {
                          if (value.user != null) {
                            String uuid = value.user.uid;
                            try {
                              await _firebaseDatabase
                                  .child(uuid)
                                  .once()
                                  .then((event) async {
                                final data =
                                    new Map<String, dynamic>.from(event.value);
                                final result = Seller.fromJson(data);
                                if (result.fcm != null) {
                                  var token = await FirebaseMessaging.instance
                                      .getToken();
                                  print(token);
                                  if (result.fcm.trim() == token.trim()) {
                                    print('tokens are same');
                                    pd.close();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (c) => HomeScreen()));
                                  } else {
                                    var rst =
                                        await MyDatabaseService.saveDeviceToken(
                                            token);
                                    print("New Token " + rst.toString());
                                    if (rst == false) {
                                      pd.close();
                                      MySnakeBar.createSnackBar(Colors.red,
                                          "No Internet Connections", context);
                                    } else {
                                      pd.close();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (c) => HomeScreen()));
                                    }
                                  }
                                } else {
                                  pd.close();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) => UserRegisterScreen()));
                                }
                              });
                            } catch (e) {
                              pd.close();
                              print(e);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => UserRegisterScreen()));
                            }
                          }
                        },
                      );
                    } catch (e) {
                      pd.close();
                      FocusScope.of(context).unfocus();
                      MySnakeBar.createSnackBar(
                          Colors.red, 'Invalid OTP', context);
                    }
                  } else {
                    pd.close();
                    MySnakeBar.createSnackBar(
                        Colors.red, 'No Internet Connection', context);
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            GestureDetector(
              onTap: () {
                if (_status == true) {
                  MySnakeBar.createSnackBar(
                      Colors.greenAccent,
                      'We send the new code to ${widget.codeDigits}-${widget.phone}',
                      context);
                  verifyPhoneNumber();
                  buildTimer();
                }
              },
              child: _status == false
                  ? Text(
                      "Resend OTP Code",
                      style: TextStyle(
                          color: Colors.black12,
                          decoration: TextDecoration.underline),
                    )
                  : Text(
                      "Resend OTP Code",
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
            tween: Tween(begin: 30.0, end: 0.0),
            duration: Duration(seconds: 30),
            builder: (_, dynamic value, child) {
              return Text(
                "00:${value.toInt()}",
                style: TextStyle(color: kPrimaryColor),
              );
            }),
      ],
    );
  }

  // 321457748
  void verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "${widget.codeDigits + widget.phone}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            // ANDROID ONLY!
            // Sign the user in (or link) with the auto-generated credential
            await _auth.signInWithCredential(credential);
            print("verification complete");
          },
          verificationFailed: (FirebaseAuthException e) async {
            if (e.code == 'invalid-phone-number') {
              MySnakeBar.createSnackBar(Colors.red,
                  'The provided phone number is not valid.', context);
              print('The provided phone number is not valid.');
            }
            var check = await InternetConnectionChecker().hasConnection;
            if (check == false)
              MySnakeBar.createSnackBar(
                  Colors.red, 'No Internet Connections.', context);
          },
          codeSent: (String vId, int resendCode) async {
            MySnakeBar.createSnackBar(Colors.white54, 'code sent', context);
            if (!mounted) return;
            setState(() {
              verificationCode = vId;
              print("code sent " + verificationCode);
            });
          },
          codeAutoRetrievalTimeout: (String vId) {
            if (!mounted) return;

            setState(() {
              _status = true;
              // verificationCode = vId;
            });
            print("otp Time out");
          },
          timeout: Duration(seconds: 30));
    } catch (e) {
      print(e);
    }
  }
}
