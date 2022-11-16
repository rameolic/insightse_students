import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;
import '../Contsants.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
class MusicApp extends StatefulWidget {
  String attachment;
  MusicApp({this.attachment});
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon

  //Now let's start by creating our music player
  //first let's declare some object
  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration(seconds: 0);
  Duration musicLength = new Duration(seconds: 60);

  //we will create a custom slider

  Widget slider() {
    return Container(
      width: MediaQuery.of(context).size.width/1.5,
      child: Slider.adaptive(
          activeColor: secondarycolor,
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time
    _player.onDurationChanged.listen((d) {
      print("music length : $d");
      setState(() {
        musicLength = d;
      });
    });
    //
    // //this function will allow us to move the cursor of the slider while we are playing the song
    _player.onAudioPositionChanged.listen((d) {
      setState(() {
         position= d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25,0,25,10),
            child: Text(File(widget.attachment).uri.pathSegments.last,textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              slider(),
              Text(
                "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          Center(
            child: IconButton(
              iconSize: 62.0,
              color: secondarycolor,
              onPressed: () {
                //here we will add the functionality of the play button
                print("$position");
                print("$playing");
                if (!playing) {
                  //now let's play the song
                  if("$position" == "0:00:00.000000"){
                    _player.play(widget.attachment, isLocal: true);
                  }else{
                    print("at resume");
                    _player.resume();
                  }
                  setState(() {
                    playBtn = Icons.pause;
                    playing = true;
                  });
                } else {
                  position = Duration(seconds: 0);
                  _player.pause();
                  setState(() {
                    playBtn = Icons.play_arrow;
                    playing = false;
                  });
                }
              },
              icon: Icon(
                playBtn,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatMusic extends StatefulWidget {
  String attachment;
  bool onright;
  ChatMusic({this.attachment,this.onright});
  @override
  State<ChatMusic> createState() => _ChatMusicState();
}

class _ChatMusicState extends State<ChatMusic> {
  //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon

  //Now let's start by creating our music player
  //first let's declare some object
  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration(seconds: 0);
  Duration musicLength = new Duration(seconds: 0);

  //we will create a custom slider

  Widget slider() {
    return Container(
      width: MediaQuery.of(context).size.width/2.4,
      child:ProgressBar(
        baseBarColor: Colors.white,
        progressBarColor: borderyellow,
        thumbColor: borderyellow,
        timeLabelTextStyle: TextStyle(
          color: borderyellow,fontSize: 12
        ),
        thumbRadius: 10,
        progress: Duration(seconds: position.inSeconds),
        //buffered: Duration(milliseconds: 2000),
        total: Duration(seconds: musicLength.inSeconds),
        onSeek: (duration) {
          print('User selected a new time: $duration');
        },
      ),
      // Slider.
      // adaptive(
      //   thumbColor: borderyellow,
      //     activeColor: borderyellow,
      //     inactiveColor:Colors.white,
      //     value: position.inSeconds.toDouble(),
      //     max: musicLength.inSeconds.toDouble(),
      //     onChanged: (value) {
      //       seekToSec(value.toInt());
      //     }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time
    _player.onDurationChanged.listen((d) {
      print("music length : $d");
      setState(() {
        musicLength = d;
      });
    });
    _player.onPlayerCompletion.listen((event) {
      position = Duration(seconds: 0);
      _player.seek(position);
      setState(() {
        playBtn = Icons.play_arrow;
        playing = false;
      });
    });
    //
    // //this function will allow us to move the cursor of the slider while we are playing the song
    _player.onAudioPositionChanged.listen((d) {
      setState(() {
        position= d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0,right: 5),
            child: Text(File(widget.attachment).uri.pathSegments.last,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: !widget.onright ?Colors.black:Colors.white),maxLines: 1,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                iconSize: 30.0,
                color: borderyellow,
                onPressed: () {
                  if (!playing) {
                    //now let's play the song
                    // if("$position" == "0:00:00.000000"){
                    //
                    //   _player.setVolume(1);
                    //   _player.play(widget.attachment);
                    // }else{
                    //   print("at resume");
                    //   _player.resume();
                    //
                    // }
                    _player.play(widget.attachment);
                    setState(() {
                      playBtn = Icons.pause;
                      playing = true;
                    });
                  } else {
                    position = Duration(seconds: 0);
                    _player.seek(position);
                    setState(() {
                      playBtn = Icons.play_arrow;
                      playing = false;
                    });
                  }
                },
                icon: Icon(
                  playBtn,
                ),
              ),
              // Text(
              //   "${position.inMinutes}:${position.inSeconds.remainder(60)}",
              //   style: TextStyle(
              //     fontSize: 18.0,
              //     color: Colors.white
              //   ),
              // ),
              SizedBox(width: 5,),
              slider(),
              // Text(
              //   "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
              //   style: TextStyle(
              //     fontSize: 18.0,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

