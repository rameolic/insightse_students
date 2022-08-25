import 'dart:convert';

Meeting meetingFromJson(String str) => Meeting.fromJson(json.decode(str));



class Meeting {
    Meeting({
        this.code,
        this.status,
        this.data,
    });

    int code;
    String status;
    Data data;

    factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        code: json["code"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

   
}

class Data {
    Data({
        this.url,
        this.msg,
    });

    String url;
    String msg;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        url: json["url"],
        msg: json["msg"],
    );

   
}
