import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../Contsants.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';
import 'messagesui.dart';

//String messengerid = current_userid;
String attachmentsettings;
String lastdate;
class converstionlist {
  String fullname,
      department,
      designation,
      usertypecode,
      memberuid,
      gender,
      message,
      senderid,
      receiverid,
      time,
      readstatus,
      usertype,
      status,
      studentname,
      classname,
      fac_master_id,
      groupdesc,
      studentcheck,
      staffcheck,
      profilepic,
      parentcheck,
      division;
  bool canrespond;
  converstionlist(
      {this.readstatus,
      this.groupdesc,
      this.fac_master_id,
      this.staffcheck,
      this.parentcheck,
      this.studentcheck,
      this.profilepic,
      this.time,
      this.classname,
      this.department,
      this.designation,
      this.division,
      this.fullname,
      this.gender,
      this.memberuid,
      this.message,
      this.receiverid,
      this.senderid,
      this.status,
      this.studentname,
      this.usertype,
      this.usertypecode,
      this.canrespond
      });
}

List<converstionlist> conversations = [];
List<converstionlist> searchresults = [];
bool currentlycalling = false;
Future<bool> getconversations() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid,
    "stud_mid": Logindata.master_id,
    "iduser": current_userid,
    "search": ""
  });
  print(jsonEncode(body));
  if(!currentlycalling){
    currentlycalling = true;
    http.Response response = await http.post(
        Uri.parse(baseurl + "messenger/student_contact"),
        headers: headers,
        body: body);
    print("conversations: ${response.body} + ${response.statusCode}");
    if (response.statusCode == 200) {
      conversations = [];
      var decodeddata = jsonDecode(response.body);
      attachmentsettings = decodeddata['attachment_setting'].toString();
        for (int i = 0; i < decodeddata['data'].length; i++) {
          bool respondstatus;
          if(decodeddata['data'][i]['user_type'].toString() == "group"){
            if(Logindata.parentid.toString() != "null"){
              respondstatus = "${decodeddata['data'][i]['parent_check']}" == "1" ? true:false;
            }else{
              respondstatus = "${decodeddata['data'][i]['student_check']}" == "1" ? true:false;
            }
          }else{
            respondstatus = true;
          }
          String time;
          try{
            time =
                DateFormat("MMMMd").format(
                    DateTime.parse("${decodeddata['data'][i]['time']}")) +
                    " " +
                    DateFormat("h:mma").format(
                        DateTime.parse("${decodeddata['data'][i]['time']}"));
          }catch(e){
            time ="${decodeddata['data'][i]['time']}";
          }
          conversations.add(converstionlist(
              fullname: decodeddata['data'][i]['full_name'].toString(),
              department: decodeddata['data'][i]['department_name'].toString(),
              designation: decodeddata['data'][i]['designation'].toString(),
              usertypecode: decodeddata['data'][i]['user_type_code'].toString(),
              memberuid: decodeddata['data'][i]['member_uid'].toString(),
              gender: decodeddata['data'][i]['gender'].toString(),
              message: decodeddata['data'][i]['message'].toString(),
              senderid: decodeddata['data'][i]['sender_id'].toString(),
              receiverid: decodeddata['data'][i]['receiver_id'].toString(),
              time: time,
              readstatus: decodeddata['data'][i]['read_status'].toString(),
              usertype: decodeddata['data'][i]['user_type'].toString(),
              status: decodeddata['data'][i]['status'].toString(),
              studentname: decodeddata['data'][i]['student_name'].toString(),
              classname: decodeddata['data'][i]['class_name'].toString(),
              division: decodeddata['data'][i]['division_name'].toString(),
              profilepic: decodeddata['data'][i]['profile_pic'].toString(),
              canrespond: respondstatus
          ));
      }
      currentlycalling = false;
      return true;
    } else {
      conversations = [];
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
      currentlycalling = false;
      return false;
    }
  }
}

