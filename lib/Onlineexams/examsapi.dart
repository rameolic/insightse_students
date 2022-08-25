import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';

int totalmarks;
ExamInfo currentexaminfo;

class ExamInfo {
  String classandsubject;
  int totalmarks;
  int examduration;
  String exam;
  String examid = "";
  String subid = "";
  String studntexamid = "";
  String showresult = "";
  ExamInfo(
      {this.showresult,
      this.studntexamid,
      this.totalmarks,
      this.subid,
      this.examid,
      this.exam,
      this.classandsubject,
      this.examduration});
}

class Examanswer {
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
  Examanswer({
      this.answer,
      this.marks,
      this.questiontype,
      this.examid,
      this.negaivemarks,
      this.questionid,
      this.showresult,
      this.studntexamid,
      this.subid,
    this.filepaths,
      this.totalmarks});
}

List<Examanswer> answersdata = [];

Future<bool> startexam(examid, context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "exam_id": examid,
    "user_id": Logindata.userid
  };
  print("exams : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(
          baseurl+ "student/exam/start"),
      headers: headers,
      body: jsonEncode(inputbody));
  if (response.statusCode == 200) {
    print(response.body);
    var decodeddata = jsonDecode(response.body);
    if (decodeddata['msg'] != null) {
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
    } else {
      var questionsdata = decodeddata['data']['exam_questions_info'];
      examquestiondata = [];
      totalmarks = 0;
      for (int i = 0; i < questionsdata.length; i++) {
        List<QuestionOptions> options=[];
        if(questionsdata[i]['question_type']=="1"){
          for(int u =0;u<questionsdata[i]['options'].length;u++){
            options.add(QuestionOptions(
              option: questionsdata[i]['options'][u]['option'],
              opt_image: questionsdata[i]['options'][u]['opt_image'],
              option_id: questionsdata[i]['options'][u]['option_id'],
              option_image_url: questionsdata[i]['options'][u]['option_image_url'],
              text_status: questionsdata[i]['options'][u]['text_status'] ,
            ));
          }
        }
        examquestiondata.add(Examquestionsinfo(
          question_id: questionsdata[i]['question_id'],
          question: questionsdata[i]['question'],
          questiontype: questionsdata[i]['question_type'],
          negative_mark: questionsdata[i]['negative_marks'],
          marks: questionsdata[i]['marks'],
          image: questionsdata[i]['image'],
          question_file_url: questionsdata[i]['question_file_url'],
          optionsdata: options,
        ));
        if(questionsdata[i]['marks']!="") {
          totalmarks = totalmarks + int.parse(questionsdata[i]['marks']);
        }
      }
      currentexaminfo = ExamInfo(
          exam: decodeddata['data']['exam_info']['exam_name'],
          classandsubject:
              "${decodeddata['data']['selected_class']} & ${decodeddata['data']['exam_subj_info']['sub_name']}",
          examduration:
              int.parse(decodeddata['data']['exam_info']['exm_duration']),
          showresult: decodeddata['data']['exam_info']['instant_res_show'],
          studntexamid: decodeddata['data']['stud_exam_id'].toString(),
          totalmarks: totalmarks,
          examid: decodeddata['data']['exam_subj_info']['exam_id'],
          subid: decodeddata['data']['exam_subj_info']['subj_id']);
      return true;
    }
  }
}

List<Examquestionsinfo> examquestiondata = [];

class Examquestionsinfo {
  String question_id = '';
  String question = '';
  String questiontype = '';
  String negative_mark = '';
  String marks = '';
  String image = '';
  String question_file_url = '';
  String answer = '';
  List<QuestionOptions> optionsdata = [];

  Examquestionsinfo(
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

class QuestionOptions {
  String option_id = '';
  String option = '';
  String opt_image = '';
  String option_image_url = '';
  String text_status = '';
  QuestionOptions(
      {this.opt_image,
      this.option,
      this.option_id,
      this.text_status,
      this.option_image_url});
}

Future<bool> saveyouranswer(Examanswer data,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "exam_id": data.examid,
    "user_id": Logindata.userid,
    "class_id": Logindata.curr_class_id,
    "subj_id": data.subid,
    "total_marks": data.totalmarks,
    "stud_exam_id": data.studntexamid,
    "question_id": data.questionid,
    "question_type": data.questiontype,
    "marks": data.marks,
    "negative_marks": data.negaivemarks.toString() == "null" || data.negaivemarks.toString() == "" ? " " : data.negaivemarks,
    "show_result": data.showresult,
    "answer": data.answer.toString() == "null" ? " " : data.answer
  };
  print("save answer : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/exam/ans/save"),
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

// uploadyouranswer() async {
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Authorization':
//         'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
//   };
//   Map inputbody = {
//     "org_id": Logindata.orgid,
//     "curr_batch": Logindata.batchid,
//     "master_id": Logindata.master_id,
//     "exam_id": "examid",
//     "user_id": Logindata.userid
//   };
//   print("exams : ${inputbody}");
//   http.Response response = await http.post(
//       Uri.parse(baseurl + "student/exam/start"),
//       headers: headers,
//       body: jsonEncode(inputbody));
//   if (response.statusCode == 200) {}
// }
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
  var request = http.MultipartRequest("POST", Uri.parse(baseurl + "student/exam/ans/upload"));
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

Future<bool> submitexam(attemptstatus, qID, Qtype,context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "exam_id": currentexaminfo.examid,
    "user_id": Logindata.userid,
    "exam_class_id": Logindata.curr_class_id,
    "exam_subj_id": currentexaminfo.subid,
    "question_attempt_status": attemptstatus,
    "stud_exam_id": currentexaminfo.studntexamid,
    "exam_question_id": qID,
    "exam_question_type": Qtype
  };
  print("exams : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/exam/store"),
      headers: headers,
      body: jsonEncode(inputbody));
  if (response.statusCode == 200) {
    print(response.body);
    Flushbar(
      message: "question id($qID) for ExamID(${currentexaminfo.examid}) Submitted Successfully",
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
class note{
  String message;
  List<dynamic>files=[];
  note({this.files,this.message});
}
Future<note> getnotes(id) async {

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "did": id,
    "org_id":Logindata.orgid
  };
  print("exams : ${inputbody}");
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/notes/message"),
      headers: headers,
      body: jsonEncode(inputbody));
  print(response.body);
  if (response.statusCode == 200) {

    var decodeddata = jsonDecode(response.body);
    var data = note(
      message: decodeddata['data']['message'],
      files: decodeddata['data']['files']
    );
    for(int i=0;i<data.files.length;i++){
      data.files[i]= _parseHtmlString(data.files[i]);
    }
    return data;
  }
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : ${parsedString}");
  return parsedString;
}

