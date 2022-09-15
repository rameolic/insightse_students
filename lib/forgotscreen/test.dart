import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_zoom/forgotscreen/otp_verification.dart';
import '../sign_in/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_zoom/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../Contsants.dart';
import 'package:flushbar/flushbar.dart';

class Changepassword extends StatefulWidget {
  final String restid;
  Changepassword(this.restid);

  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Changepassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  dynamic otp;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Change Password",
         style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.yellow, Colors.yellow[600]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection(),
                ],
              ),
      ),
    );
  }

  signIn(String password, repassword) async {
    if (password == repassword) {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final msg = jsonEncode(<String, dynamic>{
        "reset_pwd_uid": widget.restid,
        "reset_pwd": password,
        "reset_confirm_password": repassword
      });
      // ignore: avoid_init_to_null
      var jsonResponse = null;
      var response = await http.post(
          Uri.parse(finalurl+"user/reset_password"),
          headers: headers,
          body: msg);
      try {
        if (response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          print(jsonResponse);
          setState(() {
            _isLoading = false;
          });
          //  sharedPreferences.setString("token", jsonResponse['token']);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignIn()));
        } else if (response.statusCode == 404) {
          _showSnackBar("Password did not match!!!",context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Changepassword(widget.restid)));
        } else {
          setState(() {
            _isLoading = false;
          });
          print(response.body);
        }
      } catch (e) {
        _showSnackBar("Password did not match",context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Changepassword(widget.restid)));
      }
    } else {
      Text("Password did not match",style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ));
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: emailController.text == "" || passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                  showDialog();
                });
                signIn(emailController.text, passwordController.text);
              },
        child: Container(
          color: Colors.blue,
          child: Text("Change Password",
              style: TextStyle(color: Colors.white70, fontSize: 18.0)),
        ),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style:GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
            decoration: InputDecoration(
              icon: Icon(Icons.person_pin, color: Colors.white),
              hintText: "Enter Your new password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            //keyboardType: TextInputType.number,
            controller: passwordController,
            cursorColor: Colors.white,
            // obscureText: true,
            style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              icon: Icon(Icons.verified_user, color: Colors.white),
              hintText: "Re enter  password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      //margin: EdgeInsets.only(top: 5.0),
      //  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(120.0),
            child: Image.asset(
              "assets/forgot2.gif",
              height: 200.0,
            ),
          ),
          Shimmer.fromColors(
              baseColor: Colors.pink,
              highlightColor: Colors.indigo,
              child: Text(
                "Reset Your Password",
                style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
              )),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.redAccent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "*Your Password Must Have Length of 11\n*Your Password Must Start with A-Z\n*Your Password Must Contain '@' \n*Your Password Must Contain digits 0-9",
                              style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDialog() {
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
            height: 200,
            width: 200,
            child: SizedBox.expand(
                child: Image.asset(
              'assets/okay.gif',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            )),
            margin: EdgeInsets.only(bottom: 50, left: 4, right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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

  void _showSnackBar(String title,context){
    Flushbar(
      message: title,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )
      ..show(context);
  }

  ///put here
}
