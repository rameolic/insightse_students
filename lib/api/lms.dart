import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future GetLmsData(date) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {
    "org_id": Logindata.orgid,
    "curr_batch": Logindata.batchid,
    "master_id": Logindata.master_id,
    "subj_id": "null",
    "from_date": "$date"
  };
  print(inputbody);
  print("url : ${baseurl + "student/all/list"}");
  print("token :"+'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}');
  http.Response response = await http.post(
      Uri.parse(baseurl + "student/all/list"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    lmsdata = [];
    var decodeddata = jsonDecode(response.body);
    var examsdata = decodeddata['data']['online_exams'];
    for (int i = 0; i < examsdata.length; i++) {
      lmsdata.add(Lms(
        type: "exam",
        exam_createdat: examsdata[i]['created_at'],
        exam_end_at: examsdata[i]['end_at'],
        exam_exam: examsdata[i]['exam'],
        exam_examdscrptn: examsdata[i]['exam_desc'],
        exam_examid: examsdata[i]['exam_id'],
        exam_facfullname: examsdata[i]['fac_full_name'],
        exam_orgclassid: examsdata[i]['org_class_id'],
        exam_start_at: examsdata[i]['start_at'],
        exam_subj_id: examsdata[i]['subj_id'],
        exam_subjectname: examsdata[i]['subject_name'],
        exam_time: examsdata[i]['time'],
        exam_status: examsdata[i]['is_submitted'],
      ));
    }

    var classesdata = decodeddata['data']['online_classes'];
    for (int i = 0; i < classesdata.length; i++) {
      lmsdata.add(Lms(
        type: "class",
        class_subjectname: classesdata[i]['subj_name'],
        class_sessionname: classesdata[i]['session_name'],
        class_sessiondate: classesdata[i]['session_date'],
        class_facfullname: classesdata[i]['fac_full_name'],
        class_sessionstarttime: classesdata[i]['session_start_time'],
        class_sessionendtime: classesdata[i]['session_end_time'],
        class_meetingid: classesdata[i]['meeting_id'],
        class_show_rec_video: classesdata[i]['show_rec_video'],
        class_recordedvideo: classesdata[i]['rec_videos'],
      ));
    }

    var homeworkdata = decodeddata['data']['online_homework'];
    for (int i = 0; i < homeworkdata.length; i++) {
      lmsdata.add(Lms(
        type: "homework",
        homework_createdat: homeworkdata[i]['created_at'],
        homework_description: homeworkdata[i]['description'],
        homework_facfullname: homeworkdata[i]['fac_full_name'],
        homework_homeworkenddate: homeworkdata[i]['homework_enddate'],
        homework_homeworkid: homeworkdata[i]['homework_id'],
        homework_homeworkstartdate: homeworkdata[i]['homework_startdate'],
        homework_subjectname: homeworkdata[i]['subject_name'],
        homework_subjid: homeworkdata[i]['subj_id'],
        homework_time: homeworkdata[i]['time'],
        homework_title: homeworkdata[i]['title'],
        homework_status: homeworkdata[i]['is_submitted'],
      ));
    }

    var docdata = decodeddata['data']['documents_and_videos'];
    for (int i = 0; i < docdata.length; i++) {
      lmsdata.add(Lms(
        type: "doc",
        doc_id: docdata[i]['id'],
        doc_batchid: docdata[i]['batch_id'],
        doc_orgid: docdata[i]['org_id'],
        doc_Subjectid: docdata[i]['subj_id'],
        doc_groupid: docdata[i]['grp_id'],
        doc_title: docdata[i]['title'],
        doc_description: docdata[i]['description'],
        doc_document_date: docdata[i]['document_date'],
        doc_documentstarttime: docdata[i]['document_starttime'],
        doc_documentendtime: docdata[i]['document_endtime'],
        doc_document: docdata[i]['document'],
        doc_status: docdata[i]['is_status'],
        doc_createdat: docdata[i]['created_at'],
        doc_createdby: docdata[i]['created_by'],
        doc_updatedat: docdata[i]['updated_at'],
        doc_updatedby: docdata[i]['updated_by'],
        doc_facfullname: docdata[i]['fac_full_name'],
        doc_subname: docdata[i]['sub_name'],
      ));
    }
    return true;
  }
}

List<Lms> lmsdata = [];

class Lms {
  String type = "";
  String doc_id = "";
  String doc_batchid = "";
  String doc_orgid = "";
  String doc_Subjectid = "";
  String doc_groupid = "";
  String doc_title = "";
  String doc_description = "";
  String doc_document_date = "";
  String doc_documentstarttime = "";
  String doc_documentendtime = "";
  String doc_document = "";
  String doc_status = "";
  String doc_createdat = "";
  String doc_createdby = "";
  String doc_updatedat = "";
  String doc_updatedby = "";
  String doc_facfullname = "";
  String doc_subname = "";
  String exam_orgclassid = "";
  String exam_examid = "";
  String exam_exam = "";
  String exam_examdscrptn = "";
  String exam_time = "";
  String exam_facfullname = "";
  String exam_createdat = "";
  String exam_subjectname = "";
  String exam_subj_id = "";
  String exam_start_at = "";
  String exam_end_at = "";
  String exam_status = "";
  String homework_homeworkid = "";
  String homework_title = "";
  String homework_description = "";
  String homework_time = "";
  String homework_homeworkstartdate = "";
  String homework_homeworkenddate = "";
  String homework_facfullname = "";
  String homework_createdat = "";
  String homework_subjectname = "";
  String homework_subjid = "";
  String homework_status = "";
  String class_sessionname = '';
  String class_sessiondate = '';
  String class_sessionstarttime = '';
  String class_sessionendtime = '';
  String class_sessionduration = '';
  String class_session_type = '';
  String class_facfullname = '';
  String class_onlineclassid = '';
  String class_meetingid = '';
  String class_joinurl = '';
  String class_show_rec_video = '';
  String class_subjectname = '';
  List<dynamic> class_recordedvideo = [];
  Lms({
    this.type,
    this.class_facfullname,
    this.class_joinurl,
    this.class_meetingid,
    this.class_onlineclassid,
    this.class_session_type,
    this.class_sessiondate,
    this.class_sessionduration,
    this.class_sessionendtime,
    this.class_sessionname,
    this.class_sessionstarttime,
    this.class_show_rec_video,
    this.class_subjectname,
    this.class_recordedvideo,
    this.doc_batchid,
    this.doc_createdat,
    this.doc_createdby,
    this.doc_description,
    this.doc_document,
    this.doc_document_date,
    this.doc_documentendtime,
    this.doc_documentstarttime,
    this.doc_facfullname,
    this.doc_groupid,
    this.doc_id,
    this.doc_orgid,
    this.doc_status,
    this.doc_Subjectid,
    this.doc_subname,
    this.doc_title,
    this.doc_updatedat,
    this.doc_updatedby,
    this.exam_createdat,
    this.exam_end_at,
    this.exam_exam,
    this.exam_examdscrptn,
    this.exam_examid,
    this.exam_facfullname,
    this.exam_orgclassid,
    this.exam_start_at,
    this.exam_subj_id,
    this.exam_subjectname,
    this.exam_time,
    this.homework_createdat,
    this.homework_description,
    this.homework_facfullname,
    this.homework_homeworkenddate,
    this.homework_homeworkid,
    this.homework_homeworkstartdate,
    this.homework_subjectname,
    this.homework_subjid,
    this.homework_time,
    this.homework_title,
    this.exam_status,
    this.homework_status
  });
}
