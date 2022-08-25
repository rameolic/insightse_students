import 'dart:convert';
import 'dart:ui';
import '../eventcalendar/calendarapi.dart';
import '../Contsants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../forgotpassword/ui.dart';
import '../moduleapi.dart';
import '../forgotpassword/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../forgotscreen/forgotstart.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_zoom/main.dart';
//import 'package:flutter_zoom/api%20user%20details/Profile.dart';
//import 'package:flutter_zoom/forgotscreen.dart';
//import 'package:flutter_zoom/screens/profile_screen.dart';
import 'package:device_info/device_info.dart';
//import 'package:test12/userpost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import '../effects/effects.dart';

import 'dart:io';

import '../Contsants.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'teddy_controller.dart';
import 'tracking_text_input.dart';

import 'package:http/http.dart' as http;
import 'wave.dart';
import '../newdashboardui.dart';

final forgotpasswordui = new ValueNotifier(false);
final progress = new ValueNotifier(0);
final forgotpassword = new ValueNotifier(false);
String forget_mobile;
String forget_username;
class SignIn extends StatefulWidget {
  void checklogin(){
    _SignInState().check_if_already_login();
  }
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var deviceidsss;
  TeddyController _teddyController;
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isObscured = true;
  List test;
  final username12 = TextEditingController();
  final pasword12 = TextEditingController();
  SharedPreferences logindata;
  bool newuser;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
// ignore: unused_field
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  @override
  void initState() {
    progress.value = 0;
 //   check_if_already_login();
    _teddyController = TeddyController();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print("user status");
    print(newuser);
    if (newuser == false) {
      await initial();
      await getmodules();
      getcalendarevents(inputbody);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NewDashbBard(currentIndex: 0)),
              (Route<dynamic> route) => false); //change here to home page
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username12.dispose();
    pasword12.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: ValueListenableBuilder<bool>(
          valueListenable: forgotpasswordui,
          builder: (context, value, child) {
            return
              forgotpasswordui.value ?
      ForgotPasswordui(
        username: forget_username,
        mobilenumber: forget_mobile,
        userid: forgetpassword_userid,
        otp: otp,
      ):
            SafeArea(
              child:
              Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 290,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topCenter,
                              colors: [
                                secondarycolor,
                                Colors.white,
                                //style.Style.lowerGradientColor,
                              ],
                            ),
                          ),
                          // BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(40.0),
                          // ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  // Center(
                                  //     child: Image.asset(
                                  //       "assets/choice_logo.png",
                                  //       height: 25,
                                  //     )),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),
                                  Center(
                                    child: Image.asset(
                                      "assets/InsightsELogo.png",
                                      width: MediaQuery.of(context).size.width/3,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  ValueListenableBuilder<bool>(
                                      valueListenable: forgotpassword,
                                      builder: (context, value, child) {
                                        return AnimatedCrossFade(
                                            firstChild: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                TrackingTextInput(
                                                  onTextChanged: (String email) {
                                                    _email = email;
                                                  },
                                                  label: "Username",
                                                  // onCaretMoved: (Offset caret) {
                                                  //   _teddyController
                                                  //       .lookAt(caret);
                                                  // },
                                                  icon: Icons.person,
                                                  enable: !_isLoading,
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: TrackingTextInput(
                                                        label: "Password",
                                                        isObscured: _isObscured,
                                                        // onCaretMoved:
                                                        //     (Offset caret) {
                                                        //   _teddyController
                                                        //       .coverEyes(
                                                        //           caret != null);
                                                        //   _teddyController
                                                        //       .lookAt(null);
                                                        // },
                                                        onTextChanged:
                                                            (String password) {
                                                          _password = password;
                                                        },
                                                        icon: Icons.lock,
                                                        enable: !_isLoading,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _isObscured =
                                                              !_isObscured;
                                                        });
                                                      },
                                                      child: Icon(
                                                          _isObscured
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: Colors.black45),
                                                    ),
                                                  ],
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      forgotpassword.value = true;
                                                    },
                                                    child: Text(
                                                      "Forgot Password ?",
                                                      style: TextStyle(
                                                          color: secondarycolor,
                                                          fontSize: 12),
                                                    )),
                                              ],
                                            ),
                                            secondChild: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                TrackingTextInput(
                                                  onTextChanged: (String email) {
                                                    _email = email;
                                                  },
                                                  label: "username",
                                                  onCaretMoved: (Offset caret) {
                                                    _teddyController.lookAt(caret);
                                                  },
                                                  icon: Icons.person,
                                                  enable: !_isLoading,
                                                ),
                                                TrackingTextInput(
                                                  label: "Mobile Number",
                                                  isObscured: false,
                                                  onCaretMoved: (Offset caret) {
                                                    _teddyController
                                                        .coverEyes(caret != null);
                                                    _teddyController.lookAt(null);
                                                  },
                                                  onTextChanged: (String password) {
                                                    _password = password;
                                                  },
                                                  icon: Icons.phone_iphone_rounded,
                                                  enable: !_isLoading,
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      forgotpassword.value = false;
                                                    },
                                                    child: Text(
                                                      "Login",
                                                      style: TextStyle(
                                                          color: secondarycolor,
                                                          fontSize: 12),
                                                    )),
                                              ],
                                            ),
                                            crossFadeState: forgotpassword.value
                                                ? CrossFadeState.showSecond
                                                : CrossFadeState.showFirst,
                                            duration:
                                                const Duration(milliseconds: 200));
                                      }),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 2),
                              child: ValueListenableBuilder<int>(
                                  valueListenable: progress,
                                  builder: (context, value, child) {
                                    return FloatingActionButton(
                                      onPressed: () async{
                                        if(forgotpassword.value == true){
                                          if (_email.isEmpty && _password.isEmpty) {
                                            _showSnackBar('Please Enter Valid Information');
                                          }else {
                                            progress.value = 1;
                                            if (await forogotpasswordapi(_email,_password,context)) {
                                              forget_mobile = _password;
                                              forget_username = _email;
                                              progress.value = 0;
                                              forgotpasswordui.value = true;
                                            }
                                            else{
                                              progress.value = 0;
                                            }
                                          }
                                        }else {
                                          onPressed1();
                                        }
                                      },
                                      tooltip: "Sign in",
                                      child: progress.value == 0
                                          ? Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color:
                                                  secondarycolor.withOpacity(0.5),
                                            )
                                          : progress.value == 1
                                              ? SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: CircularProgressIndicator(
                                                    color: secondarycolor,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                      backgroundColor: progress.value == 1
                                          ? Colors.white
                                          : progress.value == 2
                                              ? Colors.green
                                              : borderyellow,
                                    );
                                  })),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
  }),
    );
  }

  void onPressed1() async {
    if (_email.isEmpty && _password.isEmpty) {
      _showSnackBar('Please Enter Valid Information');
      //_teddyController.play('fail');
    } else {
      if (_isEmailValid(_email, _password)) {
        progress.value = 1;
        bool status = await _loginApi(username: _email, password: _password);
        if (status) {
          Playsound("Success.mp3");
          Future.delayed(Duration(milliseconds: 500), () async {
            progress.value = 2;
            SmallHapticFeedback(true);
            await initial();
            getcalendarevents(inputbody);
            getunreadcount();
            await getmodules();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NewDashbBard(currentIndex: 0)),
                (Route<dynamic> route) => false);
          });
        } else {
          progress.value = 0;
          SmallHapticFeedback(false);
        }
      } else {
        _teddyController.play('fail');
        SmallHapticFeedback(false);
        _showSnackBar('Please Enter Valid Details');
      }
    }
  }

  bool _isEmailValid(String email, String password) {
    Pattern pass = r'^(?=.{4,30}$)(?:[a-zA-Z\d]+(?:(?:\.|@|_)[a-zA-Z\d])*)+$';
    Pattern pattern = r'^(?=[a-zA-Z0-9._]{6,25}$)(?!.*[_.]{2})[^_.].*[^_.]$';
    RegExp regex = RegExp(pattern);
    RegExp ps = RegExp(pass);
    if (regex.hasMatch(email) && ps.hasMatch(password)) {
      return true;
    } else
      return false;
  }

  Future<bool> _loginApi(
      {@required String username, @required String password}) async {
    username = _email;
    password = _password;

    print("$username, $password");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    //String deviceid = await FirebaseMessaging.instance.getToken();
    final body = jsonEncode(<String, String>{
      "username": username,
      "password": password,
      "device_token": await FirebaseMessaging.instance.getToken()
    });
    print(body);
    logindata = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(finalurl + "users/student/login"),
      headers: headers,
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String userid = data["data"]["userid"].toString();
      String usernamedata = data["data"]["username"].toString();
      String masterid = data["data"]["master_id"].toString();
      String classid = data["data"]["curr_class_id"].toString();
      String batchid = data["data"]["batch_id"].toString();
      String date = data["data"]["curr_date"].toString();
      String orgid = data["data"]["org_id"].toString();
      String org_name = data["data"]["org_name"].toString();
      String profileimage = data["data"]["profile"].toString();
      String org_logo = data["data"]["org_logo"].toString();


      String parentid = data["data"]["login_uid"].toString();

      String fixedurl = data["data"]["url"].toString();
      sliders = [];
      String full_name = data["data"]["full_name"].toString();
      String deviceids = deviceidsss.toString();
      String user_token = data["data"]["user_token"].toString();
      print("parent id : $parentid");
      for (int i = 0; i < data['data']['sliders'].length; i++) {
        sliders.add(data['data']['sliders'][i]);
      }
      Logindata.userid = userid;
      Logindata.username = usernamedata;
      Logindata.password = password;
      Logindata.fullname = full_name;
      Logindata.image = profileimage;
      Logindata.orgid = orgid;
      Logindata.batchid = batchid;
      Logindata.parentid = parentid;
      Logindata.usertoken = user_token;
      Logindata.org_logo = org_logo;
      Logindata.master_id = masterid;
      Logindata.curr_class_id = classid;
      Logindata.fixedurl = fixedurl;
      logindata.setBool('login', false);
      logindata.setString('full_name', full_name);
      logindata.setString('username', usernamedata);
      logindata.setString('userid', userid);
      logindata.setString('master_id', masterid);
      logindata.setString('curr_class_id', classid);
      logindata.setString('batch_id', batchid);
      logindata.setString('curr_date', date);
      logindata.setString('org_id', orgid);
      logindata.setString('password', password);
      logindata.setString('deviceids', deviceids);
      logindata.setString('org_name', org_name);
      logindata.setString('profileimage', profileimage);
      logindata.setString('org_logo', org_logo);
      logindata.setString('fixedurl', fixedurl);
      logindata.setStringList("sliders", sliders);
      logindata.setString("parent_id", parentid);
      logindata.setString('user_token', user_token);
      _teddyController.play("success");
      return true;
    } else if (response.statusCode == 403) {
      final data = jsonDecode(response.body);
      String errormessage = data['msg'];
      _teddyController.play("fail");
      _showSnackBar(errormessage);
      return false;
    } else {
      _teddyController.play("fail");
      _showSnackBar("Please check the username");
      return false;
    }
  }

  void _showSnackBar(String title) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(title, textAlign: TextAlign.center),
        ),
      );
}

Future<bool> Logoutapi() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{"device_token": await GetId(),"user_id":Logindata.userid});
  final response = await http.post(
    Uri.parse(finalurl + "users/log_out"),
    headers: headers,
    body: body,
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
