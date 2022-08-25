import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));



class Profile {
    Profile({
        this.code,
        this.status,
        this.data,
    });

    int code;
    String status;
    Data data;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        code: json["code"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

}

class Data {
    Data({
        this.fullName,
        this.username,
        this.gender,
        this.dob,
        this.admissionNo,
        this.fatherTitle,
        this.motherTitle,
        this.fatherName,
        this.motherName,
        this.smsNumber,
        this.notificationEmail,
        this.currClass,
        this.currDivision,
        this.loginStatus,
        this.lastVisitedAt,
    });

    String fullName;
    String username;
    String gender;
    DateTime dob;
    String admissionNo;
    String fatherTitle;
    String motherTitle;
    String fatherName;
    String motherName;
    String smsNumber;
    String notificationEmail;
    String currClass;
    String currDivision;
    DateTime loginStatus;
    DateTime lastVisitedAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        fullName: json["full_name"],
        username: json["username"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        admissionNo: json["admission_no"],
        fatherTitle: json["father_title"],
        motherTitle: json["mother_title"],
        fatherName: json["father_name"],
        motherName: json["mother_name"],
        smsNumber: json["sms_number"],
        notificationEmail: json["notification_email"],
        currClass: json["curr_class"],
        currDivision: json["curr_division"],
        loginStatus: DateTime.parse(json["login_status"]),
        lastVisitedAt: DateTime.parse(json["last_visited_at"]),
    );

  
}
