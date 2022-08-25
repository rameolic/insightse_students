// ignore_for_file: must_be_immutable

import "package:http/http.dart"as http;
import 'dart:convert';
import 'online_classes/model.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter/cupertino.dart';
import 'online_classes/onlineUIupdated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/lms.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'messenger/contacts_screen.dart';
import 'schoolinfo/schoolapis.dart';
import 'package:badges/badges.dart';
import 'online_classes/onlineUIupdated.dart';
import 'messenger/api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final bool live_server = true;
final String baseurl= live_server ? "https://api.insightse.com/" :"https://testapi.insightse.com/";
final String finalurl= live_server ? "https://api.insightse.com/" :"https://testapi.insightse.com/";
final String websocket = live_server ?  "wss://insightse.com/iews/messenger?access_token=${Logindata.parentid == null ?"${Logindata.userid }":"${Logindata.parentid}"}":
'wss://insightse.com/wss2/iemsg?access_token=${Logindata.parentid == null ?"${Logindata.userid }":"${Logindata.parentid}"}';
int skip=0;
bool hide_search = false;
String defaultimage = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4M_mft2IDL4xKKW605PCEiQCf6QuZgQjFJFpT9QBjOw1Vb7D3tPxPIbkrnJTCvZ5MVOY&usqp=CAU";

Map inputbody = {
  "org_id": Logindata.orgid,
  "batch_id": Logindata.batchid,
  "class_id":Logindata.curr_class_id,
  "teacher_id": "",
  "type":"all",
  "session_type":"",
  "from": DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 15))).toString(),
  "to": DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 15))).toString()
};


bool examtimeout = false;
bool examsubmitted = true;
final Textcolor = Color(0xff424B4D);
const grey = Color(0xFFB4B5B9);
const primarycolor = Color(0xFFffb92d);
const secondarycolor = Color(0xFF006e8f);
const borderyellow = Color(0xffffe9a8);
const primaryblue = Color(0xff003ca3);

class Logindata {
  static String username;
  static String password;
  static String fullname;
  static String userrole;
  static String image;
  static String userid;
  static String facmid;
  static String parentid;
  static String usertype;
  static String orgid;
  static String batchid;
  static String usertoken;
  static String orgname;
  static String branchname;
  static String org_logo;
  static String master_id;
  static String curr_class_id;
  static String fixedurl;
}

getclassesList(date) async {
  User user;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Authorization": "Bearer ${Logindata.usertoken}_ie_" + "${Logindata.userid}",
  };
  final msg = jsonEncode(<String, dynamic>{
    "class_id": Logindata.curr_class_id,
    "master_id": Logindata.master_id,
    "batch_id": Logindata.batchid,
    "subj_id": "0",
    "date":  date
  });
  print(msg);
  var response = await http.post(Uri.parse(finalurl + "user/online_classes_list"),
      headers: headers, body: msg);
  print(response.body);
  if (response.statusCode == 200) {
    user = User.fromJson(json.decode(response.body));
    print("length : ${user.data.length}");
  }
  return user;
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}
SharedPreferences logindata;
String usernamedata;
String masterid;
String batchid;
String classid;
String date;
String orgid;
String userid;
String password;
String deviceid;
String parentid;
// ignore: non_constant_identifier_names
String org_name;
String profileimage;
// ignore: non_constant_identifier_names
String org_logo;
String fixedurl;
// ignore: non_constant_identifier_names
String full_name;
List<String> sliders = [];
// ignore: non_constant_identifier_names
String user_token;
void initial() async {
  logindata = await SharedPreferences.getInstance();

  usernamedata = logindata.getString('username');
  userid = logindata.getString('userid');
  masterid = logindata.getString('master_id');
  classid = logindata.getString('curr_class_id');
  batchid = logindata.getString('batch_id');
  userid = logindata.getString('userid');
  date = logindata.getString('curr_date');
  orgid = logindata.getString('org_id');
  password = logindata.getString('password');
  full_name = logindata.getString('full_name');
  deviceid = logindata.getString('deviceids');
  org_name = logindata.getString('org_name');
  parentid = logindata.getString('parent_id');
  profileimage = logindata.getString('profileimage');
  org_logo = logindata.getString('org_logo');
  fixedurl = logindata.getString('fixedurl');
  sliders = logindata.getStringList("sliders");
  user_token = logindata.getString('user_token');
  print("parentid: $parentid");
  Logindata.userid = userid;
  Logindata.username = usernamedata;
  Logindata.password = password;
  Logindata.fullname = full_name;
  Logindata.image = profileimage;
  Logindata.orgid = orgid;
  Logindata.batchid = batchid;
  Logindata.parentid = parentid;
  Logindata.usertoken = user_token;
  Logindata.org_logo = org_logo;
  Logindata.master_id = masterid;
  Logindata.curr_class_id = classid;
  Logindata.fixedurl = fixedurl;
  Logindata.orgname = org_name;
  Logindata.branchname = logindata.getString('branch');
  await GetLmsData(forthedate);
}

