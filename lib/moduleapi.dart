import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import '../Contsants.dart';
import 'dart:convert';

class showmodule {
  bool LMS,
      ONLINE_CLASSES,
      ONLINE_EXAMS,
      HOMEWORK,
      NOTES,
      CIRCULARS,
      CALENDER,
      Carrer_test,
      Schoolinfo,
      info,
      Gallery,
      Resources,
      Social,
      Fee_management,
  messenger,
      transportation,
      cafeteria,
      Report_card;
  showmodule(
      {this.LMS,
      this.ONLINE_CLASSES,
      this.ONLINE_EXAMS,
      this.HOMEWORK,
      this.NOTES,
      this.CIRCULARS,
      this.CALENDER,
      this.Carrer_test,
      this.Schoolinfo,
      this.info,
      this.Gallery,
      this.Resources,
      this.Social,
      this.Fee_management,
        this.messenger,
        this.cafeteria,
        this.transportation,
      this.Report_card});
}

showmodule module;
Future<bool> getmodules() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };

  print("calendarevents : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "school/display_student/${Logindata.orgid}"),
      headers: headers,
      body: []);
  print("calendar data : ${response.body}");
  if (response.statusCode == 200) {
    bool lms;
    bool onlineclass;
    bool onlineexam;
    bool homework;
    bool notes, circulars, calendar, careertest, schoolinfo,info,gallery,resource,social,fee,report,messenger,transportation,cafeteria;
    var decodeddata = jsonDecode(response.body);
    if(decodeddata['data'].toString() != "No Data available"){
      for (int i = 0; i < decodeddata['data'].length; i++) {
        if (decodeddata['data'][i]['module_name'] == 'lms') {
          lms = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'online class') {
          onlineclass =
              decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'online exam') {
          onlineexam = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'homework') {
          homework = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'notes') {
          notes = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'circulars') {
          circulars = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'calendar') {
          calendar = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'career test') {
          careertest = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'school info') {
          schoolinfo = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'info') {
          info = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'gallery') {
          gallery = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'resource') {
          resource = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'social') {
          social = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'fee management') {
          fee = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'report card') {
          report = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        } else if (decodeddata['data'][i]['module_name'] == 'messenger') {
          messenger = decodeddata['data'][i]['is_check'] == "1" ? true : false;
        }else if (decodeddata['data'][i]['module_name'] == 'transportation') {
          transportation = decodeddata['data'][i]['is_check'].toString() == "1" ? true : false;
        }else if (decodeddata['data'][i]['module_name'] == 'cafeteria') {
          cafeteria = decodeddata['data'][i]['is_check'].toString() == "1" ? true : false;
        }
      }
      print("here");
      module = showmodule(
        LMS: lms,
        ONLINE_CLASSES: onlineclass,
        ONLINE_EXAMS: onlineexam,
        HOMEWORK: homework,
        NOTES: notes,
        CIRCULARS: circulars,
        CALENDER: calendar,
        Carrer_test: careertest,
        Schoolinfo: schoolinfo,
        info: info,
        Gallery: gallery,
        Resources: resource,
        Social: social,
        Fee_management: fee,
        Report_card: report,
        messenger: messenger,
          transportation: transportation,
          cafeteria: cafeteria
      );
    }else{
      module = showmodule(
        LMS: true,
        ONLINE_CLASSES: true,
        ONLINE_EXAMS: true,
        HOMEWORK: true,
        NOTES: true,
        CIRCULARS: true,
        CALENDER: true,
        Carrer_test: true,
        Schoolinfo: true,
        info: true,
        Gallery: true,
        Resources: true,
        Social: true,
        Fee_management: true,
        Report_card: true,
        messenger: true,
          transportation: true,
        cafeteria: true
      );
    }
    print(module);
    return true;
  } else {
   // var decodeddata = jsonDecode(response.body);
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
