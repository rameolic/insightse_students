
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import '../Contsants.dart';
import 'dart:convert';
String forgetpassword_userid;
String otp;
String reset_psswrd_uid;

Future<bool> forogotpasswordapi(username,mobile,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{"username": username,"mobile_number":mobile});
  print(jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "/user/forget_password"),
      body: body);
  print("forgot password : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    forgetpassword_userid = decodeddata['data']['userid'];
    otp = decodeddata['data']['otp'].toString();
    return true;
  } else {
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: decodeddata['msg'],
      icon: const Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    ).show(context);
    return false;
  }
}



Future<bool> resendotp(username,mobile,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{"username": username,"mobile_number":mobile});
  print(jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "/user/resend_otp"),
      body: body);
  print("forgot password : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    forgetpassword_userid = decodeddata['data']['userid'];
    otp = decodeddata['data']['otp'].toString();
    return true;
  } else {
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: decodeddata['msg'],
      icon: const Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    ).show(context);
    return false;
  }
}

Future<bool> verifyotp(uid,otp,mobile,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{ "uid": uid,"otp": (otp), "mobile_number":mobile});
  print(jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "/user/verify_otp"),
      body: body);
  print("forgot password : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    reset_psswrd_uid = decodeddata['data']['reset_pwd_uid'];
    return true;
  } else {
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: decodeddata['msg'],
      icon: const Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    ).show(context);
    return false;
  }
}

Future<bool> changepassword(psswrd,cnfrmpsswrd,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{ "reset_pwd_uid": reset_psswrd_uid,"reset_pwd": psswrd, "reset_confirm_password": cnfrmpsswrd});
  print(jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "/user/reset_password"),
      body: body);
  print("forgot password : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: decodeddata['msg'],
      icon: const Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    ).show(context);
    return true;
  } else {
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: decodeddata['msg'],
      icon: const Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    ).show(context);
    return false;
  }
}

