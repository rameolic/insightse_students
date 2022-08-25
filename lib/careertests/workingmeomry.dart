import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Contsants.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'careertestapi.dart';
import '../ProgressHUD.dart';
import 'package:flushbar/flushbar.dart';
import 'package:html/parser.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'examdone.dart';
import 'package:html/dom.dart' as dom;
import 'package:pinput/pinput.dart';

String answerpin;
String remainingtime;
String selectedoption;
var selectedRadio;

final loading = new ValueNotifier(false);
final starttimer = new ValueNotifier(false);
final displaypin = new ValueNotifier(false);

class WorkingMemory extends StatelessWidget {
  int index;
  int duration;
  WorkingMemory({@required this.index, @required this.duration});
  ValueNotifier<String> question =
      new ValueNotifier(questions[questionnumber - 1].title);
  ValueNotifier<String> questiondata = new ValueNotifier(
      "${questions[questionnumber - 1].question.toString()[0]}");
  var defaultDuration;
  _appBar(context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 0,
      backgroundColor: Colors.white,
      // leading: GestureDetector(
      //   onTap: () {
      //     Navigator.pop(context);
      //   },
      //   child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
      // ),
      title: Text(
        testlist[index].title,
        //"Questions",
        style: TextStyle(color: secondarycolor),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (duration > 0) {
      defaultDuration = Duration(minutes: duration);
    }
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) {
          return WillPopScope(
            onWillPop: () async => false,
            child: ValueListenableBuilder<String>(
                valueListenable: question,
                builder: (context, value, child) {
                  return ProgressHUD(
                      inAsyncCall: loading.value,
                      opacity: 0.3,
                      color: secondarycolor,
                      child: Scaffold(
                          backgroundColor: Colors.white,
                          appBar: _appBar(context),
                          body: ValueListenableBuilder<bool>(
                              valueListenable: starttimer,
                              builder: (context, value, child) {
                                return Column(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            duration > 0 && starttimer.value
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 30,
                                                        child: SlideCountdown(
                                                          onDurationChanged:
                                                              (val) {
                                                            remainingtime = val
                                                                .inSeconds
                                                                .toString();
                                                          },
                                                          onDone: () async {
                                                            if (questionnumber <
                                                                questions
                                                                    .length) {
                                                              selectedoption =
                                                                  null;
                                                              selectedRadio =
                                                                  null;
                                                              starttimer.value =
                                                                  false;
                                                              displaypin.value =
                                                                  false;
                                                              questionnumber =
                                                                  questionnumber +
                                                                      1;
                                                              question.value =
                                                                  questions[
                                                                          questionnumber -
                                                                              1]
                                                                      .title;
                                                            } else {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (displaypincontext) =>
                                                                              DoneMessage()));
                                                            }
                                                          },
                                                          duration:
                                                              defaultDuration,
                                                          separatorType:
                                                              SeparatorType
                                                                  .title,
                                                          padding:
                                                              defaultPadding,
                                                          slideDirection:
                                                              SlideDirection.up,
                                                          fade: true,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  secondarycolor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          icon: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: Icon(
                                                              Icons.alarm,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(height: 40),
                                            if (duration > 0 &&
                                                starttimer.value)
                                              SizedBox(
                                                height: 10,
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                                  decoration: BoxDecoration(
                                                      color: borderyellow,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Text(
                                                    "Question : $questionnumber",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "Total Questions : "),
                                                        Text(
                                                          questions.length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "Remaining Questions : "),
                                                        Text(
                                                          (questions.length -
                                                                  questionnumber)
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            HtmlWidget(
                                              question.value,
                                              webViewJs: true,
                                              webView: true,
                                              webViewMediaPlaybackAlwaysAllow:
                                                  true,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ValueListenableBuilder<String>(
                                          valueListenable: questiondata,
                                          builder: (context, value, child) {
                                            return ValueListenableBuilder<bool>(
                                                valueListenable: displaypin,
                                                builder:
                                                    (context, value, child) {
                                                  return Column(
                                                    children: [
                                                      if (!starttimer.value)
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              starttimer.value =
                                                                  true;
                                                              print(
                                                                  "length : ${questions[questionnumber - 1].question.length}");
                                                              for (int i = 0;
                                                                  i <
                                                                      questions[questionnumber - 1]
                                                                              .question
                                                                              .length +
                                                                          1;
                                                                  i++) {
                                                                print("i : $i");
                                                                if (i == 0) {
                                                                  questiondata
                                                                      .value = questions[
                                                                          questionnumber -
                                                                              1]
                                                                      .question[i];
                                                                } else if (i +
                                                                        1 ==
                                                                    questions[questionnumber -
                                                                                1]
                                                                            .question
                                                                            .length +
                                                                        1) {
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              2),
                                                                      () {
                                                                    // questiondata.value = questions[questionnumber - 1].question[i];
                                                                  });
                                                                } else {
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              2),
                                                                      () {
                                                                    questiondata
                                                                        .value = questions[
                                                                            questionnumber -
                                                                                1]
                                                                        .question[i];
                                                                  });
                                                                }
                                                              }
                                                              displaypin.value =
                                                                  true;
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          20),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                                color:
                                                                    secondarycolor,
                                                              ),
                                                              child: Text(
                                                                "Show Test",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      if (starttimer.value &&
                                                          !displaypin.value)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15.0,
                                                                  bottom: 15),
                                                          child: Text(
                                                            questiondata.value,
                                                            style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      if (displaypin.value)
                                                        answertext(
                                                          input: questions[
                                                                  questionnumber -
                                                                      1]
                                                              .question
                                                              .toString()
                                                              .length,
                                                        ),
                                                      if (displaypin.value)
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              print(
                                                                  "selected option : $selectedoption");
                                                              if (answerpin !=
                                                                  null) {
                                                                Saveanswer data = Saveanswer(
                                                                    quizid: testlist[
                                                                            index]
                                                                        .quizid,
                                                                    testnumber:
                                                                        testlist[index]
                                                                            .testnumber,
                                                                    serialnumber:
                                                                        questions[questionnumber -
                                                                                1]
                                                                            .serialnumber,
                                                                    answer:
                                                                        answerpin,
                                                                    questionid:
                                                                        questions[questionnumber -
                                                                                1]
                                                                            .id,
                                                                    time:
                                                                        "" // remainingtime
                                                                    );
                                                                loading.value =
                                                                    true;
                                                                await savecareeranswer(
                                                                    data,
                                                                    context);
                                                                loading.value =
                                                                    false;
                                                                if (questionnumber <
                                                                    questions
                                                                        .length) {
                                                                  starttimer
                                                                          .value =
                                                                      false;
                                                                  displaypin
                                                                          .value =
                                                                      false;
                                                                  questionnumber =
                                                                      questionnumber +
                                                                          1;
                                                                  question.value =
                                                                      questions[questionnumber -
                                                                              1]
                                                                          .title;
                                                                } else {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              DoneMessage()));
                                                                }
                                                              } else {
                                                                Flushbar(
                                                                  message:
                                                                      "Answer cannot be empty",
                                                                  icon: Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 28.0,
                                                                    color:
                                                                        secondarycolor,
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              4),
                                                                  leftBarIndicatorColor:
                                                                      secondarycolor,
                                                                )..show(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          10,
                                                                          20,
                                                                          10),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      borderyellow,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Text(
                                                                'Save and Continue',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                });
                                          }),
                                    ),
                                    // Expanded(
                                    //   child: SingleChildScrollView(
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.only(
                                    //           left: 10.0, right: 10),
                                    //       child: Column(
                                    //         children: [
                                    //           options(),
                                    //           SizedBox(
                                    //             height: 10,
                                    //           ),
                                    //           Align(
                                    //             alignment: Alignment.bottomRight,
                                    //             child: GestureDetector(
                                    //               onTap: () async {
                                    //                 print(
                                    //                     "selected option : $selectedoption");
                                    //                 if (selectedoption != null) {
                                    //                   Saveanswer data = Saveanswer(
                                    //                       quizid:
                                    //                       testlist[index].quizid,
                                    //                       testnumber: testlist[index]
                                    //                           .testnumber,
                                    //                       serialnumber: questions[
                                    //                       questionnumber - 1]
                                    //                           .serialnumber,
                                    //                       answer: selectedoption,
                                    //                       questionid: questions[
                                    //                       questionnumber - 1]
                                    //                           .id,
                                    //                       time: "" // remainingtime
                                    //                   );
                                    //                   loading.value = true;
                                    //                   await savecareeranswer(
                                    //                       data, context);
                                    //                   loading.value = false;
                                    //                   if (questionnumber <
                                    //                       questions.length) {
                                    //                     selectedoption = null;
                                    //                     selectedRadio = null;
                                    //                     questionnumber =
                                    //                         questionnumber + 1;
                                    //                     print(
                                    //                         "title : ${questions[questionnumber - 1].title}");
                                    //                     question.value = questions[
                                    //                     questionnumber - 1]
                                    //                         .title;
                                    //                   } else {
                                    //                     Navigator.push(
                                    //                         context,
                                    //                         MaterialPageRoute(
                                    //                             builder: (context) =>
                                    //                                 DoneMessage()));
                                    //                   }
                                    //                 } else {
                                    //                   Flushbar(
                                    //                     message:
                                    //                     "Please Choose an option",
                                    //                     icon: Icon(
                                    //                       Icons.info_outline,
                                    //                       size: 28.0,
                                    //                       color: secondarycolor,
                                    //                     ),
                                    //                     duration: Duration(seconds: 4),
                                    //                     leftBarIndicatorColor:
                                    //                     secondarycolor,
                                    //                   )..show(context);
                                    //                 }
                                    //               },
                                    //               child: Container(
                                    //                 padding: EdgeInsets.fromLTRB(
                                    //                     20, 10, 20, 10),
                                    //                 margin: EdgeInsets.only(bottom: 50),
                                    //                 decoration: BoxDecoration(
                                    //                     color: borderyellow,
                                    //                     borderRadius: BorderRadius.all(
                                    //                         Radius.circular(10))),
                                    //                 child: Text(
                                    //                   'Save and Continue',
                                    //                   style: TextStyle(fontSize: 15),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                );
                              })));
                }),
          );
        });
  }
}

