import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import '../Contsants.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class notifications{
  String id,member_id,title,template_content,readstatus,historystatus,time;
  notifications({
    this.title,this.historystatus,this.id,this.member_id,this.readstatus,this.template_content,this.time
});
}
List<notifications>notificationlist=[];
Future<bool> notificationsapi(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{"user_id":current_userid});
  print(jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "/push-notification/history"),
      headers: headers,
      body: body);
  print("forgot password : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    notificationlist=[];
    for(int i =0; i <decodeddata['data'].length;i++) {
      notificationlist.add(notifications(
        id: decodeddata['data'][i]['notification_id'],
        member_id: decodeddata['data'][i]['member_uid'],
        title: decodeddata['data'][i]['title'],
        template_content: decodeddata['data'][i]['template_content'],
        readstatus: decodeddata['data'][i]['read_status'],
        historystatus: decodeddata['data'][i]['history_status'],
        time : gettime(DateTime.parse(decodeddata['data'][i]['time'].toString()))
      ));
    }
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

gettime(DateTime date){
  var toDayDate = DateTime.now();
  var different;
  different = toDayDate.difference(date).inDays;
  if(int.parse(different.toString()) < 1){
    different = toDayDate.difference(date).inHours;
    if(int.parse(different.toString()) < 1){
      different = toDayDate.difference(date).inMinutes;
      return different.toString() == '1' ?"about ${different.toString()} minute ago" : "about ${different.toString()} minutes ago";
    }else{
      return different.toString() == '1' ?"about ${different.toString()} hour ago" : "about ${different.toString()} hours ago";
    }
  }else{
    return different.toString() == '1' ?"about ${different.toString()} day ago" : "about ${different.toString()} days ago";
  }

}

Future<bool> markreadstatus(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{"user_id":current_userid});
  print(jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "push-notification/status/update"),
      headers: headers,
      body: body);
  print("forgot password : ${response.body}");
  if (response.statusCode == 200) {
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