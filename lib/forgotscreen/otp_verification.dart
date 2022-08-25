import 'dart:convert';
import '../forgotscreen/test.dart';
import '../sign_in/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:otp_screen/otp_screen.dart';

import '../Contsants.dart';

// ignore: must_be_immutable
class Review extends StatelessWidget {
  final String phone, user;
  var pass;
  Review({this.pass, this.phone, this.user});
  var restid;
  // ignore: missing_return
  Future<String> validateOtp(String otp) async {
    await Future.delayed(Duration(milliseconds: 2000));
    // print(pass);
    if (otp == pass) {
      print("testing started");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final msg = jsonEncode(
          <String, dynamic>{"uid": user, "otp": pass, "mobile_number": phone});
      var jsonResponse;
      var response = await http.post(
          Uri.parse(finalurl+"user/verify_otp"),
          headers: headers,
          body: msg);
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
        restid = jsonResponse["data"]["reset_pwd_uid"];
        print("Reset Id is $restid");
        return null;
      } else if (response.statusCode == 404) {
        BuildContext context;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      }
    } else {
      return "The entered Otp is wrong";
    }
  }

  void moveToNextScreen(context) {
    showDialog(context);
    //String id, classid, batchid, date, orgid;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Changepassword(restid)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // debugShowCheckedModeBanner: false,
      // builder: (context, child) => ,

      body: OtpScreen.withGradientBackground(
        topColor: Colors.orangeAccent,
        bottomColor: Colors.yellow[600],
        otpLength: 4,
        validateOtp: validateOtp,
        routeCallback: moveToNextScreen,
        themeColor: Colors.white,
        titleColor: Colors.white,
        title: "Phone Number Verification",
        subTitle: "Enter the code sent to \n +91-$phone",
        icon: Image.asset(
          'assets/otp-icon.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void showDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            child: SizedBox.expand(child: Image.asset('assets/pop.gif')),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