const defaultPadding = EdgeInsets.symmetric(horizontal: 5, vertical: 5);

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : ${parsedString}");
  return parsedString;
}

class LandingPage extends StatelessWidget {
  int index;
  int duration;
  LandingPage({@required this.index, @required this.duration});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 0,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
        // ),
        title: Text(
          "Working Memory-Digital Span Tests",
          //"Questions",
          style: TextStyle(color: secondarycolor),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "Instructions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "At the beginning of each question, when you are ready, press the Show Test button. Some numbers will be displayed on the screen one by one like a flash message. After all the numbers are shown, you are expected to enter the shown digits in the same order as it were displayed before.",
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkingMemory(
                            index: index,
                            duration: (testlist[index].timelimit /
                                    testlist[index].totalquestion)
                                .round(),
                          )),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: secondarycolor,
                ),
                child: Text(
                  "Start Test",
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}

bool isStopped = false; //global

TextEditingController textEditingController = TextEditingController();

class answertext extends StatelessWidget {
  int input;
  answertext({this.input});
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: secondarycolor, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: secondarycolor.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: secondarycolor, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  ).copyDecorationWith(
    border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  );

  final submittedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: secondarycolor, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  ).copyWith(
    decoration: PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    ).decoration.copyWith(
          color: Color.fromRGBO(234, 239, 243, 1),
        ),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 25),
      child: Pinput(
        length: input,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        keyboardType: TextInputType.text,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        onCompleted: (pin) {
          answerpin = pin;
        },
      ),
    );
  }
}

String currentText;
