import 'package:flutter/material.dart';
import 'package:insightse_students/ProgressHUD.dart';
import 'switchaccountsdata.dart';
import '../sign_in/sign_in.dart';
import '../Contsants.dart';
import '../eventcalendar/calendarapi.dart';
import '../moduleapi.dart';
import 'dart:async';
import '../effects/effects.dart';
import '../newdashboardui.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';

class SwitchAccounts extends StatefulWidget {
  @override
  State<SwitchAccounts> createState() => _SwitchAccountsState();
}

class _SwitchAccountsState extends State<SwitchAccounts> {
  bool deletemode = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    print(Loggedinaccounts);
    return WillPopScope(
      onWillPop: () async => false,
      child: ProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Who's Using?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: grey.withOpacity(0.4),
                                  fontSize: 20,
                                )),
                          ),
                          // Row(
                          //   children: [
                          //     Container(height: 10,width: 10,color: primarycolor,),
                          //     SizedBox(width: 10,),
                          //     Text("Student",style: TextStyle(color: Colors.black54),)
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     Container(height: 10,width: 10,color: secondarycolor,),
                          //     SizedBox(width: 10,),
                          //     Text("Parent",style: TextStyle(color: Colors.black54),)
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deletemode = !deletemode;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(deletemode ? "Done" : "Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black87)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                // crossAxisCount:3,
                                // shrinkWrap: true,
                                //physics: NeverScrollableScrollPhysics(),
                                children: List.generate(
                                  Loggedinaccounts.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        print(Logindata.username);
                                        if (!deletemode) {
                                          if (Logindata.username.toString() !=
                                              Loggedinaccounts[index]
                                                  .username
                                                  .toString()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            bool status =
                                                await _switchaccountApi(
                                                    username:
                                                        Loggedinaccounts[index]
                                                            .username,
                                                    password:
                                                        Loggedinaccounts[index]
                                                            .password,
                                                    context: context);
                                            if (status) {
                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () async {
                                                current_userid =
                                                    "${Logindata.parentid}" ==
                                                            "null"
                                                        ? "${Logindata.userid}"
                                                        : "${Logindata.parentid}";
                                                SmallHapticFeedback(true);
                                                await initial();
                                                await getcalendarevents(
                                                    inputbody);
                                                await getunreadcount();
                                                await getmodules();
                                                setState(() {
                                                  loading = false;
                                                });
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewDashbBard(
                                                                currentIndex:
                                                                    0)),
                                                    (Route<dynamic> route) =>
                                                        false);
                                              });
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              SmallHapticFeedback(false);
                                            }
                                          } else {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewDashbBard(
                                                            currentIndex: 0)),
                                                (Route<dynamic> route) =>
                                                    false);
                                          }
                                        } else {
                                          Flushbar(
                                            message:
                                                "Edit mode was enabled, Disable edit mode inorder to proceed with switch accounts",
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 28.0,
                                              color: secondarycolor,
                                            ),
                                            duration: Duration(seconds: 4),
                                            leftBarIndicatorColor:
                                                secondarycolor,
                                          )..show(context);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // SizedBox(
                                          //   width: MediaQuery.of(context).size.width/4,
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(left: 10,right: 10,),
                                          //     child: Text(Loggedinaccounts[index].status,textAlign: TextAlign.center,maxLines: 3,style: TextStyle(fontSize: 14,color: Colors.black54),),
                                          //   ),
                                          // ),
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10,
                                                    bottom: 5),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                decoration: BoxDecoration(
                                                  //   color: borderyellow,
                                                  // border: Border.all(color: secondarycolor,width: 1.5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        Loggedinaccounts[index]
                                                            .image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                ),
                                              ),
                                              if (deletemode)
                                                GestureDetector(
                                                  onTap: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return ProgressHUD(
                                                                inAsyncCall:
                                                                    loading,
                                                                child:
                                                                    AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10.0))),
                                                                  content:
                                                                      Builder(
                                                                    builder:
                                                                        (context) {
                                                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                                      return Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            'Alert',
                                                                            style:
                                                                                TextStyle(color: secondarycolor, fontSize: 20),
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                Colors.black,
                                                                            thickness:
                                                                                0.8,
                                                                          ),
                                                                          Text(
                                                                            "Are you sure do want to remove the account, you need to add this account again if you want to switch with this account in future.",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  if (Loggedinaccounts.length > 1) {
                                                                                    setState(() {
                                                                                      loading = true;
                                                                                    });
                                                                                    await Logoutapi(Loggedinaccounts[index].userid);
                                                                                    Loggedinaccounts.removeAt(index);
                                                                                    loggedindata.removeAt(index);
                                                                                    SharedPreferences data = await SharedPreferences.getInstance();
                                                                                    data.setStringList('loggeddata', loggedindata);
                                                                                    setState(() {
                                                                                      loading = false;
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                  } else {
                                                                                    setState(() {
                                                                                      loading = true;
                                                                                    });
                                                                                    await Logoutapi(Loggedinaccounts[index].userid);
                                                                                    Loggedinaccounts = [];
                                                                                    loggedindata = [];
                                                                                    SharedPreferences data = await SharedPreferences.getInstance();
                                                                                    data.clear();
                                                                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()), (Route<dynamic> route) => false);
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  height: 30,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.red,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Center(child: Text('Logout', style: TextStyle(color: Colors.white))),
                                                                                ),
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  height: 30,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(
                                                                                    color: grey,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Center(child: Text('cancel', style: TextStyle(color: Colors.white))),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            }));
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10,
                                                          bottom: 5),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.6),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        "Logout",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )))
                                                  //Icon(Icons.remove_circle,color: Colors.red,size: 25,)
                                                  ,
                                                ),
                                            ],
                                          ),
                                          // SizedBox(height: 5,),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        Loggedinaccounts[index]
                                                            .fullname,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black54),
                                                      )),
                                                  SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        "Username : " +
                                                            Loggedinaccounts[
                                                                    index]
                                                                .username,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      )),
                                                  // SingleChildScrollView(
                                                  //     scrollDirection:
                                                  //     Axis.horizontal,
                                                  //     child: Text(
                                                  //       "userid : " +
                                                  //           Loggedinaccounts[
                                                  //           index].userid,
                                                  //       textAlign:
                                                  //       TextAlign.center,
                                                  //       maxLines: 3,
                                                  //       style: TextStyle(
                                                  //           fontSize: 12,
                                                  //           color:
                                                  //           Colors.black54),
                                                  //     )),
                                                  SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        "Class & Division : " +
                                                            Loggedinaccounts[
                                                                    index]
                                                                .classanddivision,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      )),
                                                  SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        "Account type : " +
                                                            Loggedinaccounts[
                                                                    index]
                                                                .status,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                addaccounttooltip = true;
                                await Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => SignIn()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 12, right: 12, top: 10),
                                decoration: BoxDecoration(
                                  color: grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 45,
                                child: Center(
                                    child: Text(
                                  "Add Account",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                    child: Column(
                      children: [
                        Text("Logged in as",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.withOpacity(0.7),
                                fontSize: 14)),
                        Text("${Logindata.fullname} (${Logindata.username})",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.withOpacity(0.7),
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String classname;
Future<bool> _switchaccountApi(
    {@required String username,
    @required String password,
    @required context}) async {
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
    classname = data["data"]["curr_class"].toString();
    String parentid = data["data"]["login_uid"].toString();
    String fixedurl = data["data"]["url"].toString();
    sliders = [];
    String full_name = data["data"]["full_name"].toString();
    String deviceids = await FirebaseMessaging.instance.getToken().toString();
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
    print(parentid);
    print("Add account page");
    Addaccounts(
        username,
        password,
        profileimage,
        "$parentid" == "null" ? "Student" : "Parent",
        true,
        full_name,
        classname,userid);
    return true;
  } else if (response.statusCode == 403) {
    final data = jsonDecode(response.body);
    String errormessage = data['msg'];
    Flushbar(
      message: "$errormessage",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )..show(context);
    return false;
  }
}
//"{\"org_id\":\"75\",\"batch_id\":\"136\",\"stud_mid\":\"53372\",\"iduser\":\"17183\",\"search\":\"\"}"
