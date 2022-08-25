import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';
String termandcondtions = "";
bool caneditfeee ;//= false;
List<String>feeid=[];
List<String>emiid=[];
double totalconcession=0.0;
double totalfine = 0.0;
class Feedata{
  String feeid;
  String emiid;
  String headername;
  String feedefinition;
  String applicableterm;
  String scheduledate;
  String duedate;
  String paymentstatus;
  String scholarship;
  String fine;
  String totalamount;
  Feedata(
      {
        this.duedate,
        this.feeid,
        this.emiid,
        this.headername,
        this.scheduledate,
        this.paymentstatus,
        this.feedefinition,
        this.applicableterm,
        this.totalamount,
        this.fine,
        this.scholarship
      });
}
class Fee{
  String timeline;
  List<Feedata>timelinedata=[];
  Fee({
    this.timeline,
    this.timelinedata,
});
}
List<Fee>feesdata=[];
class feehistorydata{
  String scheduledstartdate;
  String headername;
  String feedefinition;
  String timeline;
  String fine;
  String paid;
  String fee;
  String receipt;
  String transactiondate;
  String paymentmode;
  feehistorydata(
      {
        this.transactiondate,
        this.fine,
        this.paymentmode,
        this.scheduledstartdate,
        this.timeline,
        this.feedefinition,
        this.fee,
        this.headername,
        this.paid,
        this.receipt
      });
}
List<feehistorydata>feehistory=[];
double totalpayableamount;

Map testbody = {
  "code": 200,
  "status": "success",
  "data": [
    {
      "timeline": "Term 1",
      "data": [
        {
          "emi_id": "338",
          "emi_no": "2",
          "fees_id": "59",
          "header_name": "Tution Fee - Term1 Installment 2",
          "fees_definition": "Term 1 Fee",
          "applicable_term": "",
          "schedule_date": "04-09-2022",
          "due_date": "03-10-2022",
          "payment_status": "Upcoming",
          "scholarship": "0.00",
          "fine": "0.00",
          "total_amount": "2,500.00"
        },
        {
          "emi_id": "339",
          "emi_no": "3",
          "fees_id": "59",
          "header_name": "Tution Fee - Term1 Installment 3",
          "fees_definition": "Term 1 Fee",
          "applicable_term": "",
          "schedule_date": "04-10-2022",
          "due_date": "03-11-2022",
          "payment_status": "Upcoming",
          "scholarship": "0.00",
          "fine": "0.00",
          "total_amount": "2,500.00"
        },
        {
          "emi_id": "340",
          "emi_no": "4",
          "fees_id": "59",
          "header_name": "Tution Fee - Term1 Installment 4",
          "fees_definition": "Term 1 Fee",
          "applicable_term": "",
          "schedule_date": "04-11-2022",
          "due_date": "03-01-2024",
          "payment_status": "Upcoming",
          "scholarship": "0.00",
          "fine": "0.00",
          "total_amount": "2,500.00"
        }
      ]
    }
  ],
  "view_terms_conditions": "https://test.insightse.com/terms-and-conditions",
  "total_fees_count": 2,
  "fee_partial_payment_status": "0"
};

