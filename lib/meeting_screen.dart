//import 'dart:async';
//import 'dart:io';
//for present these code is not in use
//import 'package:flutter_zoom/api%20user%20details/Model/usermodel.dart';

/*import 'package:test12/online_classes/online.dart';
import 'package:flutter_zoom_plugin/zoom_view.dart';
import 'package:flutter_zoom_plugin/zoom_options.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'dart:convert';
//import 'dart:async';
//import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MeetingWidget extends StatelessWidget {
  ZoomOptions zoomOptions;
  ZoomMeetingOptions meetingOptions;

  Timer timer;
  final String username,masterid, batchid, classid, date, orgid,userid, meetingId, meetingPwd;
  final List sliders;
  final String sessionName;
  MeetingWidget(this.username,this.masterid, this.batchid, this.classid, this.date,
      this.orgid,this.userid, this.sliders, this.sessionName,
      {Key key, this.meetingId, this.meetingPwd})
      : super(key: key) {
    
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "ykyuvVbmZMJb2BymylCnvluDBHPqftNRLJJb",
      appSecret: "LSOsohKmD4iSJqdwS8A9rIg644bIWMthw0mt",
    );
    this.meetingOptions = new ZoomMeetingOptions(
        userId:"ertsgsc@gmail.com", 
        displayName:"$username($sessionName)$masterid",
        //zoomAccessToken:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InhoQjREZmxpUlZxMnozT2wxZkN3c2ciLCJleHAiOjE2MzIyNDQ0NDAsImlhdCI6MTYwMDcwMzEzOX0.r5d4GYaBhcjQ3ID7dRbRqDieyABwAdx03Up9e0z6mPY",
        meetingId: meetingId,
        meetingPassword: meetingPwd,
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false",
        no_webinar_register_dialog: "false");
        
  }

  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";

    return result;
  }

  @override
  Widget build(BuildContext context) {
    
    // Use the Todo to create the UI.
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Online(username,masterid, batchid, classid, date, orgid,userid, sliders)));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Joining Class',style: GoogleFonts.montserrat(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Online(
                       username, masterid, batchid, classid, date, orgid,userid, sliders),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back, // add custom icons also
              ),
            )),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ZoomView(onViewCreated: (controller) {
              print("Created the view");

              controller.initZoom(this.zoomOptions).then((results) {
                print("initialised");
                print(results);

                if (results[0] == 0) {
                  
                  controller.zoomStatusEvents.listen((status) {
                    print("Meeting Status Stream: " +
                        status[0] +
                        " - " +
                        status[1]);
                    if (_isMeetingEnded(status[0])) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Online(
                             username, masterid, batchid, classid, date, orgid,userid, sliders),
                        ),
                      );
                      timer?.cancel();
                    }
                  });

                  print("listen on event channel");

                  controller
                      .joinMeeting(this.meetingOptions)
                      .then((joinMeetingResult) {
                    timer = Timer.periodic(new Duration(seconds: 2), (timer) {
                      controller
                          .meetingStatus(this.meetingOptions.meetingId)
                          .then((status) {
                        print("Meeting Status Polling: " +
                            status[0] +
                            " - " +
                            status[1]);
                      });
                    });
                  });
                }
              }).catchError((error) {
                Text(error);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Online(
                      username,  masterid, batchid, classid, date, orgid,userid, sliders),
                  ),
                );
                print("Error");
                print(error);
              });
            })),
      ),
    );
  }
}*/
