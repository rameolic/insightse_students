import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import '../online_classes/theme/color/light_color.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'careertestapi.dart';
import '../ProgressHUD.dart';
import 'package:flushbar/flushbar.dart';
import 'package:html/parser.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'examdone.dart';
import 'package:html/dom.dart' as dom;

String remainingtime;
String selectedoptionA;
String selectedoptionB;
var selectedRadioA;
var selectedRadioB;

class VerbalReasUI extends StatelessWidget {
  int index;
  int duration;
  VerbalReasUI({@required this.index, @required this.duration});
  final loading = new ValueNotifier(false);
  ValueNotifier<String> question =
      new ValueNotifier(questionsforverbalreas[questionnumber - 1].title);
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
                                              remainingtime =
                                                  val.inSeconds.toString();
                                            },
                                            onDone: () async {
                                              if (questionnumber < questionsforverbalreas.length) {
                                                selectedRadioA = null;
                                                questionnumber = questionnumber + 1;
                                                print("title : ${questionsforverbalreas[questionnumber - 1].title}");
                                                question.value = questionsforverbalreas[questionnumber - 1].title;
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
                                                  questionsforverbalreas.length
                                                      .toString(),
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
                                                  (questionsforverbalreas
                                                              .length -
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
                                    HtmlWidget(
                                      question.value,
                                      webViewJs: true,
                                      webView: true,
                                      webViewMediaPlaybackAlwaysAllow: true,
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 15,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: Text(
                                                "Choose A",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: Divider(
                                            //     color: LightColor.black,
                                            //     thickness:0.3,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      optionsA(),
                                      SizedBox(
                                        height: 15,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: LightColor.black,
                                                thickness: 0.3,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: Text(
                                                "Choose B",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      optionsB(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            print("came");
                                            if (selectedoptionA != null &&
                                                selectedoptionB != null) {
                                              Saveanswer data = Saveanswer(
                                                  quizid: testlist[index].quizid,
                                                  testnumber: testlist[index].testnumber,
                                                  serialnumber: questionsforverbalreas[questionnumber - 1].serialnumber,
                                                  answer: [selectedoptionA, selectedoptionB],
                                                  questionid: questionsforverbalreas[questionnumber - 1].id,
                                                  time: "" // remainingtime
                                                  );
                                              loading.value = true;
                                              await savecareeranswer(data, context);
                                              loading.value = false;
                                              if (questionnumber < questionsforverbalreas.length) {
                                                selectedoptionA = null;
                                                selectedRadioA = null;
                                                selectedoptionB = null;
                                                selectedRadioA = null;
                                                questionnumber = questionnumber + 1;
                                                question.value = questionsforverbalreas[questionnumber - 1].title;
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

class optionsB extends StatefulWidget {
  @override
  State<optionsB> createState() => _optionsBState();
}

class _optionsBState extends State<optionsB> {
  setselectedradio(int newval) {
    print(
        "id : ${questionsforverbalreas[questionnumber - 1].options2[newval].id}");
    selectedoptionB =
        questionsforverbalreas[questionnumber - 1].options2[newval].id;
    setState(() {
      selectedRadioB = newval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: questionsforverbalreas[questionnumber - 1].options2.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                  value: index,
                  groupValue: selectedRadioA,
                  activeColor: primarycolor,
                  onChanged: (newvalue) async {
                    setselectedradio(newvalue);
                  }),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!questionsforverbalreas[questionnumber - 1]
                        .options2[index]
                        .optiondata
                        .contains("insightse.com"))
                      Text(
                        questionsforverbalreas[questionnumber - 1]
                            .options2[index]
                            .optiondata,
                        style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
                      ),
                    if (questionsforverbalreas[questionnumber - 1]
                        .options2[index]
                        .optiondata
                        .contains("insightse.com"))
                      Image.network(
                        _parseHtmlString(
                            questionsforverbalreas[questionnumber - 1]
                                .options2[index]
                                .optiondata),
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

class optionsA extends StatefulWidget {
  @override
  State<optionsA> createState() => _optionsAState();
}

class _optionsAState extends State<optionsA> {
  setselectedradio(int newval) {
    print(
        "id : ${questionsforverbalreas[questionnumber - 1].options1[newval].id}");
    selectedoptionA =
        questionsforverbalreas[questionnumber - 1].options1[newval].id;
    setState(() {
      selectedRadioA = newval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: questionsforverbalreas[questionnumber - 1].options1.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                  value: index,
                  groupValue: selectedRadioA,
                  activeColor: primarycolor,
                  onChanged: (newvalue) async {
                    setselectedradio(newvalue);
                  }),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!questionsforverbalreas[questionnumber - 1]
                        .options1[index]
                        .optiondata
                        .contains("insightse.com"))
                      Text(
                        questionsforverbalreas[questionnumber - 1]
                            .options1[index]
                            .optiondata,
                        style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
                      ),
                    if (questionsforverbalreas[questionnumber - 1]
                        .options1[index]
                        .optiondata
                        .contains("insightse.com"))
                      Image.network(
                        _parseHtmlString(
                            questionsforverbalreas[questionnumber - 1]
                                .options1[index]
                                .optiondata),
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
