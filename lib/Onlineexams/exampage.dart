import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Contsants.dart';
import '../ProgressHUD.dart';
import 'examsapi.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:open_file/open_file.dart';
import 'preveiwexam.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:html/parser.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:path/path.dart' as FileFormat;
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:io' show Platform;
List<TextEditingController> textcontrollers = [];
class ExamPage extends StatelessWidget {
  void initState() {
  examtimeout = false;
  examsubmitted = true;
}
final showexaminfo = new ValueNotifier(true);
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false,
    child: ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) {
          return ProgressHUD(
      inAsyncCall: loading.value,
      opacity: 0.3,
      color: secondarycolor,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(15.0),
                        //     child: Icon(Icons.arrow_back_ios_sharp,
                        //         color: Colors.blueAccent),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SlideCountdown(
                            onDone: () async{
                              examtimeout = true;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => PreviewExam()));
                            },
                            duration: defaultDuration,
                            padding: defaultPadding,
                            slideDirection: SlideDirection.up,
                            fade: true,
                            decoration: BoxDecoration(
                                color: secondarycolor,
                                borderRadius: BorderRadius.circular(10)),
                            icon: Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ValueListenableBuilder<bool>(
                            valueListenable: showexaminfo,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onTap: () {
                                  showexaminfo.value = !showexaminfo.value;
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          showexaminfo.value
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_right_outlined,
                                          color: secondarycolor,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          child: Text(
                                            "Exam Info",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    showexaminfo.value
                                        ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Container(
                                          //   padding: EdgeInsets.symmetric(
                                          //       horizontal: 10,
                                          //       vertical: 8),
                                          //   decoration: BoxDecoration(
                                          //       borderRadius:
                                          //           BorderRadius.circular(
                                          //               15),
                                          //       border: Border.all(
                                          //           color: secondarycolor
                                          //               .withOpacity(0.3))),
                                          //   child: Column(
                                          //     children: [
                                          //       Text(
                                          //         "Subject",
                                          //         style: TextStyle(
                                          //           fontWeight:
                                          //               FontWeight.bold,
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 5,
                                          //       ),
                                          //       Text(
                                          //         "Mathematics",
                                          //         style: TextStyle(),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.1,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: secondarycolor
                                                        .withOpacity(
                                                        0.3))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Exam",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  currentexaminfo.exam,
                                                  style: TextStyle(),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.1,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: secondarycolor
                                                        .withOpacity(
                                                        0.3))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Duration",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${currentexaminfo.examduration} minutes",
                                                  style: TextStyle(),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.1,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: secondarycolor
                                                        .withOpacity(
                                                        0.3))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Total Marks",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  totalmarks.toString(),
                                                  style: TextStyle(),
                                                )
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: secondarycolor
                                                        .withOpacity(
                                                        0.3))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Class & Subject",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${currentexaminfo.classandsubject}",
                                                  style: TextStyle(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : SizedBox(),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height / 1.4,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(15),
                        //
                        // ),
                        child: Column(
                          children: [
                            Table(
                              // columnWidths: {
                              //   0: FlexColumnWidth(1.5),
                              //   1: FlexColumnWidth(7.5),
                              //   2: FlexColumnWidth(1.5),
                              // },
                              children: [
                                TableRow(children: [
                                  Text(
                                    "S.No",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // SizedBox(),
                                  // Text(
                                  //   "Marks",
                                  //   style: TextStyle(fontWeight: FontWeight.bold),
                                  // )
                                ])
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: examquestiondata.length,
                                //shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return examquestiondata[index].questiontype ==
                                      "0"
                                      ? Column(
                                    children: [
                                      SubjectiveQuestion(
                                        questionnumber: index + 1,
                                      ),
                                      if (index ==
                                          examquestiondata.length - 1)
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PreviewExam()),
                                            );
                                          },
                                          child: Container(
                                              color: secondarycolor,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 15),
                                              child: Text(
                                                "Preview answers",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        )
                                    ],
                                  )
                                      : Column(
                                    children: [
                                      ObjectiveQuestion(
                                        questionnumber: index + 1,
                                      ),
                                      if (index ==
                                          examquestiondata.length - 1)
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PreviewExam()),
                                            );
                                          },
                                          child: Container(
                                              color: secondarycolor,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 15),
                                              child: Text(
                                                "Preview answers",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }),
  );
}
}

final loading = new ValueNotifier(false);

var defaultDuration = Duration(minutes: currentexaminfo.examduration);
const defaultPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

