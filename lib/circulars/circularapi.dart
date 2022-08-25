import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';

class Circulardata {
  String id;
  String noticetitle;
  String circularno;
  String noticedate;
  String description;
  String memberuid;
  String filepath;
  String fileext;
  Circulardata(
      {this.id,
      this.circularno,
      this.description,
      this.fileext,
      this.filepath,
      this.memberuid,
      this.noticedate,
      this.noticetitle});
}
List<String>titlelist=[];
List<Circulardata>circulars=[];

 Future<bool>getcirculars(startdate, enddate, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "from_date": startdate == "null"?"":startdate,
    "to_date": enddate == "null" ? "" : enddate
  };
  print("token : "+'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}');
  print("circulars input : $inputbody");
  http.Response response = await http.post(Uri.parse(
      Logindata.parentid == "null"?baseurl + "notices/student/${Logindata.userid}/notice/list"
          :
      baseurl + "notices/student/${Logindata.parentid}/notice/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("url : ${baseurl + "notices/student/${Logindata.parentid}/notice/list"}");
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    if (decodeddata['data'].toString() == ""){
      circulars=[];
      titlelist=[];
      Flushbar(
        message: decodeddata['msg'],
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )..show(context);
      return false;
    } else {
      var data = decodeddata['data'];
      circulars=[];
      titlelist=[];
      for(int i=0;i<data.length;i++){
        circulars.add(
            Circulardata(
              id:data[i]['id'],
              noticetitle:data[i]['notice_title'] ,
              circularno: data[i]['circular_no'],
              noticedate: data[i]['notice_date'],
              description: data[i]['description'],
              memberuid: data[i]['member_uid'],
              filepath: data[i]['file_path'],
              fileext: data[i]['file_ext'],
            )
        );
        titlelist.add(data[i]['notice_title']);
      }
      return true;
    }
  }
}
