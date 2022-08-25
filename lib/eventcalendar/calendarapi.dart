// ignore_for_file: camel_case_types
import 'calendarui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import '../Contsants.dart';
import 'dart:convert';

class calendarevents{
  String id,title,start,end,color,type;
  calendarevents({
    this.color,
    this.end,
    this.id,
    this.start,
    this.title,
    this.type,
  });
}

List<calendarevents>events=[];
List<String>eventtypes=[];
Future<bool> getcalendarevents(inputbody) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };

  print("calendarevents : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "teacher/academic_calendar"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("calendar data : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    events=[];
    eventtypes = ["All"];
    for(int i=0;i<decodeddata['data'].length;i++){
      events.add(
          calendarevents(
              color:decodeddata['data'][i]['color'],
              id: decodeddata['data'][i]['id'],
              title: decodeddata['data'][i]['title'],
              start: decodeddata['data'][i]['start'],
              end:decodeddata['data'][i]['end'],
              type: decodeddata['data'][i]['type']
          )
      );
    }
    return true;
  } else {
    var decodeddata = jsonDecode(response.body);
    // Flushbar(
    //   message: decodeddata['msg'],
    //   icon: const Icon(
    //     Icons.info_outline,
    //     size: 20.0,
    //     color: secondarycolor,
    //   ),
    //   duration: const Duration(seconds: 4),
    //   leftBarIndicatorColor: secondarycolor,
    // ).show(context);
    return false;
  }
}