import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../Onlineexams/exampage.dart';

Future<bool> starthomework(date,homeworkid, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "from_date":date,
    "homework_id": homeworkid,
    "user_id": Logindata.userid,
  };
  print("homework : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/homework/start"),
      headers: headers,
      body: jsonEncode(inputbody));

  print("response : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    if (decodeddata['msg'] != null) {
      Flushbar(
        message: decodeddata['msg'],
        duration: Duration(seconds: 3),
        //backgroundColor: secondarycolor,
      )..show(context);
      return false;
    } else {
      var questionsdata = decodeddata['data']['homework_questions_info'];
      homeworkquestiondata = [];
      totalmarks = 0;
      for (int i = 0; i < questionsdata.length; i++) {
        List<HWQuestionOptions> options=[];
        if(questionsdata[i]['question_type']=="1"){
          for(int u =0;u<questionsdata[i]['options'].length;u++){
            options.add(HWQuestionOptions(
              option: questionsdata[i]['options'][u]['option'],
              opt_image: questionsdata[i]['options'][u]['opt_image'],
              option_id: questionsdata[i]['options'][u]['option_id'],
              option_image_url: questionsdata[i]['options'][u]['option_image_url'],
              text_status: questionsdata[i]['options'][u]['text_status'] ,
            ));
          }
        }
        homeworkquestiondata.add(homeworkquestionsinfo(
          question_id: questionsdata[i]['question_id'],
          question: questionsdata[i]['question'],
          questiontype: questionsdata[i]['question_type'],
          negative_mark: questionsdata[i]['negative_marks'],
          marks: questionsdata[i]['marks'],
          image: questionsdata[i]['image'],
          optionsdata: options,
          question_file_url: questionsdata[i]['question_file_url'],
        ));
        totalmarks = totalmarks + int.parse(questionsdata[i]['marks']);
      }
      currenthomeworkinfo = HomeworkInfo(
          exam: decodeddata['data']['homework']['title'],
          classandsubject:
          "${decodeddata['data']['selected_class']} & ${decodeddata['data']['subj_info'][0]['sub_name']}",
          showresult: decodeddata['data']['homework']['show_instant_results'],
          studnthomeworkid: decodeddata['data']['stud_homework_id'].toString(),
          totalmarks: totalmarks,
          id: decodeddata['data']['homework']['homework_id'],
          subid: decodeddata['data']['homework']['subj_id']);
      return true;
    }
  }
}

int totalmarks;
HomeworkInfo currenthomeworkinfo;
class HomeworkInfo {
  String classandsubject;
  int totalmarks;
  int duration;
  String exam;
  String id = "";
  String subid = "";
  String studnthomeworkid = "";
  String showresult = "";
  HomeworkInfo(
      {this.showresult,
        this.studnthomeworkid,
        this.totalmarks,
        this.subid,
        this.id,
        this.exam,
        this.classandsubject,
        this.duration});
}
class homeworkanswer {
  String answer = '';
  String examid = "";
  String subid = "";
  String totalmarks = "";
  String studntexamid = "";
  String questionid = "";
  String questiontype = "";
  String marks = "";
  String negaivemarks = "";
  String showresult = "";
  List<File> filepaths = [];
  homeworkanswer(
      {
        this.answer,
        this.marks,
        this.questiontype,
        this.examid,
        this.negaivemarks,
        this.questionid,
        this.showresult,
        this.studntexamid,
        this.subid,
        this.totalmarks,
        this.filepaths
      });
}
List<homeworkanswer> hwanswersdata = [];
List<homeworkquestionsinfo> homeworkquestiondata = [];

class homeworkquestionsinfo {
  String question_id = '';
  String question = '';
  String questiontype = '';
  String negative_mark = '';
  String marks = '';
  String image = '';
  String question_file_url = '';
  String answer = '';
  List<HWQuestionOptions> optionsdata = [];

