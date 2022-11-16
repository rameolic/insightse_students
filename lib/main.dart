import 'Contsants.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'loginScren.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pushnotification.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'moduleapi.dart';
import 'eventcalendar/calendarapi.dart';
import 'newdashboardui.dart';
import 'messenger/api.dart';
import 'Switchaccounts/switchaccountsdata.dart';
const debug = true;
bool newuser;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   logindata = await SharedPreferences.getInstance();
  newuser = await (logindata.getBool('login') ?? true);
  if (newuser == false) {
    print("main file");
    Addaccounts("","","","",false,"","","");
    await initial();
    await getunreadcount();
    getcalendarevents(inputbody);
    if(! await getmodules()){
      newuser = true;
      hide_search = true;
    }//change here to home page
  }else{
    hide_search = true;
  }
  await PushNotificationService().setupInteractedMessage();
  runApp(ExampleApp());
  RemoteMessage initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}

class ExampleApp extends StatefulWidget {
  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message codewaa: ${message.messageId}");
  }

  @override
void initState(){
  super.initState();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InsightsE',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: newuser ? LoginScreen() :NewDashbBard(currentIndex: 0));
  }
}