List<Feedata>timelinedataloop=[];
Future<bool> getpayablefee(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid,
    "stud_mid": Logindata.master_id,
  };
  print("exams : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/fee/payment/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response: ${response.body}");
  if (response.statusCode == 200) {
     totalconcession=0.0;
     totalfine = 0.0;
    totalpayableamount=0.0;
    feeidforpayment="";
     emiidforpayment ="";
    var decodeddata = jsonDecode(response.body);
   // jsonDecode(jsonEncode(testbody));
    print("decoded mowa : $decodeddata");
    feesdata=[];
     try{
         for (int i = 0; i < decodeddata['data'].length; i++) {
           var timelinedata = decodeddata['data'][i]['data'];
           timelinedataloop = [];
           for (int u = 0; u < timelinedata.length; u++) {
             totalconcession =
                 totalconcession + double.parse(
                     timelinedata[u]['scholarship'].toString().replaceAll(
                         ",", ""));

             totalfine = totalfine + double.parse(
                 timelinedata[u]['fine'].toString().replaceAll(",", ""));
             timelinedataloop.add(Feedata(
               feeid: timelinedata[u]['fees_id'].toString(),
                 emiid: timelinedata[u]['emi_id'].toString() ,
                 headername: timelinedata[u]['header_name'].toString() ,//!= "null" ? decodeddata['data'][i]['timeline'].toString():timelinedata[u]['header_name'].toString(),
               feedefinition: timelinedata[u]['fees_definition'].toString(),
               applicableterm: timelinedata[u]['applicable_term'].toString() ==
                   ""
                   ? "0"
                   : timelinedata[u]['applicable_term'].toString(),
               scheduledate: timelinedata[u]['schedule_date'].toString(),
               duedate: timelinedata[u]['due_date'].toString(),
               paymentstatus: timelinedata[u]['payment_status'].toString(),
               scholarship: timelinedata[u]['scholarship'].toString()
                   .toString()
                   .replaceAll(",", ""),
               fine: timelinedata[u]['fine'].toString().toString().replaceAll(
                   ",", ""),
               totalamount: timelinedata[u]['total_amount']
                   .toString()
                   .toString()
                   .replaceAll(",", ""),
             ));
             if (timelinedata[u]['payment_status'].toString() != "Upcoming") {
               if (feeidforpayment=="") {
                 feeidforpayment = timelinedata[u]['fees_id'].toString();
                 emiidforpayment = timelinedata[u]['emi_id'].toString();
               } else {
                 feeidforpayment = feeidforpayment + "-${timelinedata[u]['fees_id'].toString()}";
                 emiidforpayment = emiidforpayment + "-${timelinedata[u]['emi_id'].toString()}";
               }


               totalpayableamount = totalpayableamount + ((double.parse(
                   timelinedata[u]['total_amount'].toString()
                       .toString()
                       .replaceAll(",", "")) + double.parse(
                   timelinedata[u]['fine'].toString().toString().replaceAll(
                       ",", "")) - double.parse(
                   timelinedata[u]['scholarship'].toString()
                       .toString()
                       .replaceAll(",", ""))));
             }
           }
           feesdata.add(Fee(
               timeline: decodeddata['data'][i]['timeline'],
               timelinedata: timelinedataloop));
         }
     }catch(e){
       print("error : $e");
     }
    termandcondtions = decodeddata['view_terms_conditions'].toString();
     caneditfeee = decodeddata['fee_partial_payment_status'] == "1" ? true : false;
      return true;
    }else{
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: _parseHtmlString(decodeddata['msg']),
      icon: Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration:
      Duration(seconds: 4),
      leftBarIndicatorColor:
      secondarycolor,
    )..show(context);
    return false;
  }
}


Future<bool> getpaymenthistory(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  print("token : "+'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}');
  Map inputbody = {
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid,
    "stud_mid": Logindata.master_id,
  };
  print("exams : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/fee/payment/history"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response: ${response.body}");
  if (jsonDecode(response.body)['code'].toString() == "200") {
    print("in");
    var decodeddata = jsonDecode(response.body);
    feehistory=[];
    for(int i=0; i<decodeddata['data'].length;i++){
      feehistory.add(
          feehistorydata(
            scheduledstartdate: decodeddata['data'][i]['scheduled_start_date'],
            headername: decodeddata['data'][i]['header_name'],
            feedefinition: decodeddata['data'][i]['fees_definition'],
            timeline: decodeddata['data'][i]['timeline'],
            receipt: decodeddata['data'][i]['receipt_download_link'],
            transactiondate: decodeddata['data'][i]['transaction_date'],
            paid: decodeddata['data'][i]['paid'],
            fee: decodeddata['data'][i]['fee'],
            fine: decodeddata['data'][i]['fine'],
            paymentmode: decodeddata['data'][i]['payment_mode'],

          )
      );
    }
    print("fee history: ${feehistory.length}");
    return true;
  }else{
    feehistory=[];
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: _parseHtmlString(decodeddata['msg']),
      icon: Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration:
      Duration(seconds: 4),
      leftBarIndicatorColor:
      secondarycolor,
    )..show(context);
    return false;
  }
}

