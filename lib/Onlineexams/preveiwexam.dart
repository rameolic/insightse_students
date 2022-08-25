import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import 'exampage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Contsants.dart';
import 'examsapi.dart';
import 'package:html/parser.dart';
import 'package:open_file/open_file.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:path/path.dart' as FileFormat;
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';
import '../more.dart';
import '../ProgressHUD.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'preveiwexam.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import '../newdashboardui.dart';

class PreviewExam extends StatelessWidget {

  final loading = new ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CupertinoColors.white,
        title: Text(
          "Preview Exam",
          style: TextStyle(color: secondarycolor),
        ),
        leading: examtimeout ? SizedBox() :GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor,
        ),
      ),
        centerTitle: true,
      ),
      body: Container(
        color: CupertinoColors.white,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: examquestiondata.length,
          //shrinkWrap: true,
          itemBuilder: (context, index) {
            print("index :$index");
            print( examquestiondata.length - 1 );
            return examquestiondata[index].questiontype ==
                "0"
                ? Column(
                    children: [
                      PreveiwSubjective(
                        questionnumber: index + 1,

                      ),
                      if (index == examquestiondata.length - 1)
                        TextButton(
                          onPressed: ()async {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    StatefulBuilder(builder: (context, setState) {
                                      return ValueListenableBuilder<bool>(
                                          valueListenable: loading,
                                          builder: (context, value, child) {
                                            return ProgressHUD(
                                        inAsyncCall: false,
                                        opacity: 0.3,
                                        child: AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          content: Builder(
                                            builder: (context) {
                                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                              return SizedBox(
                                                height: 130,
                                                width: MediaQuery.of(context).size.width/1.3,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Alert',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,//secondarycolor.withOpacity(0.5),
                                                        thickness: 0.8,
                                                      ),SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text("Do you want to Submit the Exam.",style: TextStyle(color: Colors.black,fontSize: 20),textAlign: TextAlign.center,),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          TextButton(onPressed: ()async{
                                                            if(!examtimeout){
                                                              loading.value = true;
                                                              int attemptstatus = 0;
                                                              for(int i=0;i< examquestiondata.length;i++){
                                                                if(answersdata[i].answer.toString() != ''){
                                                                  attemptstatus++;
                                                                }
                                                              }
                                                              List<String>failedstatus=[];
                                                              for(int i=0;i< examquestiondata.length;i++){
                                                                bool sucess = await submitexam(attemptstatus,examquestiondata[i].question_id,examquestiondata[i].questiontype,context);
                                                                if(!sucess){
                                                                  failedstatus.add(examquestiondata[i].question_id);
                                                                }
                                                              }
                                                              loading.value = false;
                                                              if(failedstatus.length==0){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => NewDashbBard(currentIndex: 0)),
                                                                );
                                                              }{
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
                                                            }{
                                                              if(!examsubmitted){
                                                                loading.value = true;
                                                                int attemptstatus = 0;
                                                                for(int i=0;i< examquestiondata.length;i++){
                                                                  if(answersdata[i].answer.toString() != ''){
                                                                    attemptstatus++;
                                                                  }
                                                                }
                                                                List<String>failedstatus=[];
                                                                for(int i=0;i< examquestiondata.length;i++){
                                                                  bool sucess = await submitexam(attemptstatus,examquestiondata[i].question_id,examquestiondata[i].questiontype,context);
                                                                  if(!sucess){
                                                                    failedstatus.add(examquestiondata[i].question_id);
                                                                  }
                                                                }
                                                                loading.value = false;
                                                                if(failedstatus.length==0){
                                                                  Flushbar(
                                                                    message: "Exam Submission successful",
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
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => NewDashbBard(currentIndex: 0)),
                                                                  );
                                                                }else
                                                                {
                                                                  Flushbar(
                                                                    message: "Error while submitting the exam, Please Try again failed status count : ${failedstatus.length}",
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

                                                              }else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => NewDashbBard(currentIndex: 0)),
                                                                );
                                                              }
                                                            }

                                                          }, child: Container(
                                                              color: secondarycolor,
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 10, horizontal: 15),
                                                              child: Text("Submit Exam",
                                                                style: TextStyle(color: Colors.white),
                                                              )),),
                                                          TextButton(onPressed: (){
                                                            Navigator.pop(context);
                                                          }, child: Container(
                                                              color: borderyellow,
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 10, horizontal: 15),
                                                              child: Text("Cancel",
                                                                style: TextStyle(color: secondarycolor),
                                                              )),),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
            });
                                    }));
                          },
                          child: Container(
                              color: secondarycolor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Text(
                                !examtimeout ? "Submit Exam" : "finish Exam",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                    ],
                  )
                : Column(
                    children: [
                      PreveiwObjective(
                        questionnumber: index + 1,
                      ),
                      if (index == examquestiondata.length - 1)
                        TextButton(
                          onPressed: ()async {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    StatefulBuilder(builder: (context, setState) {
                                      return ProgressHUD(
                                        inAsyncCall: false,
                                        opacity: 0.3,
                                        child: AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          content: Builder(
                                            builder: (context) {
                                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                              return SizedBox(
                                                width: MediaQuery.of(context).size.width/1.3,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Alert',
                                                        style: TextStyle(
                                                            color: secondarycolor,
                                                            fontSize: 18),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,//secondarycolor.withOpacity(0.5),
                                                        thickness: 0.8,
                                                      ),SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text("Do you want to Submit the Exam.",style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          TextButton(onPressed: ()async{
                                                            if(!examtimeout){
                                                              int attemptstatus = 0;
                                                              for(int i=0;i< examquestiondata.length;i++){
                                                                if(answersdata[i].answer.toString() != ''){
                                                                  attemptstatus++;
                                                                }
                                                              }
                                                              List<String>failedstatus=[];
                                                              for(int i=0;i< examquestiondata.length;i++){
                                                                bool sucess = await submitexam(attemptstatus,examquestiondata[i].question_id,examquestiondata[i].questiontype,context);
                                                                if(!sucess){
                                                                  failedstatus.add(examquestiondata[i].question_id);
                                                                }
                                                              }
                                                              if(failedstatus.length==0){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => NewDashbBard(currentIndex: 0)),
                                                                );
                                                              }{
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
                                                            }{
                                                              if(!examsubmitted){
                                                                int attemptstatus = 0;
                                                                for(int i=0;i< examquestiondata.length;i++){
                                                                  if(answersdata[i].answer.toString() != ''){
                                                                    attemptstatus++;
                                                                  }
                                                                }
                                                                List<String>failedstatus=[];
                                                                for(int i=0;i< examquestiondata.length;i++){
                                                                  bool sucess = await submitexam(attemptstatus,examquestiondata[i].question_id,examquestiondata[i].questiontype,context);
                                                                  if(!sucess){
                                                                    failedstatus.add(examquestiondata[i].question_id);
                                                                  }
                                                                }
                                                                if(failedstatus.length==0){
                                                                  Flushbar(
                                                                    message: "Exam Submission successful",
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
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => NewDashbBard(currentIndex: 0)),
                                                                  );
                                                                }else
                                                                {
                                                                  Flushbar(
                                                                    message: "Error while submitting the exam, Please Try again failed status count : ${failedstatus.length}",
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

                                                              }else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => NewDashbBard(currentIndex: 0)),
                                                                );
                                                              }
                                                            }

                                                          }, child: Container(
                                                              color: secondarycolor,
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 10, horizontal: 15),
                                                              child: Text("Submit Exam",
                                                                style: TextStyle(color: Colors.white),
                                                              )),),
                                                          TextButton(onPressed: (){
                                                            Navigator.pop(context);
                                                          }, child: Container(
                                                              color: borderyellow,
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 10, horizontal: 15),
                                                              child: Text("Cancel",
                                                                style: TextStyle(color: secondarycolor),
                                                              )),),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }));
                          },
                          child: Container(
                              color: secondarycolor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Text(
                                !examtimeout ? "Submit Exam" : "finish Exam",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class PreveiwSubjective extends StatelessWidget {
  bool filesavaiable = false;
  int questionnumber;
  PreveiwSubjective({this.questionnumber});
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =new TextEditingController(text: answersdata[questionnumber - 1].answer);
    try{
      print(answersdata[questionnumber - 1].filepaths.length > 0);
      filesavaiable = true;
    }catch(e){
      filesavaiable = false;
      print(e);
    }
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   border: Border.all(color: secondarycolor.withOpacity(0.3))
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$questionnumber. ",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(examquestiondata[questionnumber - 1].question != "null" || examquestiondata[questionnumber - 1].question != "")
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: Text(
                        _parseHtmlString(examquestiondata[questionnumber - 1].question),
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  if(examquestiondata[questionnumber - 1].image.toString() != "0")
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child:
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".jpg"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".png"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".jpeg"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".tif"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".tiff"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".gif" ||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".bmp"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".eps"
                            ? Image.network(
                          //  networkimage,
                          examquestiondata[questionnumber - 1].image,
                        ):TextButton(
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
          Theme(
            data: ThemeData(
              primarySwatch: Colors.teal,
            ),
            child: TextFormField(
              readOnly: true,
              controller: _controller,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.only(left:10),
                focusColor: primarycolor,
                hintText: "Type your answer here..",
                hintStyle: TextStyle(
                  color: grey,
                  fontSize: 16.0,
                ),
              ),
              maxLines: null,
            ),
          ),

          if(answersdata[questionnumber - 1].filepaths!=null)
            ListView.builder(
              itemCount: answersdata[questionnumber - 1].filepaths.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
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
                        FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].toString()) == ".jpg" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".png" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".jpeg" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".tif" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".tiff" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".gif" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".bmp" ||
                            FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString()) == ".eps"
                            ? Image.file(
                          answersdata[questionnumber - 1].filepaths[index],
                        ) : TextButton(
                          onPressed: () {
                            print("file format: ${FileFormat.extension(answersdata[questionnumber - 1].filepaths[index].path.toString())}" == ".jpg");
                            print(answersdata[questionnumber - 1].filepaths[index].path.toString());
                            OpenFile.open(answersdata[questionnumber - 1].filepaths[index].path);
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
        ],
      ),
    );
  }
}

class PreveiwObjective extends StatelessWidget {
  final int questionnumber;bool filesavaiable = false;
  PreveiwObjective({this.questionnumber});
  int selectedRadio;
  @override
  Widget build(BuildContext context) {
    try{
      print(answersdata[questionnumber - 1].filepaths.length > 0);
      filesavaiable = true;
    }catch(e){
      filesavaiable = false;
      print(e);
    }
    print("radio : ${answersdata[questionnumber - 1].answer}");
    selectedRadio  =  answersdata[questionnumber - 1].answer.toString()!= "null"? int.parse(answersdata[questionnumber - 1].answer):null;
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$questionnumber. ",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(examquestiondata[questionnumber - 1].question != "null" || examquestiondata[questionnumber - 1].question != "")
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: Text(
                        _parseHtmlString(examquestiondata[questionnumber - 1].question),
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  if(examquestiondata[questionnumber - 1].image.toString() != "0")
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child:
                        FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".jpg"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".png"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".jpeg"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".tif"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".tiff"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".gif" ||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".bmp"||
                            FileFormat.extension(examquestiondata[questionnumber - 1].image.toString())==".eps"
                            ? Image.network(
                          //  networkimage,
                          examquestiondata[questionnumber - 1].image,
                        ):TextButton(
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
                  // examquestiondata[questionnumber - 1].optionsdata.length == 10
                  //     ? 270+45+45+45+45
                  //     :examquestiondata[questionnumber - 1].optionsdata.length == 9
                  //     ? 270+45+45+45
                  //     :examquestiondata[questionnumber - 1].optionsdata.length == 8
                  //     ? 270+45+45
                  //     :examquestiondata[questionnumber - 1].optionsdata.length == 7
                  //     ? 270+45
                  //     :examquestiondata[questionnumber - 1].optionsdata.length == 6
                  //     ? 270
                  //     :examquestiondata[questionnumber - 1].optionsdata.length == 5
                  //     ? 225
                  //     : examquestiondata[questionnumber - 1].optionsdata.length == 4
                  //     ? 180
                  //     : examquestiondata[questionnumber - 1].optionsdata.length == 3
                  //     ? 135
                  //     : 90,
                  child: ListView.builder(
                    itemCount: examquestiondata[questionnumber - 1].optionsdata.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Radio(
                              value: index + 1,
                              groupValue: selectedRadio,
                              activeColor: primarycolor,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(examquestiondata[questionnumber - 1].optionsdata[index].option != "")
                                Text(
                                  examquestiondata[questionnumber - 1].optionsdata[index].option,
                                  style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
                                ),
                              if(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString() != "0")
                                SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 1.4,
                                    child:
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".jpg"||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".png"||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".jpeg"||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".tif"||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".tiff"||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".gif" ||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".bmp"||
                                        FileFormat.extension(examquestiondata[questionnumber - 1].optionsdata[index].opt_image.toString())==".eps"
                                        ? Image.network(
                                      //  networkimage,
                                      examquestiondata[questionnumber - 1].optionsdata[index].opt_image,
                                    ):TextButton(
                                      onPressed: (){
                                        launch(examquestiondata[questionnumber - 1].optionsdata[index].opt_image);
                                      },
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: grey,
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                            child: Text("Check Attachment",style: TextStyle(color: Colors.white),),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
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

          if(filesavaiable && answersdata[questionnumber - 1].filepaths.length > 0)
            ListView.builder(
              itemCount: answersdata[questionnumber - 1].filepaths.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Text("uploaded file: ${index + 1}"),
                    ),
                    SizedBox(
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width / 1.4,
                        child:
                        FileFormat.extension(
                            answersdata[questionnumber - 1].filepaths[index]
                                .toString()) == ".jpg" ||
                            FileFormat.extension(
                                answersdata[questionnumber - 1].filepaths[index]
                                    .path.toString()) == ".png" ||
                            FileFormat.extension(
                                answersdata[questionnumber - 1].filepaths[index]
                                    .path.toString()) == ".jpeg" ||
                            FileFormat.extension(answersdata[questionnumber - 1]
                                .filepaths[index].path.toString()) == ".tif" ||
                            FileFormat.extension(answersdata[questionnumber - 1]
                                .filepaths[index].path.toString()) == ".tiff" ||
                            FileFormat.extension(answersdata[questionnumber - 1]
                                .filepaths[index].path.toString()) == ".gif" ||
                            FileFormat.extension(answersdata[questionnumber - 1]
                                .filepaths[index].path.toString()) == ".bmp" ||
                            FileFormat.extension(answersdata[questionnumber - 1]
                                .filepaths[index].path.toString()) == ".eps"
                            ? Image.file(
                          answersdata[questionnumber - 1].filepaths[index],
                        ) : TextButton(
                          onPressed: () {
                            print("file format: ${FileFormat.extension(
                                answersdata[questionnumber - 1].filepaths[index]
                                    .path.toString())}" == ".jpg");
                            print(
                                answersdata[questionnumber - 1].filepaths[index]
                                    .path.toString());
                            OpenFile.open(
                                answersdata[questionnumber - 1].filepaths[index]
                                    .path);
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
        ],
      ),
    );
  }
}
String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : $parsedString");
  return parsedString;
}