import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Contsants.dart';
import '../api/homeworkapi.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../newdashboardui.dart';
import 'package:path/path.dart' as FileFormat;
import 'package:slide_countdown/slide_countdown.dart';
import 'package:html/parser.dart';
import 'package:flushbar/flushbar.dart';
import 'package:path/path.dart' as FileFormat;
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:open_file/open_file.dart';

List<TextEditingController> hwtextcontrollers = [];
class HomeworkPage extends StatelessWidget {
  final homeworkinfo = new ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
   //   onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.arrow_back_ios_sharp, color: Colors.blueAccent),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: homeworkinfo,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () {
                              homeworkinfo.value = !homeworkinfo.value;
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      homeworkinfo.value
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_right_outlined,
                                      color: secondarycolor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "Homework Info",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                homeworkinfo.value
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
                                              "Homework",
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              currenthomeworkinfo.exam,
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
                                              "${currenthomeworkinfo.classandsubject}",
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
                                itemCount: homeworkquestiondata.length,
                                //shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return homeworkquestiondata[index].questiontype ==
                                      "0"
                                      ? Column(
                                    children: [
                                      SubjectiveQuestion(
                                        questionnumber: index + 1,
                                      ),
                                      if (index ==
                                          homeworkquestiondata.length - 1)
                                        TextButton(
                                          onPressed: () async{
                                            int attemptstatus = 0;
                                            for(int i=0;i< homeworkquestiondata.length;i++){
                                              if(hwanswersdata[i].answer.toString() != ''){
                                                attemptstatus++;
                                              }
                                            }
                                            List<String>failedstatus=[];
                                            for(int i=0;i< homeworkquestiondata.length;i++){
                                              bool sucess = await submithomework(attemptstatus,homeworkquestiondata[i].question_id,homeworkquestiondata[i].questiontype,context);
                                              if(!sucess){
                                                failedstatus.add(homeworkquestiondata[i].question_id);
                                              }
                                            }
                                            print("status : $failedstatus");
                                            if(failedstatus.length==0){
                                              examtimeout = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => NewDashbBard(currentIndex: 0)),
                                              );
                                            }else{
                                              Flushbar(
                                                message: "Error while submitting the exam, Please Try again",
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
                                          child: Container(
                                              color: secondarycolor,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 15),
                                              child: Text(
                                                "Submit Homework",
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
                                          homeworkquestiondata.length - 1)
                                        TextButton(
                                          onPressed: () async{
                                            int attemptstatus = 0;
                                            for(int i=0;i< homeworkquestiondata.length;i++){
                                              if(hwanswersdata[i].answer.toString() != ''){
                                                attemptstatus++;
                                              }
                                            }
                                            List<String>failedstatus=[];
                                            for(int i=0;i< homeworkquestiondata.length;i++){
                                              bool sucess = await submithomework(attemptstatus,homeworkquestiondata[i].question_id,homeworkquestiondata[i].questiontype,context);
                                              if(!sucess){
                                                failedstatus.add(homeworkquestiondata[i].question_id);
                                              }
                                            }
                                            print("status : $failedstatus");
                                            if(failedstatus.length==0){
                                              examtimeout = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => NewDashbBard(currentIndex: 0)),
                                              );
                                            }else{
                                              Flushbar(
                                                message: "Error while submitting the exam, Please Try again",
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
                                          child: Container(
                                              color: secondarycolor,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 15),
                                              child: Text(
                                                "Submit Homework",
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
  }
}

int length =10;
int objectivequestion =3;
const defaultDuration = Duration(hours: 2, minutes: 30);
const defaultPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

class SubjectiveQuestion extends StatefulWidget {
  final int questionnumber;
  SubjectiveQuestion({this.questionnumber});

  @override
  _SubjectiveQuestionState createState() => _SubjectiveQuestionState();
}

class _SubjectiveQuestionState extends State<SubjectiveQuestion> {
  bool enablemathkeyboard = false;
  final showpickedfiles = new ValueNotifier(true);
  List<File> pickedfiles=[];
  List<String>pickedfilenames=[];
  @override
  Widget build(BuildContext context) {
    print("ikkada ${widget.questionnumber-1} : ${homeworkquestiondata[widget.questionnumber - 1].image.toString()}");
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
                    GestureDetector(
                      onTap: (){
                        print(homeworkquestiondata[widget.questionnumber].image.toString());
                        print( FileFormat.extension(homeworkquestiondata[widget.questionnumber].image.toString()));
                      },
                      child: Text(
                        "${widget.questionnumber}. ",
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(homeworkquestiondata[widget.questionnumber - 1].question != "null" || homeworkquestiondata[widget.questionnumber - 1].question != "")
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(
                              _parseHtmlString(homeworkquestiondata[widget.questionnumber - 1].question),
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        if(homeworkquestiondata[widget.questionnumber - 1].image.toString() != "")
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 1.4,
                              child:
                              FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".jpg"||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".png"||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".jpeg"||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".tif"||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".tiff"||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".gif" ||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".bmp"||
                                  FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".eps"
                                  ?
                              Image.network(
                                homeworkquestiondata[widget.questionnumber - 1].image,
                              )
                                  :
                              TextButton(
                                onPressed: (){
                                  launch(homeworkquestiondata[widget.questionnumber - 1].image.toString());
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
                homeworksubmission[widget.questionnumber - 1]
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
                homeworkquestiondata[widget.questionnumber - 1].marks.toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          if (homeworkquestiondata[widget.questionnumber - 1]
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
                  homeworkquestiondata[widget.questionnumber - 1]
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
                hwanswersdata[widget.questionnumber - 1] = homeworkanswer(
                  answer: val,
                  marks:
                  homeworkquestiondata[widget.questionnumber - 1].marks,
                  questionid: homeworkquestiondata[widget.questionnumber - 1]
                      .question_id,
                  questiontype:
                  homeworkquestiondata[widget.questionnumber - 1]
                      .questiontype,
                  negaivemarks:
                  homeworkquestiondata[widget.questionnumber - 1]
                      .negative_mark,
                  showresult: currenthomeworkinfo.showresult,
                  examid: currenthomeworkinfo.id,
                  studntexamid: currenthomeworkinfo.studnthomeworkid,
                  subid: currenthomeworkinfo.subid,
                  totalmarks: "${currenthomeworkinfo.totalmarks}",
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
                hwanswersdata[widget.questionnumber - 1] = homeworkanswer(
                  answer: expression,
                  marks:
                  homeworkquestiondata[widget.questionnumber - 1].marks,
                  questionid: homeworkquestiondata[widget.questionnumber - 1]
                      .question_id,
                  questiontype:
                  homeworkquestiondata[widget.questionnumber - 1]
                      .questiontype,
                  negaivemarks:
                  homeworkquestiondata[widget.questionnumber - 1]
                      .negative_mark,
                  showresult: currenthomeworkinfo.showresult,
                  examid: currenthomeworkinfo.id,
                  studntexamid: currenthomeworkinfo.studnthomeworkid,
                  subid: currenthomeworkinfo.subid,
                  totalmarks: "${currenthomeworkinfo.totalmarks}",
                );
              } catch (_) {
                expression = 'invalid input';
              }
              print('input expression: $value\n'
                  'converted expression: $expression');
            },
          ),

          ListView.builder(
            itemCount: Filescount(widget.questionnumber),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              print("subjective question ${widget.questionnumber} picked files length : ${hwanswersdata[widget.questionnumber - 1].filepaths.length}");
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
                      FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].toString()) == ".jpg" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".png" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".jpeg" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tif" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tiff" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".gif" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".bmp" ||
                          FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".eps"
                          ? Image.file(
                        hwanswersdata[widget.questionnumber - 1].filepaths[index],
                      ) : TextButton(
                        onPressed: () {
                          OpenFile.open(hwanswersdata[widget.questionnumber - 1].filepaths[index].path);
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
                onPressed: ()async {
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
                      hwanswersdata[widget.questionnumber - 1] = homeworkanswer(
                          answer: homeworkquestiondata[widget.questionnumber - 1].answer,
                          marks:
                          homeworkquestiondata[widget.questionnumber - 1].marks,
                          questionid: homeworkquestiondata[widget.questionnumber - 1]
                              .question_id,
                          questiontype:
                          homeworkquestiondata[widget.questionnumber - 1]
                              .questiontype,
                          negaivemarks:
                          homeworkquestiondata[widget.questionnumber - 1]
                              .negative_mark,
                          showresult: currenthomeworkinfo.showresult,
                          examid: currenthomeworkinfo.id,
                          studntexamid: currenthomeworkinfo.studnthomeworkid,
                          subid: currenthomeworkinfo.subid,
                          totalmarks: "${currenthomeworkinfo.totalmarks}",
                          filepaths: pickedfiles
                      );
                    }
                    setState(() {

                    });
                    print(picked.names);
                    print("length mowa : ${pickedfiles.length}");
                    //loading.value = true;
                    await uploadyouranswer(uploadanswer(
                        questionid: homeworkquestiondata[widget.questionnumber - 1].question_id,
                        subid: currenthomeworkinfo.subid,
                        examid: currenthomeworkinfo.id,
                        stundexamid: currenthomeworkinfo.studnthomeworkid,
                        type: homeworkquestiondata[widget.questionnumber - 1].questiontype,
                        studentfiles: pickedfiles
                    ));
                    //  loading.value = false;
                  }else{
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

                  bool status = await saveyouranswer(hwanswer(
                    marks: homeworkquestiondata[widget.questionnumber - 1].marks,
                    questiontype: "0",
                    examid: currenthomeworkinfo.id,
                    negaivemarks: homeworkquestiondata[widget.questionnumber - 1]
                        .negative_mark,
                    questionid:
                    homeworkquestiondata[widget.questionnumber - 1].question_id,
                    studntexamid: currenthomeworkinfo.studnthomeworkid,
                    subid: currenthomeworkinfo.subid,
                    totalmarks: "${currenthomeworkinfo.totalmarks}",
                    showresult: currenthomeworkinfo.showresult,
                    answer: hwanswersdata[widget.questionnumber - 1].answer,
                  ),context);
                  await uploadyouranswer(uploadanswer(
                      questionid: homeworkquestiondata[widget.questionnumber - 1].question_id,
                      subid: currenthomeworkinfo.subid,
                      examid: currenthomeworkinfo.id,
                      stundexamid: currenthomeworkinfo.studnthomeworkid,
                      type: homeworkquestiondata[widget.questionnumber - 1].questiontype,
                      studentfiles: pickedfiles
                  ));
                  if(status){
                    setState(() {
                      homeworksubmission[widget.questionnumber - 1] = true;
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

List<bool> homeworksubmission = [];

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
      homeworksubmission[widget.questionnumber - 1] = true;
    });
  }
  final showpickedfiles = new ValueNotifier(true);
  List<File> pickedfiles=[];
  List<String>pickedfilenames=[];
  @override
  Widget build(BuildContext context) {
    print("ikkada :${widget.questionnumber - 1} ${homeworkquestiondata[widget.questionnumber - 1].image.toString()}");
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
                      if(homeworkquestiondata[widget.questionnumber - 1].question != "null" || homeworkquestiondata[widget.questionnumber - 1].question != "")
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            _parseHtmlString(homeworkquestiondata[widget.questionnumber - 1].question),
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      if(homeworkquestiondata[widget.questionnumber - 1].image.toString() != "null" && homeworkquestiondata[widget.questionnumber - 1].image.toString() != "0")
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child:
                            FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".jpg"||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".png"||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".jpeg"||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".tif"||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".tiff"||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".gif" ||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".bmp"||
                                FileFormat.extension(homeworkquestiondata[widget.questionnumber - 1].image.toString())==".eps"
                                ?
                            Image.network(
                              homeworkquestiondata[widget.questionnumber - 1].image,
                            )
                                :TextButton(
                              onPressed: (){
                                launch(homeworkquestiondata[widget.questionnumber - 1].image.toString());
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
              homeworksubmission[widget.questionnumber - 1]
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
                // homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 10
                //     ? 270+45+45+45+45
                //     :homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 9
                //     ? 270+45+45+45
                //     :homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 8
                //     ? 270+45+45
                //     :homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 7
                //     ? 270+45
                //     :homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 6
                //     ? 270
                //     :homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 5
                //     ? 225
                //     : homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 4
                //     ? 180
                //     : homeworkquestiondata[widget.questionnumber - 1].optionsdata.length == 3
                //     ? 135
                //     : 90,
                child: ListView.builder(
                  itemCount: homeworkquestiondata[widget.questionnumber - 1].optionsdata.length,
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
                          children: [
                            Radio(
                                value: index + 1,
                                groupValue: selectedRadio,
                                activeColor: primarycolor,
                                onChanged: (newvalue) async {
                                  setselectedradio(newvalue);
                                  hwanswersdata[widget.questionnumber - 1] =
                                      homeworkanswer(
                                        answer: "$newvalue",
                                        marks: homeworkquestiondata[widget.questionnumber - 1].marks,
                                        questionid: homeworkquestiondata[widget.questionnumber - 1].question_id,
                                        questiontype: homeworkquestiondata[widget.questionnumber - 1].questiontype,
                                        negaivemarks: homeworkquestiondata[widget.questionnumber - 1].negative_mark,
                                        showresult: currenthomeworkinfo.showresult,
                                        examid: currenthomeworkinfo.id,
                                        studntexamid: currenthomeworkinfo.studnthomeworkid,
                                        subid: currenthomeworkinfo.subid,
                                        totalmarks: "${currenthomeworkinfo.totalmarks}",
                                      );
                                  print(homeworkquestiondata[widget.questionnumber - 1].optionsdata[int.parse(hwanswersdata[widget.questionnumber - 1].answer)-1].option);
                                  await saveyouranswer(hwanswer(
                                    marks: homeworkquestiondata[widget.questionnumber - 1].marks,
                                    questiontype: "0",
                                    examid: currenthomeworkinfo.id,
                                    negaivemarks: homeworkquestiondata[widget.questionnumber - 1]
                                        .negative_mark,
                                    questionid:
                                    homeworkquestiondata[widget.questionnumber - 1].question_id,
                                    studntexamid: currenthomeworkinfo.studnthomeworkid,
                                    subid: currenthomeworkinfo.subid,
                                    totalmarks: "${currenthomeworkinfo.totalmarks}",
                                    showresult: currenthomeworkinfo.showresult,
                                    answer: homeworkquestiondata[widget.questionnumber - 1].optionsdata[int.parse(hwanswersdata[widget.questionnumber - 1].answer)-1].option,
                                  ),context);
                                }),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(homeworkquestiondata[widget.questionnumber - 1].optionsdata[index].option != "")
                                  Text(
                                    homeworkquestiondata[widget.questionnumber - 1].optionsdata[index].option,
                                    style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
                                  ),
                                if(homeworkquestiondata[widget.questionnumber - 1].optionsdata[index].opt_image.toString() !=  "0")
                                  SizedBox(
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1.4,
                                      child:
                                      FileFormat.extension(
                                          homeworkquestiondata[widget.questionnumber -
                                              1].optionsdata[index].opt_image
                                              .toString()) == ".jpg" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".png" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".jpeg" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".tif" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".tiff" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".gif" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".bmp" ||
                                          FileFormat.extension(
                                              homeworkquestiondata[widget
                                                  .questionnumber - 1]
                                                  .optionsdata[index].opt_image
                                                  .toString()) == ".eps"
                                          ? Image.network(
                                        //  networkimage,
                                        homeworkquestiondata[widget.questionnumber - 1]
                                            .optionsdata[index].opt_image,
                                      ) : TextButton(
                                        onPressed: () {
                                          launch(homeworkquestiondata[widget
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
                        ),
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
              homeworkquestiondata[widget.questionnumber - 1].marks.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        if (homeworkquestiondata[widget.questionnumber - 1]
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
                homeworkquestiondata[widget.questionnumber - 1]
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
            print("subjective question ${widget.questionnumber} picked files length : ${hwanswersdata[widget.questionnumber - 1].filepaths.length}");
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
                    FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].toString()) == ".jpg" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".png" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".jpeg" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tif" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".tiff" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".gif" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".bmp" ||
                        FileFormat.extension(hwanswersdata[widget.questionnumber - 1].filepaths[index].path.toString()) == ".eps"
                        ? Image.file(
                      hwanswersdata[widget.questionnumber - 1].filepaths[index],
                    ) : TextButton(
                      onPressed: () {
                        OpenFile.open(hwanswersdata[widget.questionnumber - 1].filepaths[index].path);
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
          onPressed: ()async {
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
                hwanswersdata[widget.questionnumber - 1] = homeworkanswer(
                    answer: homeworkquestiondata[widget.questionnumber - 1].answer,
                    marks:
                    homeworkquestiondata[widget.questionnumber - 1].marks,
                    questionid: homeworkquestiondata[widget.questionnumber - 1]
                        .question_id,
                    questiontype:
                    homeworkquestiondata[widget.questionnumber - 1]
                        .questiontype,
                    negaivemarks:
                    homeworkquestiondata[widget.questionnumber - 1]
                        .negative_mark,
                    showresult: currenthomeworkinfo.showresult,
                    examid: currenthomeworkinfo.id,
                    studntexamid: currenthomeworkinfo.studnthomeworkid,
                    subid: currenthomeworkinfo.subid,
                    totalmarks: "${currenthomeworkinfo.totalmarks}",
                    filepaths: pickedfiles
                );
              }
              setState(() {

              });
              print(picked.names);
              print("length mowa : ${pickedfiles.length}");
              //loading.value = true;
              await uploadyouranswer(uploadanswer(
                  questionid: homeworkquestiondata[widget.questionnumber - 1].question_id,
                  subid: currenthomeworkinfo.subid,
                  examid: currenthomeworkinfo.id,
                  stundexamid: currenthomeworkinfo.studnthomeworkid,
                  type: homeworkquestiondata[widget.questionnumber - 1].questiontype,
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
        ),
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
  }
}
String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : ${parsedString}");
  return parsedString;
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
int Filescount( questionnumber)  {
  try {
    int a = hwanswersdata[questionnumber - 1].filepaths.length;
    return a;
  } catch (e) {
    print(e);
    return 0;
  }
}