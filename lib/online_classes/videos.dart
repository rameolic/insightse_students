// ignore: unused_import

import '../online_classes/onlineUIupdated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
// ignore: unused_import
import '../online_classes/online.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Videoscreen extends StatefulWidget {
   // ignore: non_constant_identifier_names
   final String username,masterid, batchid, classid, date, orgid,userid,user_token;

  final List<String> videos;
  Videoscreen(this.username,this.masterid, this.batchid, this.classid, this.date, this.orgid,this.userid,this.user_token,
       this.videos,);

  @override
  State<StatefulWidget> createState() {
    return _VideoscreenState();
  }
}

class _VideoscreenState extends State<Videoscreen> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
   print(widget.videos[0]);
 _videoPlayerController1 = VideoPlayerController.network(
        '${widget.videos[0]}');
         _videoPlayerController2 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');

  await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);


    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      showControls: true,
      materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
        backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
       ),
      autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "InsightsE",
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
 backgroundColor: Colors.yellow,
            leading: GestureDetector(
              onTap: () {
                // Navigator.of(context).pop();
                // String classid, batchid, date, orgid;
                 Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewOnlineClassUi(),
                      //   Online(
                      // widget.username,
                      // widget.masterid,
                      //  widget.batchid,
                      //  widget.classid,
                      //  widget.date,
                      //  widget.orgid,
                      //  widget.userid,
                      //  widget.user_token
                      //  ),
                  ),
                );
              },
              child: Icon(
                Icons.arrow_back, // add custom icons also
              ),
            ),
          title: Text("Recorded Videos"),
        ),
        body: Column(

          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
           /* FlatButton(
              color:Colors.white,
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: Text('Fullscreen', style: GoogleFonts.roboto(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 17.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),),
            ),*/
            SizedBox(height:150),
           /* Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController1.pause();
                        _videoPlayerController1.seekTo(const Duration());
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController1,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Landscape Video"),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController2.pause();
                        _videoPlayerController2.seekTo(const Duration());
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController2,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Portrait Video"),
                    ),
                  ),
                )
              ],
            ),*/
           /* Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Android controls"),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("iOS controls"),
                    ),
                  ),
                )
              ],
            )*/
          ],
        ),
      ),
    );
  }
}