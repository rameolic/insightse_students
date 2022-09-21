// ignore_for_file: missing_return

import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
class newitems{
  String circularscount;
  String reportcardcount;
  newitems({this.circularscount,this.reportcardcount});
}
newitems newdata;
Future<bool>getunreadtitles() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Authorization": "Bearer ${Logindata.usertoken}_ie_" + "${Logindata.userid}",
  };
  final msg = jsonEncode(<String, dynamic>{
    "org_id":Logindata.orgid,
    "user_id":current_userid,
    "stud_mid":Logindata.master_id
  });
  print(msg);
  var response = await http.post(Uri.parse(finalurl + "tiles_count"),
      headers: headers, body: msg);
  print(response.body);
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    newdata=newitems(
      circularscount: decodeddata['circular_count'],
      reportcardcount:decodeddata['report_count']
    );
    return true;
  }else{
    return false;
  }
}

Future<bool>markcircular(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Authorization": "Bearer ${Logindata.usertoken}_ie_" + "${Logindata.userid}",
  };
  final msg = jsonEncode(<String, dynamic>{
    "org_id":Logindata.orgid,
    "user_id":current_userid,
    "circular_id":id
  });
  print(msg);
  var response = await http.post(Uri.parse(finalurl + "notices/read"),
      headers: headers, body: msg);
  print(response.body);
  if (response.statusCode == 200) {
    return true;
  }else{
    return false;
  }
}
Future<bool>markreportcard(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Authorization": "Bearer ${Logindata.usertoken}_ie_" + "${Logindata.userid}",
  };
  final msg = jsonEncode(<String, dynamic>{
    "org_id":Logindata.orgid,
    "stud_mid":Logindata.master_id,
    "rc_id":id
  });
  print(msg);
  var response = await http.post(Uri.parse(finalurl + "reports/read"),
      headers: headers, body: msg);
  print(response.body);
  if (response.statusCode == 200) {
    return true;
  }else{
    return false;
  }
}