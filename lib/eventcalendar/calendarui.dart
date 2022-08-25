import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Contsants.dart';
import 'calendarapi.dart';
import 'package:intl/intl.dart';
import '../ProgressHUD.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../gifheader.dart';
import '../moduleapi.dart';
/// The app which hosts the home page which contains the calendar on it.

String eventname, type;
DateTime from, to;
Color datacolor;

class CalendarApp extends StatefulWidget {
  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

String selectedfilter;

class _CalendarAppState extends State<CalendarApp> {
  final loading = ValueNotifier(false);
  DateTime currentdate = DateTime.now();
  final showdata = ValueNotifier(false);
  String eventfilter;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async{
    await getcalendarevents(body);
    _refreshController.refreshCompleted();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext maincontext) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(maincontext),
      body:
      !module.CALENDER ?
      Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/nomodule.jpg"),
              SizedBox(height: 50,),
              Text("Calendar is not available",style: TextStyle(color: grey),),

            ],
          )
      ):
      ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, value, child) {
            return SmartRefresher(

              enablePullDown: true,
              enablePullUp: false,
              header: GifHeader1(

              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ProgressHUD(
                inAsyncCall: loading.value,
                opacity: 0.3,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: maincontext,
                            builder: (_) =>
                                StatefulBuilder(builder: (context, setState) {
                                  return ProgressHUD(
                                    inAsyncCall: loading.value,
                                    opacity: 0.3,
                                    child: AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      content: Builder(
                                        builder: (context) {
                                          // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Event Filter',
                                                style: TextStyle(
                                                    color: secondarycolor,
                                                    fontSize: 20),
                                              ),
                                              const Divider(
                                                color: Colors.black,
                                                thickness: 0.8,
                                              ),
                                              Fromdate(),
                                              Todate(),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  loading.value = true;
                                                  Map filteredbody = {
                                                    "org_id": Logindata.orgid,
                                                    "batch_id": Logindata.batchid,
                                                    "class_id": Logindata.curr_class_id,
                                                    "teacher_id": "",
                                                    "type": "all",
                                                    "session_type": "1",
                                                    "from": DateFormat("yyyy-MM-dd")
                                                        .format(fromdateselected)
                                                        .toString(),
                                                    "to": DateFormat("yyyy-MM-dd")
                                                        .format(todateselected)
                                                        .toString()
                                                  };
                                                  await getcalendarevents(
                                                      filteredbody);
                                                  loading.value = false;
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: secondarycolor,
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                  ),
                                                  child: const Center(
                                                      child: Text('Get Events',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white))),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${DateFormat.MMMMd().format(fromdateselected)} - ${DateFormat.MMMMd().format(todateselected)}",
                              textAlign: TextAlign.center,
                              style:
                              const TextStyle(color: primarycolor,fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.edit,size: 12,color: primarycolor,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          underline: const SizedBox(),
                          isDense: true,
                          isExpanded: true,
                          hint: Text(
                            "Type",
                            style:
                            TextStyle(color: Colors.grey[400], fontSize: 18),
                          ),
                          style: const TextStyle(color: Colors.black),
                          value: selectedfilter,
                          items: [
                            "All",
                            "academic",
                            "online_class",
                            "online_exam"
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          iconEnabledColor: Colors.black,
                          onChanged: (value) async {
                            loading.value =true;
                            inputbody = {
                              "org_id": Logindata.orgid,
                              "batch_id": Logindata.batchid,
                              "class_id": Logindata.curr_class_id,
                              "teacher_id": "",
                              "session_type": "",
                              "type": value.toString() != "All" ? "$value" : "",
                              "from": DateFormat("yyyy-MM-dd").format(fromdateselected).toString(),
                              "to": DateFormat("yyyy-MM-dd").format(todateselected).toString()
                            };
                            await getcalendarevents(inputbody);
                            loading.value = false;
                            setState(() {
                              selectedfilter = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scaffold(
                        backgroundColor: Colors.white,
                        body: ValueListenableBuilder<bool>(
                            valueListenable: showdata,
                            builder: (context, value, child) {
                              return Stack(
                                children: [
                                  SfCalendar(
                                    view: CalendarView.day,
                                    allowedViews: const [
                                      CalendarView.day,
                                      CalendarView.week,
                                      CalendarView.workWeek,
                                      CalendarView.month,
                                      CalendarView.timelineDay,
                                      CalendarView.timelineWeek,
                                      CalendarView.timelineWorkWeek
                                    ],
                                    showDatePickerButton: true,
                                    cellBorderColor:
                                    secondarycolor.withOpacity(0.4),
                                    allowViewNavigation: true,
                                    allowAppointmentResize: true,
                                    showCurrentTimeIndicator: true,
                                    viewHeaderStyle: const ViewHeaderStyle(
                                        backgroundColor: borderyellow),
                                    backgroundColor: Colors.white,
                                    controller: _controller,
                                    initialDisplayDate: DateTime.now(),
                                    dataSource:
                                    MeetingDataSource(_getDataSource()),
                                    onTap:
                                        (CalendarTapDetails calendarTapDetails) {
                                      if (calendarTapDetails.targetElement
                                          .toString() ==
                                          "CalendarElement.appointment") {
                                        if (showdata.value) {
                                          showdata.value = false;
                                        }
                                        eventname = calendarTapDetails
                                            .appointments[0].eventName;
                                        from = calendarTapDetails
                                            .appointments[0].from;
                                        to =
                                            calendarTapDetails.appointments[0].to;
                                        datacolor = calendarTapDetails
                                            .appointments[0].background;
                                        type = calendarTapDetails
                                            .appointments[0].type;
                                        showdata.value = true;
                                      } else {
                                        showdata.value = false;
                                      }
                                      if (_controller.view ==
                                          CalendarView.month &&
                                          calendarTapDetails.targetElement ==
                                              CalendarElement.calendarCell) {
                                        _controller.view = CalendarView.day;
                                      } else if ((_controller.view ==
                                          CalendarView.week ||
                                          _controller.view ==
                                              CalendarView.workWeek) &&
                                          calendarTapDetails.targetElement ==
                                              CalendarElement.viewHeader) {
                                        _controller.view = CalendarView.day;
                                      }
                                    },
                                    monthViewSettings: const MonthViewSettings(
                                        navigationDirection:
                                        MonthNavigationDirection.vertical),
                                  ),
                                  if (showdata.value)
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.all(15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          color: datacolor.withOpacity(0.7),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if (eventname != null)
                                              Text(
                                                eventname,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                maxLines: 4,
                                              ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "From : " +
                                                  DateFormat().format(from),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            if (from != to)
                                              Text(
                                                "To : " + DateFormat().format(to),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            if (from == to)
                                              const Text(
                                                "All Day Event : True",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            Text(
                                              "Type : $type",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    // final DateTime today = DateTime.now();
    // final DateTime startTime =
    //     DateTime(today.year, today.month, today.day, 0, 1, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, HexColor(events[0].color), false));
    for (int i = 0; i < events.length; i++) {
      try {
        if (events[i].title != null) {
          bool isallday = true;
          DateTime start = DateTime.parse(events[i].start);
          final DateTime startTime = DateTime(start.year, start.month,
              start.day, start.hour, start.minute, start.second);
          DateTime end = DateTime.parse(events[i].end);
          final DateTime endTime = DateTime(
              end.year, end.month, end.day, end.hour, end.minute, end.second);
          if (start != end) {
            isallday = false;
          } else {
            isallday = true;
          }
          meetings.add(Meeting(events[i].title, startTime, endTime,
              HexColor(events[i].color), isallday, events[i].type));
        }
      } catch (e) {
        print("error to convert event id : ${events[i].id}");
      }
    }
    return meetings;
  }
}

/*
for(int i=0;i<events.length;i++){
      DateTime start = DateTime.parse(events[i].start);
      final DateTime startTime = DateTime(start.year, start.month, start.day, start.hour, start.minute, start.second);
      DateTime end = DateTime.parse(events[i].end);
      final DateTime endTime = DateTime(end.year, end.month, end.day, end.hour, end.minute, end.second);
      meetings.add(Meeting(events[i].title, startTime, endTime, Colors.red/* HexColor(events[i].color)*/, false));
    }
 */
_appBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    // leading: GestureDetector(
    //   onTap: () {
    //     Navigator.pop(context);
    //   },
    //   child: Icon(Icons.arrow_back_ios_sharp, color: Colors.blueAccent),
    // ),
    title: const Text(
      "Calender",
      style: TextStyle(color: secondarycolor),
    ),
    centerTitle: true,
  );
}
Map body = {
  "org_id": Logindata.orgid,
  "batch_id": Logindata.batchid,
  "class_id": Logindata.curr_class_id,
  "teacher_id": "",
  "type": "all",
  "session_type": "1",
  "from": DateFormat("yyyy-MM-dd")
      .format(fromdateselected)
      .toString(),
  "to": DateFormat("yyyy-MM-dd")
      .format(todateselected)
      .toString()
};

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments[index];
    Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.type);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName, type;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final CalendarController _controller = CalendarController();

class Fromdate extends StatefulWidget {
  @override
  _FromdateState createState() => _FromdateState();
}

class _FromdateState extends State<Fromdate> {
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: fromdateselected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: secondarycolor,
              onPrimary: Colors.white,
              surface: secondarycolor,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.grey[100],
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        fromdateselected = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const Text(
            "From : ",
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            "${fromdateselected.toLocal()}".split(' ')[0],
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.calendar,
              color: Colors.black,
            ),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}

DateTime fromdateselected = DateTime.now().subtract(const Duration(days: 15));

class Todate extends StatefulWidget {
  @override
  _TodateState createState() => _TodateState();
}

DateTime todateselected = DateTime.now().add(const Duration(days: 15));

class _TodateState extends State<Todate> {
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: todateselected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: secondarycolor,
              onPrimary: Colors.white,
              surface: secondarycolor,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.grey[100],
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        todateselected = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const Text(
            "To : ",
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            "${todateselected.toLocal()}".split(' ')[0],
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.calendar,
              color: Colors.black,
            ),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}