import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'careertestapi.dart';
import '../ProgressHUD.dart';
import 'package:flushbar/flushbar.dart';
import 'package:html/parser.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'examdone.dart';
import 'package:html/dom.dart' as dom;

String remainingtime;
String selectedoption;
var selectedRadio;

class CareerQuestionUI extends StatelessWidget {
  int index;
  int duration;
  CareerQuestionUI({@required this.index, @required this.duration});
  final loading = new ValueNotifier(false);
  ValueNotifier<String> question =
  new ValueNotifier(questions[questionnumber - 1].title);
  var defaultDuration;
  _appBar(context) {
    return AppBar(
      elevation: 0,
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
                        body: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (duration > 0)
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SlideCountdown(
                                            onDurationChanged: (val) {
                                              remainingtime = val.inSeconds.toString();
                                            },
                                            onDone: () async {
                                              if (questionnumber < questions.length) {
                                                selectedoption = null;
                                                selectedRadio = null;
                                                questionnumber = questionnumber + 1;
                                                print("title : ${questions[questionnumber - 1].title}");
                                                question.value = questions[questionnumber - 1].title;
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DoneMessage()));
                                              }
                                            },
                                            duration: defaultDuration,
                                            separatorType: SeparatorType.title,
                                            padding: defaultPadding,
                                            slideDirection: SlideDirection.up,
                                            fade: true,
                                            decoration: BoxDecoration(
                                                color: secondarycolor,
                                                borderRadius:
                                                BorderRadius.circular(8)),
                                            icon: Padding(
                                              padding:
                                              EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.alarm,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (duration > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          decoration: BoxDecoration(
                                              color: borderyellow,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Text(
                                            "Question : $questionnumber",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Total Questions : "),
                                                Text(
                                                  questions.length.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Remaining Questions : "),
                                                Text(
                                                  (questions.length -
                                                      questionnumber)
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold),
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
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: HtmlWidget(
                                        question.value,
                                        webViewJs: true,
                                        webView: true,
                                        webViewMediaPlaybackAlwaysAllow: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Column(
                                    children: [
                                      options(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            print(
                                                "selected option : $selectedoption");
                                            if (selectedoption != null) {
                                              Saveanswer data = Saveanswer(
                                                  quizid:
                                                  testlist[index].quizid,
                                                  testnumber: testlist[index]
                                                      .testnumber,
                                                  serialnumber: questions[
                                                  questionnumber - 1]
                                                      .serialnumber,
                                                  answer: selectedoption,
                                                  questionid: questions[
                                                  questionnumber - 1]
                                                      .id,
                                                  time: "" // remainingtime
                                              );
                                              loading.value = true;
                                              await savecareeranswer(
                                                  data, context);
                                              loading.value = false;
                                              if (questionnumber <
                                                  questions.length) {
                                                selectedoption = null;
                                                selectedRadio = null;
                                                questionnumber =
                                                    questionnumber + 1;
                                                print(
                                                    "title : ${questions[questionnumber - 1].title}");
                                                question.value = questions[
                                                questionnumber - 1]
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
                                                "Please Choose an option",
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  size: 28.0,
                                                  color: secondarycolor,
                                                ),
                                                duration: Duration(seconds: 4),
                                                leftBarIndicatorColor:
                                                secondarycolor,
                                              )..show(context);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            margin: EdgeInsets.only(bottom: 50),
                                            decoration: BoxDecoration(
                                                color: borderyellow,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Text(
                                              'Save and Continue',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                }),
          );
        });
  }
}

class options extends StatefulWidget {
  @override
  State<options> createState() => _optionsState();
}

class _optionsState extends State<options> {
  setselectedradio(int newval) {
    print("id : ${questions[questionnumber - 1].options[newval].id}");
    selectedoption = questions[questionnumber - 1].options[newval].id;
    setState(() {
      selectedRadio = newval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions[questionnumber - 1].options.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        print("Options mowa : ${questions[questionnumber - 1]
            .options[index].optiondata}");
        String option = questions[questionnumber - 1]
        .options[index].optiondata;
        print(option + " ${option.length}");
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                  value: index,
                  groupValue: selectedRadio,
                  activeColor: primarycolor,
                  onChanged: (newvalue) async {
                    setselectedradio(newvalue);
                  }),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!questions[questionnumber - 1]
                        .options[index]
                        .optiondata
                        .contains("insightse.com"))
                      Text(
                        questions[questionnumber - 1].options[index].optiondata,
                        style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
                      ),
                    if (questions[questionnumber - 1]
                        .options[index]
                        .optiondata
                        .contains("insightse.com"))
                      Image.network(
                          option.substring(0, option.length - 1)
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

const defaultPadding = EdgeInsets.symmetric(horizontal: 5, vertical: 5);

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  print("parsed String : ${parsedString}");
  return parsedString;
}
