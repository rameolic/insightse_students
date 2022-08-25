import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  User({
    this.code,
    this.status,
    this.data,
  });

  int code;
  String status;
  List<Datum> data;

  factory User.fromJson(Map<String, dynamic> json) => User(
        code: json["code"],
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    this.onlineClassId,
    this.meetingId,
    this.meetingPwd,
    this.apiKey,
    this.apiSecret,
    this.videos1,
    this.videos2,
    this.sessionName,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.duration,
    this.createdBy,
    this.subjectName,
    this.subjectId,
    this.orgId,
    this.participantCount,
    this.createdAt,
    this.joinUrl,
    this.registrantId,
    this.showrecorderdvedio
  });

  String onlineClassId;
  String meetingId;
  String meetingPwd;
  String apiKey;
  String apiSecret;
  String videos1;
  List<String> videos2;
  String sessionName;
  DateTime sessionDate;
  String startTime;
  String endTime;
  String duration;
  String createdBy;
  String subjectName;
  String subjectId;
  String orgId;
  int participantCount;
  DateTime createdAt;
  String joinUrl;
  String registrantId;
  var showrecorderdvedio;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        onlineClassId: json["online_class_id"],
        meetingId: json["meeting_id"],
        meetingPwd: json["meeting_pwd"],
        apiKey: json["api_key"],
        apiSecret: json["api_secret"],
        videos1: json["videos_1"],
        videos2: List<String>.from(json["videos_2"].map((x) => x)),
        sessionName: json["session_name"],
        sessionDate: DateTime.parse(json["session_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        duration: json["duration"],
        createdBy: json["created_by"],
        subjectName: json["subject_name"],
        subjectId: json["subject_id"],
        orgId: json["org_id"],
        participantCount: json["participant_count"],
        createdAt: DateTime.parse(json["created_at"]),
        joinUrl: json["join_url"],
        registrantId: json["registrant_id"],
    showrecorderdvedio: json["show_rec_video"],
      );
}