Future<bool> usesearch(keyword, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid,
    "stud_mid": Logindata.master_id,
    "iduser": current_userid,
    "search": keyword
  });

  print(body);
  http.Response response = await http.post(
      Uri.parse(baseurl + "messenger/student_contact"),
      headers: headers,
      body: body);
  print("search : ${response.body}");
  if (response.statusCode == 200) {
    searchresults=[];
    var decodeddata = jsonDecode(response.body);
    for (int i = 0; i < decodeddata['data'].length; i++) {
      bool respondstatus;
      if(decodeddata['data'][i]['user_type'].toString() == "group"){
        if(Logindata.parentid.toString() != "null"){
          respondstatus = "${decodeddata['data'][i]['parent_check']}" == "1" ? true:false;
        }else{
          respondstatus = "${decodeddata['data'][i]['student_check']}" == "1" ? true:false;
        }
      }else{
        respondstatus = true;
      }
      try{
        searchresults.add(converstionlist(
          fullname: decodeddata['data'][i]['full_name'].toString(),
          groupdesc: decodeddata['data'][i]['group_desc'].toString(),
          department: decodeddata['data'][i]['department_name'].toString(),
          designation: decodeddata['data'][i]['designation'].toString(),
          usertypecode: decodeddata['data'][i]['user_type_code'].toString(),
          memberuid: decodeddata['data'][i]['member_uid'].toString(),
          gender: decodeddata['data'][i]['gender'].toString(),
          message: decodeddata['data'][i]['message'].toString(),
          senderid: decodeddata['data'][i]['sender_id'].toString(),
          receiverid: decodeddata['data'][i]['receiver_id'].toString(),
          time:  DateFormat("MMMMd").format(
              DateTime.parse("${decodeddata['data'][i]['time']}")) +
              " " +
              DateFormat("h:mma").format(
                  DateTime.parse("${decodeddata['data'][i]['time']}")),
          readstatus: decodeddata['data'][i]['read_status'].toString(),
          usertype: decodeddata['data'][i]['user_type'].toString(),
          status: decodeddata['data'][i]['status'].toString(),
          studentname: decodeddata['data'][i]['student_name'].toString(),
          classname: decodeddata['data'][i]['class_name'].toString(),
          division: decodeddata['data'][i]['division_name'].toString(),
          studentcheck: decodeddata['data'][i]['student_check'].toString(),
          staffcheck: decodeddata['data'][i]['staff_check'].toString(),
          parentcheck: decodeddata['data'][i]['parent_check'].toString(),
          fac_master_id: decodeddata['data'][i]['fac_master_id'].toString(),
          profilepic: decodeddata['data'][i]['profile_pic'].toString(),
          canrespond: respondstatus
        ));
      }catch(e){
        print(e);
        searchresults.add(converstionlist(
            fullname: decodeddata['data'][i]['full_name'].toString(),
            groupdesc: decodeddata['data'][i]['group_desc'].toString(),
            department: decodeddata['data'][i]['department_name'].toString(),
            designation: decodeddata['data'][i]['designation'].toString(),
            usertypecode: decodeddata['data'][i]['user_type_code'].toString(),
            memberuid: decodeddata['data'][i]['member_uid'].toString(),
            gender: decodeddata['data'][i]['gender'].toString(),
            message: decodeddata['data'][i]['message'].toString(),
            senderid: decodeddata['data'][i]['sender_id'].toString(),
            receiverid: decodeddata['data'][i]['receiver_id'].toString(),
            time: decodeddata['data'][i]['time'],
            readstatus: decodeddata['data'][i]['read_status'].toString(),
            usertype: decodeddata['data'][i]['user_type'].toString(),
            status: decodeddata['data'][i]['status'].toString(),
            studentname: decodeddata['data'][i]['student_name'].toString(),
            classname: decodeddata['data'][i]['class_name'].toString(),
            division: decodeddata['data'][i]['division_name'].toString(),
            studentcheck: decodeddata['data'][i]['student_check'].toString(),
            staffcheck: decodeddata['data'][i]['staff_check'].toString(),
            parentcheck: decodeddata['data'][i]['parent_check'].toString(),
            fac_master_id: decodeddata['data'][i]['fac_master_id'].toString(),
            profilepic: decodeddata['data'][i]['profile_pic'].toString(),
            canrespond: respondstatus
        ));
      }
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

class message {
  String id,
      time,
      senderid,
      receiverid,
      messagecontent,
      sendername,
      readstatus;
  bool isdeleted;
  List<String> attachment;
  message(
      {this.time,
      this.senderid,
      this.receiverid,
      this.readstatus,
      this.id,
      this.attachment,
      this.messagecontent,
      this.sendername,
        this.isdeleted
      });
}
List<message>chatconversations=[];
bool currentusing = false;
Future<bool> getmessages(receiverid,skip, context) async {

  if(!currentusing){
    currentusing = !currentusing;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
    };
    final body = jsonEncode(<String, String>{
      "sender_id": current_userid,
      "receiver_id": receiverid,
      "skip": "$skip"
    });

    print(jsonEncode(body));
    http.Response response = await http.post(
        Uri.parse(baseurl + "messenger/getmessage"),
        headers: headers,
        body: body);
    print("search : ${response.body}");
    if (response.statusCode == 200) {
      chatconversations = [];
      var decodeddata = jsonDecode(response.body);
      for (int i = 0; i < decodeddata['data'].length; i++) {
        if (decodeddata['data'].length.toString() == "10") {
          showmore = true;
        } else {
          showmore = false;
        }
        String date;
        //     try{
        //       date = DateFormat.yMd().add_jm().format(DateTime.parse("${decodeddata['data'][i]['time']}"));
        // }catch(e){
        date = "${decodeddata['data'][i]['time']}";
        //  }
        if (decodeddata['data'][i]['message'].toString() != "null") {
          if(skipglobal==0 && decodeddata['data'][i]['message'].toString() != "null" && lastdate==null){
            lastdate = date;
            print("lastdate: "+lastdate);
          }
          chatconversations.add(message(
              id: decodeddata['data'][i]['_id']['\$oid'].toString(),
              time: date,
              senderid: decodeddata['data'][i]['sender_message_id'].toString(),
              receiverid:
                  decodeddata['data'][i]['receiver_message_id'].toString(),
              messagecontent: decodeddata['data'][i]['message'].toString(),
              attachment:
                  decodeddata['data'][i]['attachment'].toString().split("<,>"),
              sendername: decodeddata['data'][i]['sender_name'].toString(),
              isdeleted:
                  decodeddata['data'][i]['is_delete'] == 1 ? true : false,
              readstatus: decodeddata['data'][i]['read_status'].toString()));
        }
      }
      addmessages(chatconversations, context, false);
      currentusing = !currentusing;
      return true;
    } else {
      showmore = false;
      currentusing = !currentusing;
      return false;
    }
  }
}
Widget datawidget;
class data {
  static List<Row> messages;
}
bool showmore = true;


Future<bool> checksystem() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  http.Response response = await http.post(
      Uri.parse(baseurl + "messenger/check_system"),
      headers: headers);
  print("search : ${response.body}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deletemessages(String messageid) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>
  {
    "member_uid": current_userid,
    "object_id":"$messageid"
  }
  );
  print("delete body :$body");
  http.Response response = await http.post(
      Uri.parse(baseurl + "messenger/delete_message"),
      headers: headers,
      body: body);
  print("delete : ${response.body}");
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    return false;
  }
}