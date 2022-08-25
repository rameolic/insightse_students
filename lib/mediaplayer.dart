import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import '../Contsants.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Contsants.dart';

bool googldrive = true;
const textcolor = Colors.black;
class SamplePlayer extends StatefulWidget {
  String sessionName;
  String joinurl;
  String duration;
  String subject;
  String sessionStartTime;
  String sessionEndTime;
  String sessionDate;
  String facFullName;
  SamplePlayer(
      { @required this.joinurl,
        @required this.subject,
        @required this.sessionName,
        @required this.duration,
        @required this.facFullName,
        @required this.sessionDate,
        @required this.sessionEndTime,
        @required this.sessionStartTime});

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoInitialize: true,
      autoPlay: true,
      videoPlayerController:
      VideoPlayerController.network(
        //AIzaSyCJWpAvQAxL7SWZjgbVhZxb1KEm3PpB9oM
        //"https://www.googleapis.com/drive/v3/files/1KngjI9KmOBUJ55DiPpUpmZM4jsEctYPa?alt=media&key=AIzaSyCJWpAvQAxL7SWZjgbVhZxb1KEm3PpB9oM"
       //"https://drive.google.com/file/d/1KngjI9KmOBUJ55DiPpUpmZM4jsEctYPa/preview"
       widget.joinurl
      )
   );
  }
  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8,10,8,8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 130,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //
              //       widget.subject != null
              //           ? Text(
              //         "Subject : ${widget.subject}",
              //         style: GoogleFonts.lato(
              //           textStyle: TextStyle(
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black),
              //         ),
              //       )
              //           : SizedBox(),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Icon(
              //             FlutterIcons.timeline_alert_mco,
              //             color: Colors.black,
              //             size: 15,
              //           ),
              //           SizedBox(width: 4),
              //           Expanded(
              //             child: SingleChildScrollView(
              //               scrollDirection: Axis.horizontal,
              //               child: Text(
              //                 "Session : ${widget.sessionName}",
              //                 maxLines: 1,
              //                 style: GoogleFonts.lato(
              //                   textStyle: TextStyle(
              //                     fontSize: 14,
              //                     color: Colors.black,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Icon(
              //             FlutterIcons.clock_faw5,
              //             color: Colors.black,
              //             size: 15,
              //           ),
              //           SizedBox(width: 4),
              //           Expanded(
              //             child: SingleChildScrollView(
              //               scrollDirection: Axis.horizontal,
              //               child: Text(
              //                 "Start's At : ${widget.sessionStartTime} - End's At : ${widget.sessionEndTime}",
              //                 maxLines: 1,
              //                 style: GoogleFonts.lato(
              //                   textStyle: TextStyle(
              //                     fontSize: 14,
              //                     color: Colors.black,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Icon(
              //             FlutterIcons.calendar_account_mco,
              //             color: Colors.black,
              //             size: 15,
              //           ),
              //           SizedBox(width: 4),
              //           Text(
              //             "Date :  ${widget.sessionDate}",
              //             style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //                 fontSize: 14,
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Icon(
              //             FlutterIcons.user_astronaut_faw5s,
              //             color: Colors.black,
              //             size: 15,
              //           ),
              //           SizedBox(width: 4),
              //           Expanded(
              //             child: SingleChildScrollView(
              //               scrollDirection: Axis.horizontal,
              //               child: Text(
              //                 "Teacher: ${widget.facFullName}",
              //                 style: GoogleFonts.lato(
              //                   textStyle: TextStyle(
              //                     fontSize: 14,
              //                     color: Colors.black,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              ClipRRect(
                borderRadius:BorderRadius.circular(15),
                child: FlickVideoPlayer(
                    flickManager: flickManager
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_sharp, color: Colors.blueAccent),
        ),);
  }
}

