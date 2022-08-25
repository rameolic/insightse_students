import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:io';

bool newtest = true;


class Careertest {
  String quizid;
  String title;
  int totalquestion;
  int timelimit;
  String testnumber;
  String status;
  String remainingtime;
  int answeredques;
  Careertest(
      {this.quizid,
      this.status,
      this.testnumber,
      this.timelimit,
      this.title,
      this.remainingtime,
      this.totalquestion,
      this.answeredques});
}

List<Careertest> testlist = [];
Future<bool> Careerlist(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {"student_id": Logindata.master_id};
  print("careerlist : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/career_test"),
      headers: headers,
      body: jsonEncode(inputbody));
  var decodeddata = jsonDecode(response.body);
  print(decodeddata);
  if (response.statusCode == 200) {
    testlist = [];
    try {
      for (int i = 0; i < decodeddata['data'].length; i++) {
        int duration;
        try {
          duration =
              decodeddata['data'][i]['answered_ques'] != 0 && decodeddata['data'][i]['remaining_time'].toString() != "null" ?
              int.parse(decodeddata['data'][i]['remaining_time'].toString().replaceAll(" Minutes", ""))
              : int.parse(decodeddata['data'][i]['time_limit'].toString().replaceAll(" Minutes", "")
              );
        } catch (e) {
          print(e);
          duration = 0;
        }
        //if(decodeddata['data'][i]['answered_ques'] != 0)
        testlist.add(Careertest(
          quizid: decodeddata['data'][i]['quiz_id'],
          status: decodeddata['data'][i]['status'],
          testnumber: decodeddata['data'][i]['test_number'],
          timelimit: duration,
          title: decodeddata['data'][i]['title'],
          totalquestion: int.parse(decodeddata['data'][i]['total_question']),
          remainingtime: decodeddata['data'][i]['remaining_time'],
          answeredques: decodeddata['data'][i]['answered_ques'],
        ));
      }
    } catch (e) {
      Flushbar(
        message: "Error${response.statusCode} : ${decodeddata['msg']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )..show(context);
    }
    return true;
  }
}

class Option {
  String id;
  String name;
  String optiondata;
  String image;
  Option({this.id, this.name, this.image, this.optiondata});
}

class CareerQuestion {
  String serialnumber;
  String id;
  String title;
  String selectedoption;
  String question;
  List<Option> options;
  CareerQuestion({
    this.title,
    this.id,
    this.options,
    this.selectedoption,
    this.serialnumber,
    this.question
  });
}

class CareerQuestionverbalreas {
  String serialnumber;
  String id;
  String title;
  String selectedoption;
  List<Option> options1;
  List<Option> options2;
  CareerQuestionverbalreas({
    this.title,
    this.id,
    this.options1,
    this.selectedoption,
    this.serialnumber,
    this.options2
  });
}

int questionnumber = 1;
List<CareerQuestion> questions = [];
List<CareerQuestionverbalreas> questionsforverbalreas = [];
Future<bool> getquestionsforverbalreasoning(id, testnumber, context) async {
  print("getquestionsforverbalreasoning api called");
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "quiz_id": id,
    "test_number": testnumber,
    "stud_master_id": Logindata.master_id
  };
  print("careerlist questions : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/career_test/question/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  var decodeddata = jsonDecode(response.body);
  print(decodeddata);
  if (response.statusCode == 200) {
    print("careerlist questions : ${response.body}");
    questions = [];
    for (int i = 0; i < decodeddata['data'].length; i++) {
      List<Option> data1 = [];
      List<Option> data2 = [];
      for (int u = 2; u < 10; u++) {
        if(u<6){
          print( "id: ${decodeddata['data'][i]['option']["$u"]['option_id']}");
          data1.add(Option(
            id: decodeddata['data'][i]['option']["$u"]['option_id'].toString(),
            image: "",
            optiondata:
                decodeddata['data'][i]['option']["$u"]['options'].toString(),
            name: decodeddata['data'][i]['option']["$u"]['option_name'].toString(),
          ));
        }else if(u>5){
          data2.add(Option(
            id: decodeddata['data'][i]['option']["$u"]['option_id'].toString(),
            image: "",
            optiondata:
            decodeddata['data'][i]['option']["$u"]['options'].toString(),
            name: decodeddata['data'][i]['option']["$u"]['option_name'].toString(),
          ));
        }
      }
      questionsforverbalreas.add(CareerQuestionverbalreas(
          serialnumber: decodeddata['data'][i]['serial_number'],
          id: decodeddata['data'][i]['question_id'],
          title: decodeddata['data'][i]['question_title'],
          selectedoption: decodeddata['data'][i]['selected_option'],
          options1: data1,
        options2: data2
      ));
    }
    return true;
  }
}