Future<bool> getdetails(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid,
    "stud_mid": Logindata.master_id,
  };
  print("exams : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/fee/payment/details"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response: ${response.body}");
  if (jsonDecode(response.body)['code'].toString() == "200") {
    print("in");
    var decodeddata = jsonDecode(response.body);
    feedetailsdata = feedashboard(
      totalApplicablefee: double.parse(decodeddata['data']['total_applicable_fee'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      totalfee: double.parse(decodeddata['data']['total_fee'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      totalpaid: double.parse(decodeddata['data']['total_paid'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      totalpayable: double.parse(decodeddata['data']['currently_payable'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      finetilldate:double.parse(decodeddata['data']['total_fine'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      payablefee: double.parse(decodeddata['data']['currently_payable_fee'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      payablefine: double.parse(decodeddata['data']['currently_payable_fine'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      scholarshipcurrently: double.parse(decodeddata['data']['currently_payable_scholarship'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp('-'),'')),
      totalscholarship:double.parse(decodeddata['data']['total_scholarship'].toString().replaceAll(RegExp(','), '').replaceAll(RegExp(','), '').replaceAll(RegExp('-'),''))
    );
    return true;
  }else{
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: _parseHtmlString(decodeddata['msg']),
      icon: Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration:
      Duration(seconds: 4),
      leftBarIndicatorColor:
      secondarycolor,
    )..show(context);
    return false;
  }
}
feedashboard feedetailsdata;
class feedashboard{
  double totalfee;
  double totalApplicablefee;
  double finetilldate;
  double totalpaid;
  double payablefee;
  double payablefine;
  double totalpayable;
  double totalscholarship;
  double scholarshipcurrently;

  feedashboard({
    this.totalpaid,
    this.finetilldate,
    this.payablefee,
    this.payablefine,
    this.totalApplicablefee,this.totalfee,this.totalpayable,this.scholarshipcurrently,this.totalscholarship
});
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : $parsedString");
  return parsedString;
}

class payabledata{
  String amount;
  String feeid;
  String concession;
  String fine;
  var emis;
  payabledata({
    this.fine,
    this.amount,
    this.concession,
    this.feeid,
    this.emis
});
}
Future<bool> getpaymenturl( payabledata data,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  print("token : "+'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}');
  Map inputbody = {
      "org_id":Logindata.orgid,
      "curr_batch":Logindata.batchid,
      "stud_master_id":Logindata.master_id,
      "total_payable":data.amount,
      "fee_id":data.feeid,
    "emi_id":0,
      "concession":data.concession,
      "fine":data.fine
  };
  print("get payment url : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/fees/payment/request"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response: ${response.body}");
  if (jsonDecode(response.body)['code'].toString() == "200") {
    var decodeddata = jsonDecode(response.body);
    paymenturl = Logindata.fixedurl+ "${decodeddata['data']}";
    print("url : $paymenturl");
    return true;
  }else{
    paymenturl="";
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: _parseHtmlString(decodeddata['msg']),
      icon: Icon(
        Icons.info_outline,
        size: 20.0,
        color: secondarycolor,
      ),
      duration:
      Duration(seconds: 4),
      leftBarIndicatorColor:
      secondarycolor,
    )..show(context);
    return false;
  }
}
String paymenturl="";
String feeidforpayment = "";
String emiidforpayment = "";