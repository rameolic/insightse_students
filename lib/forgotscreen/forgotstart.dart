import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../forgotscreen/otp_verification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:http/http.dart' as http;

import '../Contsants.dart';

import '../sign_in/wave.dart';
class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  dynamic userid, otp;
  @override
   Widget build(BuildContext context) {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
  //       .copyWith(statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return
      Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back, // add custom icons also
          ),
        ),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
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

  signIn(String username, phone) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final msg = jsonEncode(
        <String, dynamic>{"username": username, "mobile_number": phone});
    var jsonResponse;
    var response = await http.post(
        Uri.parse(finalurl+"user/forget_password"),
        headers: headers,
        body: msg);
    try {
      if (response.statusCode == 200) {
        try {
          jsonResponse = json.decode(response.body);
          print(jsonResponse);
          otp = jsonResponse["data"]["otp"].toString();
          userid = jsonResponse["data"]["userid"];

          setState(() {
            _isLoading = false;
          });
          print(jsonResponse);
          //  sharedPreferences.setString("token", jsonResponse['token']);
          try {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Review(
                          phone: phone,
                          pass: otp,
                          user: userid,
                        )));
            showDialog();
          } catch (e) {
            _showSnackBar("Network Erorr Occured !!!!!!!");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Forgotpassword()));
          }

          if (response.statusCode == 404) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Forgotpassword()));
          }
        } catch (e) {
          _showSnackBar("Network Erorr");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Forgotpassword()));
          // print(e);
        }
      }
    } catch (e) {
      _showSnackBar("Network Erorr");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Forgotpassword()));
      print(e);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                signIn(emailController.text, passwordController.text);
              },
        elevation: 0.0,
        color: Colors.lightBlue,
        child: Text("Send Otp",
            style: TextStyle(color: Colors.white70, fontSize: 15.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
            decoration: InputDecoration(
              icon: Icon(Icons.account_box, color: Colors.white),
              hintText: "Enter Registered username",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  )
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: passwordController,
            cursorColor: Colors.white,
            // obscureText: true,
           style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
            decoration: InputDecoration(
              icon: Icon(Icons.phone_android, color: Colors.white),
              hintText: "Enter Registered phone",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 18.0,
                    color: Colors.black,
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
            //borderRadius: BorderRadius.circular(80.0),
            child: Image.asset(
              "assets/1234.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.80,
            ),
          )
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
            height: 300,
            child: SizedBox.expand(child: Image.asset('assets/pop1.gif')),
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
// ignore: deprecated_member_use
  void _showSnackBar(String title) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(title, textAlign: TextAlign.center),
        ),
      );
}