class SubjectiveQuestion extends StatefulWidget {
  final int questionnumber;
  SubjectiveQuestion({this.questionnumber});

  @override
  _SubjectiveQuestionState createState() => _SubjectiveQuestionState();
}

class _SubjectiveQuestionState extends State<SubjectiveQuestion> {
  bool enablemathkeyboard = false;
  List<File> pickedfiles=[];
  List<String>pickedfilenames=[];
  final showpickedfiles = new ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    print("file format : ${FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())}");
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   border: Border.all(color: secondarycolor.withOpacity(0.3))
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(9),
              1: FlexColumnWidth(1),
            },
            children: [
              TableRow(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.questionnumber}. ",
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(examquestiondata[widget.questionnumber - 1].question != "null" || examquestiondata[widget.questionnumber - 1].question != "" )
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(
                              _parseHtmlString(examquestiondata[widget.questionnumber - 1].question),
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        if(examquestiondata[widget.questionnumber - 1].image.toString() != "0")
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child:
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".jpg"||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".png"||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".jpeg"||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".tif"||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".tiff"||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".gif" ||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".bmp"||
                                FileFormat.extension(examquestiondata[widget.questionnumber - 1].image.toString())==".eps"
                                ? Image.network(
                              //  networkimage,
                              examquestiondata[widget.questionnumber - 1].image,
                            ):TextButton(
                                  onPressed: (){
                                    launch(examquestiondata[widget.questionnumber - 1].image.toString());
                                  },
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      color: borderyellow,
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Text("Check Attachment",style: TextStyle(color: secondarycolor),),
                                  ),
                                ],
                              ),
                            )
                          ),
                      ],
                    )
                  ],
                ),
                submission[widget.questionnumber - 1]
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Center(
                          //     child: CircleAvatar(
                          //         radius: 15,
                          //         backgroundColor: borderyellow,
                          //         child: Text(
                          //           examquestiondata[widget.questionnumber - 1]
                          //               .marks,
                          //           style: TextStyle(
                          //               fontSize: 14, color: Colors.black),
                          //         ))),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ],
                      )
                    : SizedBox()
                // : Center(
                //     child: CircleAvatar(
                //         radius: 15,
                //         backgroundColor: borderyellow,
                //         child: Text(
                //           examquestiondata[widget.questionnumber - 1].marks,
                //           style:
                //               TextStyle(fontSize: 14, color: Colors.black),
                //         )))
              ])
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Enable Mathkeyboard",
                style: TextStyle(fontSize: 12),
              ),
              Switch(
                value: enablemathkeyboard,
                onChanged: (value) {
                  setState(() {
                    enablemathkeyboard = !enablemathkeyboard;
                  });
                },
                inactiveTrackColor: Colors.red,
                activeColor: secondarycolor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Total marks : ",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                examquestiondata[widget.questionnumber - 1].marks.toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          if (examquestiondata[widget.questionnumber - 1]
                  .negative_mark
                  .toString() !=
              "0")
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Negative marks : ",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  examquestiondata[widget.questionnumber - 1]
                      .negative_mark
                      .toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          !enablemathkeyboard
              ? Theme(
                  data: ThemeData(
                    primarySwatch: Colors.teal,
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      answersdata[widget.questionnumber - 1] = Examanswer(
                        answer: val,
                        marks:
                            examquestiondata[widget.questionnumber - 1].marks,
                        questionid: examquestiondata[widget.questionnumber - 1]
                            .question_id,
                        questiontype:
                            examquestiondata[widget.questionnumber - 1]
                                .questiontype,
                        negaivemarks:
                            examquestiondata[widget.questionnumber - 1]
                                .negative_mark,
                        showresult: currentexaminfo.showresult,
                        examid: currentexaminfo.examid,
                        studntexamid: currentexaminfo.studntexamid,
                        subid: currentexaminfo.subid,
                        totalmarks: "${currentexaminfo.totalmarks}",
                      );
                    },
                    decoration: new InputDecoration(
                      focusColor: primarycolor,
                      hintText: "Type your answer here..",
                      hintStyle: TextStyle(
                        color: grey,
                        fontSize: 16.0,
                      ),
                    ),
                    maxLines: null,
                  ),
                )
              : MathField(
                  decoration: InputDecoration(
                    focusColor: primarycolor,
                    hintText: "Type your answer here..",
                    hintStyle: TextStyle(
                      color: grey,
                      fontSize: 16.0,
                    ),
                  ),
                  variables: const ['x', 'y', 'z', "a", "b", 'c'],
                  onChanged: (value) {
                    String expression;
                    try {
                      expression = '${TeXParser(value).parse()}';
                      answersdata[widget.questionnumber - 1] = Examanswer(
                        answer: expression,
                        marks:
                            examquestiondata[widget.questionnumber - 1].marks,
                        questionid: examquestiondata[widget.questionnumber - 1]
                            .question_id,
                        questiontype:
                            examquestiondata[widget.questionnumber - 1]
                                .questiontype,
                        negaivemarks:
                            examquestiondata[widget.questionnumber - 1]
                                .negative_mark,
                        showresult: currentexaminfo.showresult,
                        examid: currentexaminfo.examid,
                        studntexamid: currentexaminfo.studntexamid,
                        subid: currentexaminfo.subid,
                        totalmarks: "${currentexaminfo.totalmarks}",
                      );
                    } catch (_) {
                      expression = 'invalid input';
                    }
                    print('input expression: $value\n'
                        'converted expression: $expression');
                  },
                ),

          //if(pickedfiles.)
            ListView.builder(
              itemCount: Filescount(widget.questionnumber),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                print("subjective question ${widget.questionnumber} picked files length : ${answersdata[widget.questionnumber - 1].filepaths.length}");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,bottom: 10),
                      child: Text("uploaded file: ${index+1}"),
                    ),
                    SizedBox(
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width / 1.4,
                        child:
                        FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].toString()) == ".jpg" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".png" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".jpeg" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tif" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tiff" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".gif" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".bmp" ||
                            FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".eps"
                            ? Image.file(
                          answersdata[widget.questionnumber - 1].filepaths[index],
                        ) : TextButton(
                          onPressed: () {
                            print("file format: ${FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString())}" == ".jpg");
                            print(answersdata[widget.questionnumber - 1].filepaths[index].path.toString());
                            OpenFile.open(answersdata[widget.questionnumber - 1].filepaths[index].path);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start,
                            children: [
                              Container(
                                color: grey,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text("Check Attachment",
                                  style: TextStyle(
                                      color: Colors.white),),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                );
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async{
                  FilePickerResult picked = await getFile();
                  if(picked != null){
                    showpickedfiles.value = true;
                    pickedfiles = [];
                    List<String>paths=[];
                    paths = picked.paths;
                    pickedfilenames = picked.names;
                    for(int i =0; i<paths.length;i++){
                      pickedfiles.add(File(paths[i]));
                    }
                    if(pickedfiles.length>0) {
                      showpickedfiles.value = true;
                      answersdata[widget.questionnumber - 1] = Examanswer(
                          answer: answersdata[widget.questionnumber - 1].answer,
                          marks:
                          examquestiondata[widget.questionnumber - 1].marks,
                          questionid: examquestiondata[widget.questionnumber - 1]
                              .question_id,
                          questiontype:
                          examquestiondata[widget.questionnumber - 1]
                              .questiontype,
                          negaivemarks:
                          examquestiondata[widget.questionnumber - 1]
                              .negative_mark,
                          showresult: currentexaminfo.showresult,
                          examid: currentexaminfo.examid,
                          studntexamid: currentexaminfo.studntexamid,
                          subid: currentexaminfo.subid,
                          totalmarks: "${currentexaminfo.totalmarks}",
                          filepaths: pickedfiles
                      );
                    }
                    setState(() {

                    });
                    print(picked.names);
                    print("length mowa : ${pickedfiles.length}");
                    //loading.value = true;
                    await uploadyouranswer(uploadanswer(
                        questionid: examquestiondata[widget.questionnumber - 1].question_id,
                        subid: currentexaminfo.subid,
                        examid: currentexaminfo.examid,
                        stundexamid: currentexaminfo.studntexamid,
                        type: examquestiondata[widget.questionnumber - 1].questiontype,
                        studentfiles: pickedfiles
                    ));
                    //  loading.value = false;
                  }
                  else{
                    showpickedfiles.value = false;
                  }
                },
                child: Container(
                    color: borderyellow,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "Upload your answer",
                      style: TextStyle(color: secondarycolor),
                    )),
              ),
              TextButton(
                onPressed: () async {
                  bool status = await saveyouranswer(Examanswer(
                    marks: examquestiondata[widget.questionnumber - 1].marks,
                    questiontype: "0",
                    examid: currentexaminfo.examid,
                    negaivemarks: examquestiondata[widget.questionnumber - 1]
                        .negative_mark,
                    questionid:
                        examquestiondata[widget.questionnumber - 1].question_id,
                    studntexamid: currentexaminfo.studntexamid,
                    subid: currentexaminfo.subid,
                    totalmarks: "${currentexaminfo.totalmarks}",
                    showresult: currentexaminfo.showresult,
                    answer: answersdata[widget.questionnumber - 1].answer,
                  ),context);
                  await uploadyouranswer(uploadanswer(
                      questionid: examquestiondata[widget.questionnumber - 1].question_id,
                      subid: currentexaminfo.subid,
                      examid: currentexaminfo.examid,
                      stundexamid: currentexaminfo.studntexamid,
                      type: examquestiondata[widget.questionnumber - 1].questiontype,
                      studentfiles: pickedfiles
                  ));
                  loading.value = false;
                  if(status){
                    setState(() {
                      submission[widget.questionnumber - 1] = true;
                    });
                  }
                },
                child: Container(
                    color: secondarycolor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "Save your answer",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}

List<bool> submission = [];

class ObjectiveQuestion extends StatefulWidget {
  final int questionnumber;
  ObjectiveQuestion({this.questionnumber});
  @override
  _ObjectiveQuestionState createState() => _ObjectiveQuestionState();
}

class _ObjectiveQuestionState extends State<ObjectiveQuestion> {
  var selectedRadio;
  setselectedradio(int newval) {
    setState(() {
      selectedRadio = newval;
      submission[widget.questionnumber - 1] = true;
    });
  }
  final showpickedfiles = new ValueNotifier(true);
  List<File> pickedfiles=[];
  List<String>pickedfilenames=[];
  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder<bool>(
        valueListenable: showpickedfiles,
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Table(
                columnWidths: {
                  0: FlexColumnWidth(9),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.questionnumber}. ",
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(examquestiondata[widget.questionnumber - 1].question.toString() != "null" || examquestiondata[widget.questionnumber - 1].question != "")
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: Text(
                                  _parseHtmlString(examquestiondata[widget.questionnumber - 1].question),
                                  style: TextStyle(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            if(examquestiondata[widget.questionnumber - 1].image.toString() !=  "0")
                              SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.4,
                                  child:
                                  FileFormat.extension(
                                      examquestiondata[widget.questionnumber -
                                          1].image
                                          .toString()) == ".jpg" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".png" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".jpeg" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".tif" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".tiff" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".gif" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".bmp" ||
                                      FileFormat.extension(
                                          examquestiondata[widget
                                              .questionnumber - 1]
                                              .image
                                              .toString()) == ".eps"
                                      ? Image.network(
                                    //  networkimage,
                                    examquestiondata[widget.questionnumber - 1]
                                        .image,
                                  ) : TextButton(
                                    onPressed: () {
                                      print(examquestiondata[widget
                                          .questionnumber - 1]
                                          .image);
                                      launch(examquestiondata[widget
                                          .questionnumber - 1]
                                          .image);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          color: grey,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text("Check Attachment",
                                            style: TextStyle(
                                                color: Colors.white),),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                          ],
                        )
                      ],
                    ),
                    submission[widget.questionnumber - 1]
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Center(
                        //     child: CircleAvatar(
                        //         radius: 15,
                        //         backgroundColor: borderyellow,
                        //         child: Text(
                        //           examquestiondata[widget.questionnumber - 1]
                        //               .marks,
                        //           style: TextStyle(
                        //               fontSize: 14, color: Colors.black),
                        //         ))),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 25,
                        ),
                      ],
                    )
                        : SizedBox()
                    // : Center(
                    //     child: CircleAvatar(
                    //         radius: 15,
                    //         backgroundColor: borderyellow,
                    //         child: Text(
                    //           examquestiondata[widget.questionnumber - 1].marks,
                    //           style: TextStyle(fontSize: 14, color: Colors.black),
                    //         )))
                  ])
                ],
              ),
              Theme(
                data: ThemeData(
                  primarySwatch: Colors.teal,
                ),
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // height:
                      // examquestiondata[widget.questionnumber - 1].optionsdata.length == 10
                      //     ? 270+45+45+45+45
                      //     :examquestiondata[widget.questionnumber - 1].optionsdata.length == 9
                      //     ? 270+45+45+45
                      //     :examquestiondata[widget.questionnumber - 1].optionsdata.length == 8
                      //     ? 270+45+45
                      //     :examquestiondata[widget.questionnumber - 1].optionsdata.length == 7
                      //     ? 270+45
                      //     :examquestiondata[widget.questionnumber - 1].optionsdata.length == 6
                      //     ? 270
                      //     :examquestiondata[widget.questionnumber - 1].optionsdata.length == 5
                      //     ? 225
                      //     : examquestiondata[widget.questionnumber - 1].optionsdata.length == 4
                      //         ? 180
                      //         : examquestiondata[widget.questionnumber - 1].optionsdata.length == 3
                      //             ? 135
                      //             : 90,
                      child: ListView.builder(
                        itemCount: examquestiondata[widget.questionnumber - 1].optionsdata.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                             if(index != 0) Divider(
                                color: grey,
                                thickness: 0.2,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Radio(
                                      value: index + 1,
                                      groupValue: selectedRadio,
                                      activeColor: primarycolor,
                                      onChanged: (newvalue) async {
                                        setselectedradio(newvalue);
                                        answersdata[widget.questionnumber - 1] =
                                            Examanswer(
                                              answer: "$newvalue",
                                              marks: examquestiondata[widget.questionnumber - 1].marks,
                                              questionid: examquestiondata[widget.questionnumber - 1].question_id,
                                              questiontype: examquestiondata[widget.questionnumber - 1].questiontype,
                                              negaivemarks: examquestiondata[widget.questionnumber - 1].negative_mark,
                                              showresult: currentexaminfo.showresult,
                                              examid: currentexaminfo.examid,
                                              studntexamid: currentexaminfo.studntexamid,
                                              subid: currentexaminfo.subid,
                                              totalmarks: "${currentexaminfo.totalmarks}",
                                            );
                                        print(examquestiondata[widget.questionnumber - 1].optionsdata[int.parse(answersdata[widget.questionnumber - 1].answer)-1].option);
                                        await saveyouranswer(Examanswer(
                                          marks: examquestiondata[widget.questionnumber - 1].marks,
                                          questiontype: "0",
                                          examid: currentexaminfo.examid,
                                          negaivemarks: examquestiondata[widget.questionnumber - 1]
                                              .negative_mark,
                                          questionid:
                                          examquestiondata[widget.questionnumber - 1].question_id,
                                          studntexamid: currentexaminfo.studntexamid,
                                          subid: currentexaminfo.subid,
                                          totalmarks: "${currentexaminfo.totalmarks}",
                                          showresult: currentexaminfo.showresult,
                                          answer: examquestiondata[widget.questionnumber - 1].optionsdata[int.parse(answersdata[widget.questionnumber - 1].answer)-1].option,
                                        ),context);
                                      }),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(examquestiondata[widget.questionnumber - 1].optionsdata[index].option != "")
                                        Text(
                                          _parseHtmlString(examquestiondata[widget.questionnumber - 1].optionsdata[index].option),
                                          style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
                                        ),
                                      if(examquestiondata[widget.questionnumber - 1].optionsdata[index].opt_image.toString() !=  "0")
                                        SizedBox(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 1.4,
                                            child:
                                            FileFormat.extension(
                                                examquestiondata[widget.questionnumber -
                                                    1].optionsdata[index].opt_image
                                                    .toString()) == ".jpg" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".png" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".jpeg" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".tif" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".tiff" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".gif" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".bmp" ||
                                                FileFormat.extension(
                                                    examquestiondata[widget
                                                        .questionnumber - 1]
                                                        .optionsdata[index].opt_image
                                                        .toString()) == ".eps"
                                                ? Image.network(
                                              //  networkimage,
                                              examquestiondata[widget.questionnumber - 1]
                                                  .optionsdata[index].opt_image,
                                            ) : TextButton(
                                              onPressed: () {
                                                print(examquestiondata[widget
                                                    .questionnumber - 1]
                                                    .optionsdata[index].opt_image);
                                                launch(examquestiondata[widget
                                                    .questionnumber - 1]
                                                    .optionsdata[index].opt_image);
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    color: grey,
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 5, horizontal: 10),
                                                    child: Text("Check Attachment",
                                                      style: TextStyle(
                                                          color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total marks : ",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    examquestiondata[widget.questionnumber - 1].marks.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              if (examquestiondata[widget.questionnumber - 1]
                  .negative_mark
                  .toString() !=
                  "0" &&
                  examquestiondata[widget.questionnumber - 1]
                      .negative_mark
                      .toString() !=
                      "")
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Negative marks : ",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      examquestiondata[widget.questionnumber - 1]
                          .negative_mark
                          .toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ListView.builder(
                itemCount: Filescount(widget.questionnumber),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  print("subjective question ${widget.questionnumber} picked files length : ${answersdata[widget.questionnumber - 1].filepaths.length}");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 10),
                        child: Text("uploaded file: ${index+1}"),
                      ),
                      SizedBox(
                          width:
                          MediaQuery
                              .of(context)
                              .size
                              .width / 1.4,
                          child:
                          FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].toString()) == ".jpg" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".png" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".jpeg" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tif" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tiff" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".gif" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".bmp" ||
                              FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".eps"
                              ? Image.file(
                            answersdata[widget.questionnumber - 1].filepaths[index],
                          ) : TextButton(
                            onPressed: () {
                              print("file format: ${FileFormat.extension(answersdata[widget.questionnumber - 1].filepaths[index].path.toString())}" == ".jpg");
                              print(answersdata[widget.questionnumber - 1].filepaths[index].path.toString());
                              OpenFile.open(answersdata[widget.questionnumber - 1].filepaths[index].path);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              children: [
                                Container(
                                  color: grey,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text("Check Attachment",
                                    style: TextStyle(
                                        color: Colors.white),),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  );
                },
              ),
              TextButton(
                onPressed: () async{
                  FilePickerResult picked = await getFile();
                  if(picked != null){
                    showpickedfiles.value = true;
                    pickedfiles = [];
                    List<String>paths=[];
                    paths = picked.paths;
                    pickedfilenames = picked.names;
                    for(int i =0; i<paths.length;i++){
                      pickedfiles.add(File(paths[i]));
                    }
                    if(pickedfiles.length>0) {
                      showpickedfiles.value = true;
                      answersdata[widget.questionnumber - 1] = Examanswer(
                          answer: answersdata[widget.questionnumber - 1].answer,
                          marks:
                          examquestiondata[widget.questionnumber - 1].marks,
                          questionid: examquestiondata[widget.questionnumber - 1]
                              .question_id,
                          questiontype:
                          examquestiondata[widget.questionnumber - 1]
                              .questiontype,
                          negaivemarks:
                          examquestiondata[widget.questionnumber - 1]
                              .negative_mark,
                          showresult: currentexaminfo.showresult,
                          examid: currentexaminfo.examid,
                          studntexamid: currentexaminfo.studntexamid,
                          subid: currentexaminfo.subid,
                          totalmarks: "${currentexaminfo.totalmarks}",
                          filepaths: pickedfiles
                      );
                    }
                    setState(() {

                    });
                    print(picked.names);
                    print("length mowa : ${pickedfiles.length}");
                    //loading.value = true;
                    await uploadyouranswer(uploadanswer(
                        questionid: examquestiondata[widget.questionnumber - 1].question_id,
                        subid: currentexaminfo.subid,
                        examid: currentexaminfo.examid,
                        stundexamid: currentexaminfo.studntexamid,
                        type: examquestiondata[widget.questionnumber - 1].questiontype,
                        studentfiles: pickedfiles
                    ));
                  //  loading.value = false;
                  }else{
                    showpickedfiles.value = false;
                  }
                },
                child: Container(
                    color: borderyellow,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Upload your answer",
                      style: TextStyle(color: secondarycolor),
                    )),
              )
              // TextButton(
              //   onPressed: (){
              //     setState(() {
              //       sumbission[widget.questionnumber-1] = true;
              //     });
              //   },
              //   child: Container(
              //       color: secondarycolor,
              //       padding: EdgeInsets.symmetric(vertical: 10,horizontal:15),
              //       child: Text("Save your answer",style: TextStyle(color: Colors.white),)),
              // )
            ],
          );
        });
  }
}
FilePickerResult file;
Future getFile()async{
  if (Platform.isAndroid) {
    file = await FilePicker.platform.pickFiles(type: FileType.any,allowMultiple: true);
  } else if (Platform.isIOS) {
    file = await FilePicker.platform.pickFiles(allowMultiple: true);
  }
  print(file.paths);
  return file;
}
String networkimage = "https://pbs.twimg.com/media/EWkt3UnWkAA9hNS.jpg";
String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : ${parsedString}");
  return parsedString;
}

int Filescount( questionnumber)  {
  try {
    int a = answersdata[questionnumber - 1].filepaths.length;
    return a;
  } catch (e) {
    print(e);
    return 0;
  }
}