class WebveiwUI extends StatefulWidget {
  String url;
  WebveiwUI({this.url});

  @override
  State<WebveiwUI> createState() => _WebveiwUIState();
}

class _WebveiwUIState extends State<WebveiwUI> {

  final progress = new ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(CupertinoIcons.back,color: secondarycolor,)),
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: progress,
          builder: (context, value, child) {
            return
              p.extension((widget.url)) == ".pdf" || p.extension((widget.url))==".doc"?
              PDF().cachedFromUrl(
                widget.url,
                placeholder: (progress) =>
                    Center(child: Text('$progress %')),
                errorWidget: (error) =>
                    Center(child: Text(error.toString())),
              )
                  :
              Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: widget.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onProgress: (progress){
                      print(progress);
                    },
                    onPageFinished: (finish) {
                      progress.value = false;
                      print(finish);
                    },
                  ),
                  if(progress.value)  Center(
                    child:
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: secondarycolor,
                      ),
                    ),
                  ),
                ],
              );
          }),
    );
  }
}

// ignore: missing_return
Future<String> GetId() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    print('This is Token: ' '${token}');
    return token;
  });
}

class PreveiwImage extends StatefulWidget {
  String url;
  PreveiwImage({this.url});

  @override
  State<PreveiwImage> createState() => _PreveiwImageState();
}

class _PreveiwImageState extends State<PreveiwImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(CupertinoIcons.back,color: secondarycolor,)),
      ),
      body: Container(
        color: Colors.white,
        child: PDF().cachedFromUrl(
          widget.url,
          placeholder: (progress) =>
              Center(child: Text('$progress %')),
          errorWidget: (error) =>
              Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
Future<bool> getunreadcount() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  final body = jsonEncode(<String, String>{
    "member_uid": Logindata.userid
  });

  print("body:"+jsonEncode(body));
  http.Response response = await http.post(
      Uri.parse(baseurl + "messenger/unreadcount"),
      headers: headers,
      body: body);
  print("unreadcount: ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    unreadcount = decodeddata['unreadcount'];
    print(unreadcount);
    return true;
  } else {
    var decodeddata = jsonDecode(response.body);
    // Flushbar(
    //   message: decodeddata['msg'],
    //   icon: const Icon(
    //     Icons.info_outline,
    //     size: 20.0,
    //     color: secondarycolor,
    //   ),
    //   duration: const Duration(seconds: 4),
    //   leftBarIndicatorColor: secondarycolor,
    // ).show(context);
    return false;
  }
}
int unreadcount=0;

Future<void> sendnotification(String header,String body)async{
  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  androidNotificationChannel() => AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  AndroidNotificationChannel channel = androidNotificationChannel();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  var androidSettings = AndroidInitializationSettings("@mipmap/ic_stat_notification");
  var iOSSettings = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  var initSetttings =
  InitializationSettings(android: androidSettings, iOS: iOSSettings);
  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onSelectNotification: (message) async {
        // This function handles the click in the notification when the app is in foreground
        // Get.toNamed(NOTIFICATIOINS_ROUTE);
      });
  if(Platform.isAndroid){
    flutterLocalNotificationsPlugin.show(
      int.parse(
          "${DateFormat.yMd().format(DateTime.now())}".replaceAll("/", "")),
      header,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          //  icon: android.smallIcon,
          playSound: true,
        ),
      ),
    );
  }else{
    flutterLocalNotificationsPlugin.show(
      int.parse(
          "${DateFormat.yMd().format(DateTime.now())}".replaceAll("/", "")),
      header,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          //  icon: android.smallIcon,
          playSound: true,
        ),
        iOS: IOSNotificationDetails(
           presentAlert : true,
          presentBadge: true,
           presentSound: true,
        )
      ),
    );
  }
}