  homeworkquestionsinfo(
      {this.answer,
        this.image,
        this.marks,
        this.negative_mark,
        this.question,
        this.question_file_url,
        this.question_id,
        this.optionsdata,
        this.questiontype});
}

class HWQuestionOptions {
  String option_id = '';
  String option = '';
  String opt_image = '';
  String option_image_url = '';
  String text_status = '';
  HWQuestionOptions(
      {this.opt_image,
        this.option,
        this.option_id,
        this.text_status,
        this.option_image_url});
}

Future<bool> saveyouranswer(hwanswer data,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "homework_id": data.examid,
    "user_id": Logindata.userid,
    "class_id": Logindata.curr_class_id,
    "subj_id": data.subid,
    "total_marks": data.totalmarks,
    "stud_homework_id": data.studntexamid,
    "question_id": data.questionid,
    "question_type": data.questiontype,
    "marks": data.marks,
    "negative_marks": data.negaivemarks == "" ? 0:data.negaivemarks,
    "show_result": data.showresult,
    "answer": data.answer == null|| data.answer == '' ? data.answer = " ":data.answer
  };
  print("save answer : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/homework/ans/save"),
      headers: headers,
      body: jsonEncode(inputbody));
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  }else{
    var decodeddata = jsonDecode(response.body);
    Flushbar(
      message: decodeddata['msg'],
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
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

class hwanswer {
  String answer = '';
  String examid = "";
  String subid = "";
  String totalmarks = "";
  String studntexamid = "";
  String questionid = "";
  String questiontype = "";
  String marks = "";
  String negaivemarks = "";
  String showresult = "";
  hwanswer(
      {@required this.answer,
        @required this.marks,
        @required this.questiontype,
        @required this.examid,
        @required this.negaivemarks,
        @required this.questionid,
        @required this.showresult,
        @required this.studntexamid,
        @required this.subid,
        @required this.totalmarks});
}

Future<bool> submithomework(attemptstatus, qID, Qtype,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "homework_id": currenthomeworkinfo.id,
    "stud_homework_id": currenthomeworkinfo.studnthomeworkid,
    "exam_class_id": Logindata.curr_class_id,
    "exam_subj_id": currenthomeworkinfo.subid,
  };

  print("exams : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/homework/store"),
      headers: headers,
      body: jsonEncode(inputbody));
  print(response.body);
  if (response.statusCode == 200) {
    Flushbar(
      message: "HomeWork Submitted Successfully",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration:
      Duration(seconds: 4),
      leftBarIndicatorColor:
      secondarycolor,
    )..show(context);
    return true;
  } else {
    return false;
  }
}
class uploadanswer{
  String questionid;
  String subid;
  String examid;
  String stundexamid;
  String type;
  List<File> studentfiles;
  uploadanswer({this.type,this.stundexamid,this.subid,this.questionid,this.examid,this.studentfiles});
}
uploadyouranswer(uploadanswer data) async {
  var request = http.MultipartRequest("POST", Uri.parse(baseurl + "student/homework/ans/upload"));
  request.fields['org_id'] = Logindata.orgid;
  request.fields['curr_batch'] = Logindata.batchid;
  request.fields['master_id'] = Logindata.orgid;
  request.fields['exam_id'] = data.examid;
  request.fields['question_id'] = data.questionid;
  request.fields['class_id'] = Logindata.curr_class_id;
  request.fields['subj_id'] = data.subid;
  request.fields['stud_exam_id'] = data.stundexamid;
  request.fields['question_type'] = data.type;
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "exam_id": data.examid,
    "question_id": data.questionid,
    "class_id": Logindata.curr_class_id,
    "subj_id": data.subid,
    "stud_exam_id": data.stundexamid,
    "question_type": data.type,
  };
  print("input : $inputbody");
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  request.headers.addAll(headers);
  for(int i=0;i<data.studentfiles.length;i++) {
    request.files.add(await http.MultipartFile.
    fromPath('student_files', data.studentfiles[i].path,)
    );
  }
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.body);
}