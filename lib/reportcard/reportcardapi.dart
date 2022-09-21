import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';

class reportcard{
  String cardname;
  String attachment;
  String publishedat;
  bool readstatus;
  String id;
  reportcard({
    this.id,
    this.attachment,
    this.cardname,
    this.readstatus,
    this.publishedat
});
}

List<reportcard>cards=[];

String link;

Future<bool>getreport(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid
  };
  print(baseurl + "reportcards/academic/student/${Logindata.master_id}/published/list");
  http.Response response = await http.post(
      Uri.parse(baseurl + "reportcards/academic/student/${Logindata.master_id}/published/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    cards=[];
    var decodeddata = jsonDecode(response.body);
    try{
      for(int i=0;i<decodeddata['data'].length;i++){
        cards.add(
            reportcard(
              id: decodeddata['data'][i]['rc_id'],
              cardname: decodeddata['data'][i]['rc_name'],
              attachment: decodeddata['data'][i]['rc_attachment'],
              publishedat: decodeddata['data'][i]['published_at'],
              readstatus: decodeddata['data'][i]['read_status'].toString() == "1"?true:false,
            )
        );
      }
    }catch(e){
      link="";
      Flushbar(
        message: "${decodeddata['data']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )
        ..show(context);
      return false;
    }
  }else{
    link = "";
    Flushbar(
      message: "ERROR while connecting server Status code : ${response.statusCode}",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )
      ..show(context);
  }
  return false;
}
