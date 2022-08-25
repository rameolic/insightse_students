import 'dart:async';
//import 'package:Insightse/sign_in/sign_in.dart';
import 'package:flutter/material.dart';

import '../loginScren.dart';


//import 'sign_in/sign_in.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              'assets/splashlogo.gif',
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.width * 0.85,
              // color: Colors.yellow[600],
            ),
           
            
          ],
        ),
      ),
    );
  }
}


