import 'package:flutter/material.dart';
import '../Contsants.dart';
import '../ProgressHUD.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../online_classes/theme/color/light_color.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'exampage.dart';
import 'package:flushbar/flushbar.dart';


class OnlineExams extends StatefulWidget {

  @override
  _OnlineExamsState createState() => _OnlineExamsState();
}
DateTime picked;
String subjectfilter;
List<dynamic> SubjectsList = [];
enum APP_THEME { LIGHT, DARK }
String errormessage;
class _OnlineExamsState extends State<OnlineExams> {
  void initState() {
    super.initState();
    initializeDateFormatting('en_ISO', null);
    getProvince();
  }
  var currentTheme = APP_THEME.LIGHT;
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final loading = new ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) {
          return ProgressHUD(
            inAsyncCall: loading.value,
            opacity: 0.3,
            color: secondarycolor,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: _appBar(),
              body: Column(
                children: [
                  TodayDate(),
                  DatePicker(),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: Exam.length,
                      itemBuilder: (context, index) {
                        if (Exam.isNotEmpty) {
                          if (subjectfilter == null) {
                            return OnlineClassCard(
                              subject: Exam[index],
                              sessionName: Exam[index],
                              sessionDate: Exam[index],
                              facFullName: Exam[index],
                              sessionStartTime: Exam[index],
                              sessionEndTime: Exam[index],
                              meetingid: Exam[index],
                              showrecordedvedio: Exam[index],
                              ontap: () {

                              },
                            );
                          } else {
                            return OnlineClassCard(
                              subject: Exam[index],
                              sessionName: Exam[index],
                              sessionDate: Exam[index],
                              facFullName: Exam[index],
                              sessionStartTime: Exam[index],
                              sessionEndTime: Exam[index],
                              meetingid: Exam[index],
                              showrecordedvedio: Exam[index],
                              ontap: () {
                              },
                            );
                          }
                        } else {
                          return Column(
                            children: [
                              Image.asset('assets/urlnot.png'),
                            ],
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_sharp, color: Colors.blueAccent),
      ),);
  }

  TodayDate() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[400]),
                ),
              ),
              Text(
                "Today",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          SubjectsList.isNotEmpty
              ? SizedBox(
            width: MediaQuery.of(context).size.width/2.8,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                underline: SizedBox(),
                isDense: true,
                isExpanded: true,
                hint: Text(
                  "Select Subject",
                  style: TextStyle(
                      color: Colors.grey[400]
                  ),
                ),
                style: TextStyle(
                    color: currentTheme == APP_THEME.DARK
                        ? Colors.white
                        : Colors.black),
                value: subjectfilter,
                items: SubjectsList.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['subject_name']),
                    value: item['subject_name'],
                  );
                }).toList(),
                iconEnabledColor: currentTheme == APP_THEME.DARK
                    ? Colors.white
                    : LightColor.black,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    subjectfilter = value;
                  });
                },
              ),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  DatePicker() {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: CalendarTimeline(
          initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
          firstDate: DateTime(2018, 1, 15),
          lastDate: DateTime(2030, 11, 20),
          onDateSelected: (date) async {
            forthedate = DateFormat("yyyy-MM-d").format(date);
            loading.value = true;
            await getclassesList(forthedate);
            loading.value = false;
            setState(
                  () {
                _selectedDate = date;
              },
            );
          },
          leftMargin: 20,
          monthColor: Colors.blueGrey,
          dayColor: Colors.grey,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: primarycolor,
          dotsColor: secondarycolor,
          locale: 'en_ISO',
        ));
  }

  String forthedate = picked == null
      ? DateFormat("yyyy-MM-d").format(DateTime.now())
      : DateFormat("yyyy-MM-d").format(picked);
  void getProvince() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization":
      "Bearer ${Logindata.usertoken}_ie_" + "${Logindata.userid}",
      //"Authorization": "Bearer 572d00c542d95ca8c16e5c43965c7f332c4c66ffc5604416c9_ie_"+"${widget.userid}",
    };
    final msg = jsonEncode(<String, dynamic>{
      "org_id": Logindata.orgid,
      "master_id": Logindata.master_id,
      "batch_id": Logindata.batchid,
    });
    try {
      final respose = await http.post(Uri.parse(finalurl + "Login/subjects_list"),
          headers: headers, body: msg); //untuk melakukan request ke webservice

      var listData = jsonDecode(respose.body);

      var gio = listData["data"]; //lalu kita decode hasil datanya
      //var gio12 = listData['data']['subject_id'][0];
      //print("Seeeeeeeeee hereeee $listData");
      setState(() {
        if (mounted)
          SubjectsList = gio; // dan kita set kedalam variable _dataProvince
      });
    } catch (e) {
      print(e);
    }
    // print(widget.orgid);

    // print("data : $gio");
  }
}
class OnlineClassCard extends StatelessWidget {
  String sessionName;
  String meetingid;
  String duration;
  String subject;
  String sessionStartTime;
  String sessionEndTime;
  String sessionDate;
  String facFullName;
  Function ontap;
  var showrecordedvedio;
  OnlineClassCard(
      {this.ontap,
        this.meetingid,
        this.subject,
        this.sessionName,
        this.duration,
        this.facFullName,
        this.sessionDate,
        this.sessionEndTime,
        this.showrecordedvedio,
        this.sessionStartTime});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(14, 10, 15, 0),
          margin: EdgeInsets.only(bottom: 10, left: 10),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            color: secondarycolor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterIcons.timeline_alert_mco,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "$sessionName",
                        maxLines: 1,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterIcons.clock_faw5,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "Start's At : $sessionStartTime - End's At : $sessionEndTime",
                        maxLines: 1,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterIcons.calendar_account_mco,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Date :  $sessionDate",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterIcons.user_astronaut_faw5s,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "Teacher: $facFullName",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // ignore: deprecated_member_use
              "$showrecordedvedio" == "1" ? RaisedButton.icon(
                icon: Icon(
                  Icons.play_circle_outline_sharp,
                  color: Colors.white,
                  size: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: primarycolor,
                onPressed: ontap,
                label: Text(
                  "Play Recorded Video",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ) : SizedBox()
            ],
          ),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExamPage()
                ),
              );
            },
            child: Container(
                width: 200,
                margin: EdgeInsets.only(bottom: 10, left: 10),
                height: MediaQuery.of(context).size.width / 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: Colors.teal.shade50
                ),
                child: Center(
                    child: Text(
                        "Start Now",
                      style: TextStyle(
                          color: secondarycolor, fontWeight: FontWeight.bold),
                    ))),
          ),
        ),
      ],
    );
  }
}

List <String> Exam=["abc","abc"];