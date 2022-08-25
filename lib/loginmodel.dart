// To parse this JSON data, do
//
//     final loginmodel = loginmodelFromJson(jsonString);

import 'dart:convert';

Loginmodel loginmodelFromJson(String str) => Loginmodel.fromJson(json.decode(str));

String loginmodelToJson(Loginmodel data) => json.encode(data.toJson());

class Loginmodel {
    Loginmodel({
        this.code,
        this.status,
        this.data,
    });

    int code;
    String status;
    Data data;

    factory Loginmodel.fromJson(Map<String, dynamic> json) => Loginmodel(
        code: json["code"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.fullName,
        this.username,
        this.masterId,
        this.userid,
        this.userType,
        this.userRole,
        this.orgId,
        this.batchId,
        this.currBatch,
        this.currClass,
        this.currClassId,
        this.profile,
        this.orgName,
        this.orgLogo,
        this.url,
        this.sliders,
        this.currDate,
        this.currTime,
        this.userToken,
    });

    String fullName;
    String username;
    String masterId;
    String userid;
    String userType;
    String userRole;
    String orgId;
    String batchId;
    String currBatch;
    String currClass;
    String currClassId;
    String profile;
    String orgName;
    String orgLogo;
    String url;
    List<String> sliders;
    DateTime currDate;
    String currTime;
    String userToken;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        fullName: json["full_name"],
        username: json["username"],
        masterId: json["master_id"],
        userid: json["userid"],
        userType: json["user_type"],
        userRole: json["user_role"],
        orgId: json["org_id"],
        batchId: json["batch_id"],
        currBatch: json["curr_batch"],
        currClass: json["curr_class"],
        currClassId: json["curr_class_id"],
        profile: json["profile"],
        orgName: json["org_name"],
        orgLogo: json["org_logo"],
        url: json["url"],
        sliders: List<String>.from(json["sliders"].map((x) => x)),
        currDate: DateTime.parse(json["curr_date"]),
        currTime: json["curr_time"],
        userToken: json["user_token"],
    );

    Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "username": username,
        "master_id": masterId,
        "userid": userid,
        "user_type": userType,
        "user_role": userRole,
        "org_id": orgId,
        "batch_id": batchId,
        "curr_batch": currBatch,
        "curr_class": currClass,
        "curr_class_id": currClassId,
        "profile": profile,
        "org_name": orgName,
        "org_logo": orgLogo,
        "url": url,
        "sliders": List<dynamic>.from(sliders.map((x) => x)),
        "curr_date": "${currDate.year.toString().padLeft(4, '0')}-${currDate.month.toString().padLeft(2, '0')}-${currDate.day.toString().padLeft(2, '0')}",
        "curr_time": currTime,
        "user_token": userToken,
    };
}
