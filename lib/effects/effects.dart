import'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
void Playsound(String sound)async{
  final Player = AudioCache();
  Player.play("audio/"+sound,
    volume: 0.7,
  );
}

SmallHapticFeedback( bool issmall)async{
  /// Check if the device can vibrate
  bool canVibrate = await Vibrate.canVibrate;
  print("vibrate : " + canVibrate.toString());
  if(canVibrate) {
    if(issmall){
      ///Vibration duration is a 10 milliseconds single small feedback
      Vibrate.feedback(FeedbackType.success);
    }else{
      ///Vibration duration is a 50 milliseconds single large feedback
      Vibrate.feedback(FeedbackType.heavy);
    }
  }
}