Future<bool> getworkingmemoryquestions(id, testnumber, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "quiz_id": id,
    "test_number": testnumber,
    "stud_master_id": Logindata.master_id
  };
  print("careerlist questions : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/career_test/question/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  var decodeddata = jsonDecode(response.body);
  print(decodeddata);
  if (response.statusCode == 200) {
    print("careerlist questions : ${response.body}");
    questions = [];
    for (int i = 0; i < decodeddata['data'].length; i++) {
      questions.add(CareerQuestion(
          serialnumber: decodeddata['data'][i]['serial_number'],
          id: decodeddata['data'][i]['question_id'],
          title: decodeddata['data'][i]['question_title'],
          selectedoption: decodeddata['data'][i]['selected_option'],
        question: decodeddata['data'][i]['question']
          ));
    }
    return true;
  }
}

Future<bool> getquestions(id, testnumber, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "quiz_id": id,
    "test_number": testnumber,
    "stud_master_id": Logindata.master_id
  };
  print("careerlist questions : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/career_test/question/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  var decodeddata = jsonDecode(response.body);
  print(decodeddata);
  if (response.statusCode == 200) {
    print("careerlist questions : ${response.body}");
    questions = [];
    for (int i = 0; i < decodeddata['data'].length; i++) {
      List<Option> data = [];
      for (int u = 0; u < decodeddata['data'][i]['option'].length; u++) {
        data.add(Option(
          id: decodeddata['data'][i]['option'][u]['option_id'].toString(),
          image: "",
          optiondata: decodeddata['data'][i]['option'][u]['options'].toString(),
          name: decodeddata['data'][i]['option'][u]['option_name'].toString(),
        ));
      }
      questions.add(CareerQuestion(
          serialnumber: decodeddata['data'][i]['serial_number'],
          id: decodeddata['data'][i]['question_id'],
          title: decodeddata['data'][i]['question_title'],
          selectedoption: decodeddata['data'][i]['selected_option'],
          options: data));
    }
    return true;
  }
}

Future<bool> getquestionsforVisualAttention(id, testnumber, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "quiz_id": id,
    "test_number": testnumber,
    "stud_master_id": Logindata.master_id
  };
  print("careerlist questions : $inputbody");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/career_test/question/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  var decodeddata = jsonDecode(response.body);
  print(decodeddata);
  if (response.statusCode == 200) {
    print("careerlist questions : ${response.body}");
    questions = [];
    for (int i = 0; i < decodeddata['data'].length; i++) {
      List<Option> data = [];
      for (int u = 0; u < decodeddata['data'][i]['options'].length; u++) {
        data.add(Option(
          image: decodeddata['data'][i]['options'][u]['img_id'].toString(),
          optiondata: decodeddata['data'][i]['options'][u]['options'].toString(),
        ));
      }
      questions.add(CareerQuestion(
          serialnumber: decodeddata['data'][i]['serial_number'],
          id: decodeddata['data'][i]['question_id'],
          title: decodeddata['data'][i]['question_title'],
          selectedoption: decodeddata['data'][i]['selected_option'],
          options: data));
    }
    return true;
  }
}


class Saveanswer {
  String quizid;
  String testnumber;
  String serialnumber;
  String questionid;
  var answer;
  String time;
  Saveanswer(
      {this.testnumber,
      this.quizid,
      this.serialnumber,
      this.answer,
      this.questionid,
      @required this.time});
}

Future<bool> savecareeranswer(Saveanswer data, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "stud_master_id": Logindata.master_id,
    "quiz_id": data.quizid,
    "testnumber": data.testnumber,
    "serial_number": data.serialnumber,
    "question_id": data.questionid,
    "ans": data.answer,
    "remaining_time": data.time
  };
  print("save : ${jsonEncode(inputbody)}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/career_test/question/save_answer"),
      headers: headers,
      body: jsonEncode(inputbody));
  if (response.statusCode == 200) {
    print("answer response : ${response.body}");
    return true;
  } else {
    Flushbar(
      message:
          "Error while contacting server status code : ${response.statusCode}",
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
