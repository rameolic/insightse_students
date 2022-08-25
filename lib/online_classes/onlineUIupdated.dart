import 'package:flutter/material.dart';
import '../ProgressHUD.dart';
import '../Contsants.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:convert';
import '../api/lms.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import '../Onlineexams/exampage.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../Onlineexams/examsapi.dart';
import '../mediaplayer.dart';
import 'package:flutter/cupertino.dart';
import '../online_classes/theme/color/light_color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Contsants.dart';
import '../homework/homeworkpage.dart';
import 'package:http/http.dart' as http;
import '../api/homeworkapi.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../gifheader.dart';
import '../newdashboardui.dart';

DateTime picked;
String subjectfilter;

List<dynamic> SubjectsList = [];
enum APP_THEME { LIGHT, DARK }

class NewOnlineClassUi extends StatefulWidget {
  @override
  _NewOnlineClassUiState createState() => _NewOnlineClassUiState();
}

final loading = new ValueNotifier(false);

class _NewOnlineClassUiState extends State<NewOnlineClassUi> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_ISO', null);
    getProvince();
  }
  var currentTheme = APP_THEME.LIGHT;
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
   // await Future.delayed(Duration(milliseconds: 1000));
    await GetLmsData(forthedate);
    print("refresh");
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {

    });
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    print("LOADING");
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await getunreadcount();
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
        return true;
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, value, child) {
            return ProgressHUD(
              inAsyncCall: loading.value,
              opacity: 0.3,
              color: secondarycolor,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: _appBar(),
                body: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: GifHeader1(

                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  //onLoading: _onLoading,
                  child: SafeArea(
                    child: Column(
                      children: [
                        //TodayDate(),
                        DatePicker(),
                        lmsdata.isNotEmpty
                            ? Expanded(
                              child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount:
                          lmsdata.isEmpty ? 0 : lmsdata.length,
                          itemBuilder: (context, index) {
                              if (lmsdata.length != 0) {
                                return lmsdata[index].type == "class"
                                    ? OnlineClassCard(
                                  subject: lmsdata[index]
                                      .class_subjectname,
                                  type: "Online Class",
                                  sessionName: lmsdata[index]
                                      .class_sessionname,
                                  sessionDate: DateFormat(
                                      "yyyy-MM-dd")
                                      .format(DateTime.parse(
                                      lmsdata[index]
                                          .class_sessiondate))
                                      .toString(),
                                  facFullName: lmsdata[index]
                                      .class_facfullname,
                                  sessionStartTime: lmsdata[
                                  index]
                                      .class_sessionstarttime,
                                  sessionEndTime: lmsdata[index]
                                      .class_sessionendtime,
                                  meetingid: lmsdata[index]
                                      .class_meetingid,
                                  showrecordedvedio:
                                  lmsdata[index]
                                      .class_show_rec_video,
                                  buttonvalue: "join Now",
                                  background: borderyellow,
                                  ontap: () async {
                                    if (await canijoin(
                                        lmsdata[index]
                                            .class_meetingid)) {
                                      try {
                                        launch(url);
                                      } catch (e) {
                                        showGeneralDialog(
                                            barrierColor: Colors
                                                .white
                                                .withOpacity(
                                                0.5),
                                            transitionBuilder:
                                                (context,
                                                a1,
                                                a2,
                                                widget) {
                                              return Transform
                                                  .scale(
                                                scale: a1.value,
                                                child: Opacity(
                                                  opacity:
                                                  a1.value,
                                                  child:
                                                  AlertDialog(
                                                    shape: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(16.0)),
                                                    title: Text(
                                                        'Alert!!',
                                                        style: GoogleFonts
                                                            .robotoSlab(
                                                          fontSize:
                                                          20,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontStyle:
                                                          FontStyle.normal,
                                                        )),
                                                    content: Text(
                                                        'Please install Zoom for having secured Classes',
                                                        style: GoogleFonts
                                                            .robotoSlab(
                                                          fontSize:
                                                          17,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontStyle:
                                                          FontStyle.normal,
                                                        )),
                                                  ),
                                                ),
                                              );
                                            },
                                            transitionDuration:
                                            Duration(
                                                milliseconds:
                                                90),
                                            barrierDismissible:
                                            true,
                                            barrierLabel: '',
                                            context: context,
                                            // ignore: missing_return
                                            pageBuilder: (context,
                                                animation1,
                                                animation2) {});
                                      }
                                    } else {
                                      Flushbar(
                                        message: errormessage,
                                        icon: Icon(
                                          Icons.info_outline,
                                          size: 28.0,
                                          color: secondarycolor,
                                        ),
                                        duration: Duration(
                                            seconds: 4),
                                        leftBarIndicatorColor:
                                        secondarycolor,
                                      )..show(context);
                                    }
                                  },
                                  onplayvideo: () async {
                                    String url;
                                    if (lmsdata[index]
                                        .class_recordedvideo
                                        .toString() !=
                                        "null") {
                                      if (lmsdata[index]
                                          .class_recordedvideo
                                          .length ==
                                          1) {
                                        playonlineclass(
                                            lmsdata[index]
                                                .class_recordedvideo[0],
                                            index,
                                            context);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                StatefulBuilder(
                                                    builder:
                                                        (context,
                                                        setState) {
                                                      List<dynamic>
                                                      videoslist =
                                                          lmsdata[index]
                                                              .class_recordedvideo;
                                                      return ProgressHUD(
                                                        inAsyncCall:
                                                        false,
                                                        opacity:
                                                        0.3,
                                                        child:
                                                        AlertDialog(
                                                          backgroundColor:
                                                          Colors
                                                              .white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.all(Radius.circular(15.0))),
                                                          content:
                                                          Builder(
                                                            builder:
                                                                (context) {
                                                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                              return SizedBox(
                                                                height: videoslist.length > 10
                                                                    ? 620
                                                                    : videoslist.length == 10
                                                                    ? 570
                                                                    : videoslist.length == 9
                                                                    ? 520
                                                                    : videoslist.length == 8
                                                                    ? 470
                                                                    : videoslist.length == 7
                                                                    ? 420
                                                                    : videoslist.length == 6
                                                                    ? 370
                                                                    : videoslist.length == 5
                                                                    ? 320
                                                                    : videoslist.length == 4
                                                                    ? 270
                                                                    : videoslist.length == 3
                                                                    ? 220
                                                                    : videoslist.length == 2
                                                                    ? 170
                                                                    : 130,
                                                                width:
                                                                MediaQuery.of(context).size.width / 1.3,
                                                                child:
                                                                SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text(
                                                                        'Online Recorded Class',
                                                                        style: TextStyle(color: Colors.black, fontSize: 18),
                                                                      ),
                                                                      Divider(
                                                                        color: Colors.black, //secondarycolor.withOpacity(0.5),
                                                                        thickness: 0.8,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      ListView.builder(
                                                                          scrollDirection: Axis.vertical,
                                                                          itemCount: lmsdata[index].class_recordedvideo.length,
                                                                          shrinkWrap: true,
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          itemBuilder: (context, index) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                playonlineclass(videoslist[index], index, context);
                                                                              },
                                                                              child: Container(
                                                                                  margin: EdgeInsets.only(bottom: 10),
                                                                                  color: secondarycolor,
                                                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "Link ${index + 1}",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  )),
                                                                            );
                                                                          }),
                                                                      Text(
                                                                        "Note* Multiple video links are found, Tap on one of the above links to play online class",
                                                                        style: TextStyle(color: Colors.black, fontSize: 10),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }));
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(
                                                Duration(
                                                    seconds: 2),
                                                    () {
                                                  Navigator.of(
                                                      context)
                                                      .pop(true);
                                                });
                                            return AlertDialog(
                                              content: Stack(
                                                alignment:
                                                Alignment
                                                    .center,
                                                children: <
                                                    Widget>[
                                                  Image.asset(
                                                    'assets/error.png',
                                                    height: 200,
                                                    fit: BoxFit
                                                        .fill,
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                  },
                                )
                                    : lmsdata[index].type == "exam"
                                    ? OnlineClassCard(
                                  subject: lmsdata[index]
                                      .exam_subjectname,
                                  sessionName:
                                  lmsdata[index]
                                      .exam_exam,
                                  sessionStartTime:
                                  lmsdata[index]
                                      .exam_start_at,
                                  sessionEndTime:
                                  lmsdata[index]
                                      .exam_end_at,
                                  buttonvalue: lmsdata[
                                  index]
                                      .exam_status !=
                                      "1"
                                      ? "Start Now"
                                      : "Submitted",
                                  type: "Online Exam",
                                  examdescrp: lmsdata[index]
                                      .exam_examdscrptn,
                                  background:
                                  Colors.green.shade200,
                                  ontap: () async {
                                    if (lmsdata[index]
                                        .exam_status !=
                                        "1") {
                                      loading.value = true;
                                      bool beginexam =
                                      await startexam(
                                          "${lmsdata[index].exam_examid}",
                                          context);
                                      loading.value = false;
                                      if (
                                      beginexam
                                      ) {
                                        submission = [];
                                        textcontrollers =
                                        [];
                                        answersdata = [];
                                        print(
                                            "questions : ${examquestiondata.length}");
                                        for (int i = 0;
                                        i <
                                            examquestiondata
                                                .length;
                                        i++) {
                                          print("loop:$i");
                                          submission
                                              .add(false);
                                          textcontrollers.add(
                                              TextEditingController());
                                          answersdata.add(
                                              Examanswer());
                                        }
                                        print(
                                            "answers : ${answersdata.length}");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  ExamPage()),
                                        );
                                      }
                                    }
                                  },
                                )
                                    : lmsdata[index].type ==
                                    "homework"
                                    ? OnlineClassCard(
                                  time: lmsdata[index]
                                      .homework_time,
                                  subject: lmsdata[
                                  index]
                                      .homework_subjectname,
                                  sessionName: lmsdata[
                                  index]
                                      .homework_title,
                                  sessionStartTime:
                                  lmsdata[index]
                                      .homework_homeworkstartdate,
                                  sessionEndTime: lmsdata[
                                  index]
                                      .homework_homeworkenddate,
                                  buttonvalue: lmsdata[
                                  index].homework_status=="0"?"Start Now":"Submitted",
                                  type: "Home Work",
                                  examdescrp: lmsdata[
                                  index]
                                      .homework_description,
                                  facFullName: lmsdata[
                                  index]
                                      .homework_facfullname,
                                  background: Colors
                                      .redAccent
                                      .shade100,
                                  showrecordedvedio:
                                  "0",
                                  ontap: () async {
                                    if(lmsdata[index].homework_status =="0"){
                                      loading.value =
                                      true;
                                      bool start =
                                      await starthomework(
                                          forthedate,
                                          lmsdata[index]
                                              .homework_homeworkid,
                                          context);
                                      loading.value =
                                      false;
                                      print(start);
                                      if (start) {
                                        homeworksubmission = [];
                                        hwtextcontrollers = [];
                                        hwanswersdata = [];
                                        print(
                                            "questions : ${homeworkquestiondata.length}");
                                        for (int i = 0;
                                        i < homeworkquestiondata.length; i++) {
                                          print(
                                              "loop:$i");
                                          homeworksubmission
                                              .add(false);
                                          hwtextcontrollers
                                              .add(
                                              TextEditingController());
                                          hwanswersdata.add(
                                              homeworkanswer());
                                        }
                                        print(
                                            "answers : ${hwanswersdata.length}");
                                        loading.value =
                                        false;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  HomeworkPage()),
                                        );
                                      }
                                    }else{
                                      Flushbar(
                                        message: "you already Submitted the Home Work",
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
                                    }
                                  },
                                )
                                    : lmsdata[index].type ==
                                    "doc"
                                    ? OnlineClassCard(
                                  subject: lmsdata[
                                  index]
                                      .doc_subname,
                                  sessionName:
                                  lmsdata[index]
                                      .doc_title,
                                  buttonvalue:
                                  "View Notes",
                                  type: "Notes",
                                  facFullName: lmsdata[
                                  index]
                                      .doc_facfullname,
                                  sessionDate: lmsdata[
                                  index]
                                      .doc_document_date,
                                  sessionStartTime:
                                  lmsdata[index]
                                      .doc_documentstarttime,
                                  examdescrp: lmsdata[
                                  index]
                                      .doc_description,
                                  background: Colors
                                      .teal.shade50,
                                  ontap: () async {
                                    loading.value = true;
                                    note data = await getnotes(lmsdata[index].doc_id);
                                    loading.value = false;
                                    // if (data.files.length == 1) {
                                    showDialog(
                                        context:
                                        context,
                                        builder: (_) =>
                                            StatefulBuilder(builder:
                                                (context, setState) {
                                              List<dynamic> videoslist = data.files;
                                              return ProgressHUD(
                                                inAsyncCall: false,
                                                opacity: 0.3,
                                                child: AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                  content: Builder(
                                                    builder: (context) {
                                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                      return SizedBox(
                                                        width: MediaQuery.of(context).size.width / 1.3,
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                'Note',
                                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                              ),
                                                              Divider(
                                                                color: Colors.black, //secondarycolor.withOpacity(0.5),
                                                                thickness: 0.8,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              if(data.message.toString()!="null"||data.message.toString()!="")
                                                                Text(
                                                                  data.message,
                                                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                                                ),
                                                              if(videoslist.length>0)
                                                                ListView.builder(
                                                                    scrollDirection: Axis.vertical,
                                                                    itemCount: videoslist.length,
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemBuilder: (context, index) {
                                                                      return GestureDetector(
                                                                        onTap: () {
                                                                          print(videoslist[index]);
                                                                          launch(videoslist[index]);
                                                                        },
                                                                        child: Container(
                                                                            margin: index==0 ? EdgeInsets.only(bottom: 10,top: 10) :EdgeInsets.only(bottom: 10),
                                                                            color: secondarycolor,
                                                                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "Link ${index + 1}",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            )),
                                                                      );
                                                                    }),

                                                              if(videoslist.length>1)
                                                                Text(
                                                                  "Note* Multiple file links are found, Tap on one of the above links to open file",
                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              if(videoslist.length>0)
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }));
                                    //  }
                                    //   if(url.length!=0){
                                    //
                                    //   }else{
                                    //     Flushbar(
                                    //       message: "NO Attachments were found",
                                    //       icon: Icon(
                                    //         Icons.info_outline,
                                    //         size: 28.0,
                                    //         color: secondarycolor,
                                    //       ),
                                    //       duration:
                                    //       Duration(seconds: 4),
                                    //       leftBarIndicatorColor:
                                    //       secondarycolor,
                                    //     )..show(context);
                                    //   }
                                  },
                                )
                                    : SizedBox();
                                // else {
                                //   return subjectfilter ==
                                //           lmsdata[index].class_subjectname
                                //       ? OnlineClassCard(
                                //           subject: lmsdata[index]
                                //               .class_subjectname,
                                //           type: "Online Class",
                                //           sessionName: lmsdata[index]
                                //               .class_sessionname,
                                //           sessionDate:
                                //               DateFormat("yyyy-MM-dd")
                                //                   .format(DateTime.parse(
                                //                       lmsdata[index]
                                //                           .class_sessiondate))
                                //                   .toString(),
                                //           facFullName: lmsdata[index]
                                //               .class_facfullname,
                                //           sessionStartTime: lmsdata[index]
                                //               .class_sessionstarttime,
                                //           sessionEndTime: lmsdata[index]
                                //               .class_sessionendtime,
                                //           meetingid:
                                //               lmsdata[index].class_meetingid,
                                //           showrecordedvedio: lmsdata[index]
                                //               .class_show_rec_video,
                                //           buttonvalue: "join Now",
                                //           background: borderyellow,
                                //           ontap: () {
                                //             String url;
                                //             if (platformData.data.data[index]
                                //                     .videos2.length >
                                //                 0) {
                                //               print(
                                //                   "link : ${platformData.data.data[index].videos2[0]}");
                                //               if (platformData
                                //                   .data.data[index].videos2[0]
                                //                   .toString()
                                //                   .contains(
                                //                       "drive.google.com")) {
                                //                 final original = platformData
                                //                     .data
                                //                     .data[index]
                                //                     .videos2[0]
                                //                     .toString();
                                //                 final find =
                                //                     'https://drive.google.com/file/d/';
                                //                 final find2 =
                                //                     '/view?usp=sharing';
                                //                 final replaceWith = '';
                                //                 final newString =
                                //                     original.replaceAll(
                                //                         find, replaceWith);
                                //                 final fileid =
                                //                     newString.replaceAll(
                                //                         find2, replaceWith);
                                //                 print("ID : $fileid");
                                //                 url = "https://www.googleapis.com/drive/v3/files/$fileid" +
                                //                     "?alt=media&key=AIzaSyCJWpAvQAxL7SWZjgbVhZxb1KEm3PpB9oM";
                                //               } else {
                                //                 url = platformData.data
                                //                     .data[index].videos2[0]
                                //                     .toString();
                                //               }
                                //               print(url);
                                //               Navigator.push(
                                //                   context,
                                //                   MaterialPageRoute(
                                //                       builder: (context) =>
                                //                           SamplePlayer(
                                //                             subject: platformData
                                //                                 .data
                                //                                 .data[index]
                                //                                 .subjectName,
                                //                             sessionName:
                                //                                 platformData
                                //                                     .data
                                //                                     .data[
                                //                                         index]
                                //                                     .sessionName,
                                //                             sessionDate: DateFormat(
                                //                                     "yyyy-MM-dd")
                                //                                 .format(platformData
                                //                                     .data
                                //                                     .data[
                                //                                         index]
                                //                                     .sessionDate)
                                //                                 .toString(),
                                //                             facFullName:
                                //                                 platformData
                                //                                     .data
                                //                                     .data[
                                //                                         index]
                                //                                     .createdBy,
                                //                             sessionStartTime:
                                //                                 platformData
                                //                                     .data
                                //                                     .data[
                                //                                         index]
                                //                                     .startTime,
                                //                             sessionEndTime:
                                //                                 platformData
                                //                                     .data
                                //                                     .data[
                                //                                         index]
                                //                                     .endTime,
                                //                             joinurl: url,
                                //                           )));
                                //             } else {
                                //               showDialog(
                                //                   context: context,
                                //                   builder: (context) {
                                //                     Future.delayed(
                                //                         Duration(seconds: 2),
                                //                         () {
                                //                       Navigator.of(context)
                                //                           .pop(true);
                                //                     });
                                //                     return AlertDialog(
                                //                       content: Stack(
                                //                         alignment:
                                //                             Alignment.center,
                                //                         children: <Widget>[
                                //                           Image.asset(
                                //                             'assets/error.png',
                                //                             height: 200,
                                //                             fit: BoxFit.fill,
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     );
                                //                   });
                                //             }
                                //           },
                                //         )
                                //       : subjectfilter ==
                                //               lmsdata[index].exam_subjectname
                                //           ? OnlineClassCard(
                                //               subject: lmsdata[index]
                                //                   .exam_subjectname,
                                //               sessionName:
                                //                   lmsdata[index].exam_exam,
                                //               sessionStartTime: lmsdata[index]
                                //                   .exam_start_at,
                                //               sessionEndTime:
                                //                   lmsdata[index].exam_end_at,
                                //               buttonvalue: "Start Now",
                                //               type: "Online Exam",
                                //               examdescrp: lmsdata[index]
                                //                   .exam_examdscrptn,
                                //               background:
                                //                   Colors.green.shade200,
                                //               ontap: () {},
                                //             )
                                //           : subjectfilter ==
                                //                   lmsdata[index]
                                //                       .homework_subjectname
                                //               ? OnlineClassCard(
                                //                   subject: lmsdata[index]
                                //                       .homework_subjectname,
                                //                   sessionName: lmsdata[index]
                                //                       .homework_title,
                                //                   sessionStartTime: lmsdata[
                                //                           index]
                                //                       .homework_homeworkstartdate,
                                //                   sessionEndTime: lmsdata[
                                //                           index]
                                //                       .homework_homeworkenddate,
                                //                   buttonvalue: "Start Now",
                                //                   type: "Home Work",
                                //                   examdescrp: lmsdata[index]
                                //                       .homework_description,
                                //                   facFullName: lmsdata[index]
                                //                       .homework_facfullname,
                                //                   background: Colors
                                //                       .redAccent.shade100,
                                //                   showrecordedvedio: "0",
                                //                   ontap: () {},
                                //                 )
                                //               : subjectfilter ==
                                //                       lmsdata[index]
                                //                           .doc_subname
                                //                   ? OnlineClassCard(
                                //                       subject: lmsdata[index]
                                //                           .doc_subname,
                                //                       sessionName:
                                //                           lmsdata[index]
                                //                               .doc_title,
                                //                       buttonvalue:
                                //                           "View Notes",
                                //                       type: "Notes",
                                //                       facFullName: lmsdata[
                                //                               index]
                                //                           .doc_facfullname,
                                //                       sessionDate: lmsdata[
                                //                               index]
                                //                           .doc_document_date,
                                //                       examdescrp: lmsdata[
                                //                               index]
                                //                           .doc_description,
                                //                       background:
                                //                           Colors.teal.shade50,
                                //                       ontap: () {},
                                //                     )
                                //                   : SizedBox();
                                // }
                              } else {
                                return Column(
                                  children: [
                                    Image.asset('assets/urlnot.png',
                                        width: MediaQuery.of(context).size.width),
                                  ],
                                );
                              }
                          },
                        ),
                            )
                            : Center(
                            child: Image.asset(
                              'assets/urlnot.png',
                              width: MediaQuery.of(context).size.width,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () async{
          await getunreadcount();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              NewDashbBard(
                currentIndex: 0,
              )), (Route<dynamic> route) => false);
        },
        child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
      ),
      title: Text(
        "LMS Dashboard",
        style: TextStyle(color: secondarycolor),
      ),
      centerTitle: true,
    );
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
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      underline: SizedBox(),
                      isDense: true,
                      isExpanded: true,
                      hint: Text(
                        "Select Subject",
                        style: TextStyle(color: Colors.grey[400]),
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
    return SizedBox(
      child: CalendarTimeline(
        initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
        firstDate: DateTime(2018, 1, 15),
        lastDate: DateTime(2030, 11, 20),
        onDateSelected: (date) async {
          forthedate = DateFormat("yyyy-MM-d").format(date);
          loading.value = true;
          await GetLmsData(forthedate);
          loading.value = false;
          setState(
            () {
              _selectedDate = date;
            },
          );
        },
        //leftMargin: 20,
        monthColor: Colors.blueGrey,
        dayColor: Colors.grey,
        activeDayColor: Colors.white,
        activeBackgroundDayColor: primarycolor,
        dotsColor: secondarycolor,
        locale: 'en_ISO',
      ),
    );
  }


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
      final respose = await http.post(
          Uri.parse(finalurl + "Login/subjects_list"),
          headers: headers,
          body: msg); //untuk melakukan request ke webservice

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
  String examdescrp;
  Function ontap;
  Function onplayvideo;
  Color background;
  String buttonvalue;
  var showrecordedvedio;
  String submissionstatus;
  String time;
  String type;
  OnlineClassCard(
      {this.ontap,
      this.background,
      this.meetingid,
      this.subject,
      this.examdescrp,
      this.buttonvalue,
      this.sessionName,
      this.time,
      this.type,
      this.duration,
      this.facFullName,
      this.sessionDate,
      this.sessionEndTime,
      this.showrecordedvedio,
      this.sessionStartTime,
      this.onplayvideo});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(14, 10, 15, 0),
          margin: EdgeInsets.only(bottom: 10, left: 10),
          height: type == "Online Exam" || type == "Notes" ? 150 : 200,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            color: secondarycolor,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  subject != null
                      ? Text(
                          subject,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      : SizedBox(),
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
                            type == "Online Exam"
                                ? "Exam : $sessionName"
                                : "Session : $sessionName",
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
                  if (type == "Notes")
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
                              "Created at : $sessionStartTime",
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
                  if (type != "Notes")
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
                  type != "Online Exam" && type != "Home Work"
                      ? Row(
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
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FlutterIcons.calendar_account_mco,
                                color: Colors.grey[200],
                                size: 15,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Description :  $examdescrp",
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
                        ),
                  if (type == "Home Work")
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
                          "Time :  $time",
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
                  type != "Online Exam"
                      ? Row(
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
                        )
                      : SizedBox(),
                  // ignore: deprecated_member_use
                  "$showrecordedvedio" == "1"
                      ? RaisedButton.icon(
                          icon: Icon(
                            Icons.play_circle_outline_sharp,
                            color: Colors.white,
                            size: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: primarycolor,
                          onPressed: onplayvideo,
                          label: Text(
                            "Play Recorded Video",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      type,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: GestureDetector(
            onTap: ontap,
            child: Container(
                width: type == "Online Exam" || type == "Notes" ? 150 : 200,
                margin: EdgeInsets.only(bottom: 10, left: 10),
                height: MediaQuery.of(context).size.width / 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: background,
                ),
                child: Center(
                    child: Text(
                  buttonvalue,
                  style: TextStyle(
                      color: secondarycolor, fontWeight: FontWeight.bold),
                ))),
          ),
        ),
      ],
    );
  }
}

String url;
String errormessage;
Future<bool> canijoin(meetingid) async {
  loading.value = true;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Authorization":
        "Bearer ${Logindata.usertoken}_ie_" + "${Logindata.userid}",
  };
  final msg = jsonEncode(<String, dynamic>{
    "org_id": Logindata.orgid,
    "batch_id": Logindata.batchid,
    "user_id": Logindata.userid,
    "meeting_id": meetingid,
  });
  print("Authorization: Bearer ${Logindata.usertoken}_ie_" +
      "${Logindata.userid}");
  var response = await http.post(
      Uri.parse(finalurl + "online_class/user/register"),
      headers: headers,
      body: msg);
  print("response: ${response.body}");
  if (response.statusCode == 200) {
    url = json.decode(response.body)['data']['url'];
    loading.value = false;
    return true;
  } else if (response.statusCode == 404) {
    errormessage = json.decode(response.body)['msg'];
    loading.value = false;
    return false;
  } else {
    errormessage =
        "Error while connecting server please try ag»ain, Status code: ${response.statusCode}";
    loading.value = false;
    return false;
  }
}

Function playonlineclass(link, index, context) {
  print("link : $link");
  if (link.toString().contains("drive.google.com")) {
    final original = link.toString();
    final find = 'https://drive.google.com/file/d/';
    final find2 = '/view?usp=sharing';
    final replaceWith = '';
    final newString = original.replaceAll(find, replaceWith);
    final fileid = newString.replaceAll(find2, replaceWith);
    print("ID : $fileid");
    url = "https://www.googleapis.com/drive/v3/files/$fileid" +
        "?alt=media&key=AIzaSyCJWpAvQAxL7SWZjgbVhZxb1KEm3PpB9oM";
  } else {
    url = link.toString();
  }
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SamplePlayer(
                subject: lmsdata[index].class_subjectname,
                sessionName: lmsdata[index].class_sessionname,
                sessionDate: lmsdata[index].class_sessiondate.toString(),
                facFullName: lmsdata[index].class_facfullname,
                sessionStartTime: lmsdata[index].class_sessionstarttime,
                sessionEndTime: lmsdata[index].class_sessionendtime,
                joinurl: url,
              )));
}

String forthedate = picked == null
    ? DateFormat("yyyy-MM-d").format(DateTime.now())
    : DateFormat("yyyy-MM-d").format(picked);