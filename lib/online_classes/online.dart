// import 'dart:convert';
// import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:flutter/cupertino.dart';
// import "package:flutter/material.dart";
// import 'package:insightse_students/Contsants.dart';
// //import 'package:flutter_appavailability/flutter_appavailability.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:insightse_students/home.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// // ignore: unused_import
// import 'package:insightse_students/meeting_screen.dart';
// import 'package:insightse_students/online_classes/meeting.dart';
// import 'package:insightse_students/online_classes/testingdart.dart';
// import 'package:insightse_students/online_classes/videos.dart';
//
// import 'package:insightse_students/online_classes/theme/color/light_color.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../Contsants.dart';
// import 'model.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// //import 'package:school/style.dart' as style;
// import 'videos.dart';
// import 'dart:io';
//
// List list;
//
// var currentTheme = APP_THEME.LIGHT;
//
// class Online extends StatefulWidget {
//   // ignore: non_constant_identifier_names
//   final String username,
//       masterid,
//       batchid,
//       classid,
//       date,
//       orgid,
//       userid,
//       user_token;
//
//   Online(this.username, this.masterid, this.batchid, this.classid, this.date,
//       this.orgid, this.userid, this.user_token);
//
//   @override
//   _OnlineState createState() => _OnlineState();
// }
//
// class _OnlineState extends State<Online> {
//   // ignore: deprecated_member_use
//   List<dynamic> _dataProvince = List();
//   var newFormat = DateFormat("yyyy-MM-d");
//   var press;
//   TextEditingController dateCtl = TextEditingController();
//
//   User user;
//   User after;
//   User video;
//   User bro;
//   Meeting broomeet;
//   String importart;
//
//   String subjectfilter;
//   bool isEnabled = true;
//   bool filtered = false;
//   // dados() async {
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json',
//   //     "Authorization": "Bearer ${widget.user_token}_ie_" + "${widget.userid}",
//   //   };
//   //   final msg = jsonEncode(<String, dynamic>{
//   //     "class_id": widget.classid,
//   //     "master_id": widget.masterid,
//   //     "batch_id": widget.batchid,
//   //     "subj_id": _valProvince == null ? "0" : int.parse(_valProvince),
//   //     "date": pres == pres,
//   //   });
//   //   print(msg);
//   //   var response123 = await http.post(finalurl + "user/online_classes_list",
//   //       headers: headers, body: msg);
//   //
//   //   if (response123.statusCode == 200) {
//   //     user = User.fromJson(json.decode(response123.body));
//   //   }
//   //
//   //   return user;
//   // }
//   //
//   // withdate(String pres, String _valProvince) async {
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json',
//   //     "Authorization": "Bearer ${widget.user_token}_ie_" + "${widget.userid}",
//   //     //"Authorization": "Bearer 572d00c542d95ca8c16e5c43965c7f332c4c66ffc5604416c9_ie_"+"${widget.userid}",
//   //   };
//   //   final msg = jsonEncode(<String, dynamic>{
//   //     "class_id": widget.classid,
//   //     "master_id": widget.masterid,
//   //     "batch_id": widget.batchid,
//   //     "subj_id": int.parse(_valProvince),
//   //     "date": pres
//   //   });
//   //   //here batchid=>orgid,date=>batchid,orgid=>date so be care ful with is data
//   //
//   //   var response1 = await http.post(finalurl + "user/online_classes_list",
//   //       headers: headers, body: msg);
//   //   print(msg);
//   //   if (response1.statusCode == 200) {
//   //     bro = User.fromJson(json.decode(response1.body));
//   //   } else {
//   //     throw Exception('Failed to load data');
//   //   }
//   //   return bro;
//   // }
//
//   meetingbro(importart) async {
//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       "Authorization": "Bearer ${widget.user_token}_ie_" + "${widget.userid}",
//       // "Authorization": "Bearer 572d00c542d95ca8c16e5c43965c7f332c4c66ffc5604416c9_ie_"+"${widget.userid}",
//     };
//     final msg = jsonEncode(<String, dynamic>{
//       "org_id": widget.orgid,
//       "user_id": widget.userid,
//       "batch_id": widget.batchid,
//       "meeting_id": importart.toString(),
//     });
//
//     var classRegister = await http.post(finalurl + "online_class/user/register",
//         headers: headers, body: msg);
//     // ignore: unused_local_variable
//     String jsondata = classRegister.toString();
//
//     if (classRegister.statusCode == 200) {
//       var urlio = json.decode(classRegister.body);
//       var joinUrl = urlio["data"]["url"];
//       setState(() {
//         launch(joinUrl);
//       });
//     } else {}
//   }
//
//   // Future dados1(String pres, String _valProvince) async {
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json',
//   //     "Authorization": "Bearer ${widget.user_token}_ie_" + "${widget.userid}",
//   //     //"Authorization": "Bearer 572d00c542d95ca8c16e5c43965c7f332c4c66ffc5604416c9_ie_"+"${widget.userid}",
//   //   };
//   //   final msg = jsonEncode(<String, dynamic>{
//   //     "class_id": widget.classid,
//   //     "master_id": widget.masterid,
//   //     "batch_id": widget.batchid,
//   //     "subj_id": int.parse(_valProvince),
//   //     "date": pres
//   //   });
//   //   //here batchid=>orgid,date=>batchid,orgid=>date so be care ful with is data
//   //
//   //   var response1 = await http.post(finalurl + "user/online_classes_list",
//   //       headers: headers, body: msg);
//   //
//   //   try {
//   //     if (response1.statusCode == 200) {
//   //       after = User.fromJson(json.decode(response1.body));
//   //     } else {
//   //       throw Exception('Failed to load data');
//   //     }
//   //     return after;
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }
//
//   void getProvince() async {
//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       "Authorization": "Bearer ${widget.user_token}_ie_" + "${widget.userid}",
//       //"Authorization": "Bearer 572d00c542d95ca8c16e5c43965c7f332c4c66ffc5604416c9_ie_"+"${widget.userid}",
//     };
//     final msg = jsonEncode(<String, dynamic>{
//       "org_id": widget.orgid,
//       "master_id": widget.masterid,
//       "batch_id": widget.batchid,
//     });
//     try {
//       final respose = await http.post(finalurl + "Login/subjects_list",
//           headers: headers, body: msg); //untuk melakukan request ke webservice
//
//       var listData = jsonDecode(respose.body);
//
//       var gio = listData["data"]; //lalu kita decode hasil datanya
//       //var gio12 = listData['data']['subject_id'][0];
//       //print("Seeeeeeeeee hereeee $listData");
//       setState(() {
//         if (mounted)
//           _dataProvince = gio; // dan kita set kedalam variable _dataProvince
//       });
//     } catch (e) {
//       print(e);
//     }
//     // print(widget.orgid);
//
//     // print("data : $gio");
//   }
//   String forthedate = picked == null ? DateFormat("yyyy-MM-d").format( DateTime.now()) : DateFormat("yyyy-MM-d").format(picked);
//   @override
//   void initState() {
//     super.initState();
//     getProvince();
//     meetingbro(importart);
//     print("picked : $picked");
//   }
//   @override
//   Widget UI12(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: currentTheme == APP_THEME.DARK
//           ? AppThemes.appThemeDark()
//           : AppThemes.appThemeLight(),
//       home: WillPopScope(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: currentTheme != APP_THEME.DARK
//                 ? Colors.yellow
//                 : LightColor.orange,
//             leading: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//                 // String classid, batchid, date, orgid;
//                 /* Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePage(
//                      ),
//                   ),
//                 );*/
//               },
//               child: Icon(
//                 CupertinoIcons.back,
//                 color: currentTheme == APP_THEME.DARK
//                     ? Colors.white
//                     : LightColor.black, // add custom icons also
//               ),
//             ),
//             title: Text("Online Classes",
//                 style: TextStyle(
//                   color: currentTheme == APP_THEME.DARK
//                       ? Colors.white
//                       : LightColor.black,
//                 )),
//             centerTitle: true,
//             // backgroundColor: Colors.yellow[600],
//             elevation: 0,
//           ),
//
//           body: buildBodyWidget(),
//           //FAB
//           // ignore: missing_required_param
//           floatingActionButton: FloatingActionButton(
//             child: IconButton(
//               icon: Icon(Icons.wb_sunny),
//               onPressed: () {
//                 setState(() {
//                   currentTheme == APP_THEME.DARK
//                       ? currentTheme = APP_THEME.LIGHT
//                       : currentTheme = APP_THEME.DARK;
//                 });
//               },
//             ),
//             mini: true,
//           ),
//         ),
//         onWillPop: () async {
//           return false;
//         },
//       ),
//     );
//   }
//
//   Widget buildBodyWidget() {
//     var width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30)),
//           child: Container(
//             height: 50,
//             padding: EdgeInsets.only(left: 15, right: 15),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: currentTheme != APP_THEME.DARK
//                   ? Colors.yellow
//                   : LightColor.orange,
//             ),
//             child: Row(
//               children: [
//                 new Container(
//                   height: 20,
//                   decoration: new BoxDecoration(
//                     //color: Colors.white,
//                       borderRadius: new BorderRadius.only(
//                           topLeft: const Radius.circular(5.0),
//                           bottomLeft: const Radius.circular(5.0),
//                           bottomRight: const Radius.circular(5.0),
//                           topRight: const Radius.circular(5.0))),
//                   child: DropdownButton(
//                     underline: SizedBox(),
//                     isDense: false,
//                     isExpanded: false,
//                     hint: Text(
//                       "Select Subject",style: TextStyle(
//                       color: currentTheme == APP_THEME.DARK
//                           ? Colors.white
//                           : LightColor.black,
//                     ),
//                     ),
//                     style: TextStyle(
//                       color: currentTheme == APP_THEME.DARK
//                           ? Colors.white
//                           : Colors.black
//                     ),
//                     value: subjectfilter,
//                     items: _dataProvince.map((item) {
//                       return DropdownMenuItem(
//                         child: Text(item['subject_name']),
//                         value: item['subject_name'],
//                       );
//                     }).toList(),
//                     iconEnabledColor: currentTheme == APP_THEME.DARK
//                         ? Colors.white
//                         : LightColor.black,
//                     onChanged: (value) {
//                       print(value);
//                       setState(() {
//                         subjectfilter = value;
//                       });
//                     },
//                   ),
//                 ),
//                 Spacer(),
//                 GestureDetector(
//                   onTap: () async{
//                     forthedate = await _selectDate(context);
//                     await getclassesList(forthedate);
//                     setState(() {
//                     });
//                   },
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_today,
//                         color: currentTheme == APP_THEME.DARK
//                             ? Colors.white
//                             : LightColor.black,
//                       ),
//                       SizedBox(width: 10,),
//                       Text(
//                         "${ENDdate.toLocal()}".split(' ')[0],
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: currentTheme == APP_THEME.DARK
//                               ? Colors.white
//                               : LightColor.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         Expanded(
//           child: FutureBuilder(
//               future: getclassesList(forthedate),
//               builder: (BuildContext context, AsyncSnapshot platformData) {
//                 print(forthedate);
//                 if (platformData.hasData) {
//                   print(platformData.data.data[0].sessionName);
//                   return ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     //shrinkWrap: true,
//                     //physics: const ClampingScrollPhysics(),
//                     itemCount: platformData == null ? 0 : platformData.data.data.length,
//                     itemBuilder: (context, index) {
//                       if (platformData.data.data[index].sessionName != null) {
//                         if(subjectfilter == null){
//                         return Container(
//                             height: platformData.data.data[index].subjectName.toString() ==
//                                     "null"
//                                 ? 180
//                                 : 200,
//                             padding: EdgeInsets.fromLTRB(12, 10, 15, 10),
//                             margin:
//                                 EdgeInsets.only(bottom: 10, right: 8, left: 8,top: index == 0 ?10:0),
//                             decoration: BoxDecoration(
//                               color: currentTheme != APP_THEME.DARK
//                                   ? Colors.yellow
//                                   : LightColor.orange,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             platformData.data.data[index].subjectName
//                                                         .toString() !=
//                                                     "null"
//                                                 ? Text(
//                                                     "Subject : ${platformData.data.data[index].subjectName}",
//                                                     style: TextStyle(
//                                                       fontWeight: FontWeight.bold,
//                                                       fontSize: 17,
//                                                       color: currentTheme ==
//                                                               APP_THEME.DARK
//                                                           ? Colors.white
//                                                           : LightColor.black,
//                                                       fontStyle:
//                                                           FontStyle.normal,
//                                                     ))
//                                                 : SizedBox(),
//                                             Text(
//                                                 "Class : ${platformData.data.data[index].sessionName}",
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: currentTheme ==
//                                                           APP_THEME.DARK
//                                                       ? Colors.white
//                                                       : LightColor.black,
//                                                   fontStyle: FontStyle.normal,
//                                                 )),
//                                             Text(
//                                                 "Teacher : ${platformData.data.data[index].createdBy}",
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: currentTheme ==
//                                                           APP_THEME.DARK
//                                                       ? Colors.white
//                                                       : LightColor.black,
//                                                   fontStyle: FontStyle.normal,
//                                                 )),
//                                             Text(
//                                                 "Date: ${DateFormat("yyyy-MM-dd").format(platformData.data.data[index].sessionDate)}",
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: currentTheme ==
//                                                           APP_THEME.DARK
//                                                       ? Colors.white
//                                                       : LightColor.black,
//                                                   fontStyle: FontStyle.normal,
//                                                 )),
//                                             Text(
//                                                 "Start's At : ${platformData.data.data[index].startTime}",
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: currentTheme ==
//                                                           APP_THEME.DARK
//                                                       ? Colors.white
//                                                       : LightColor.black,
//                                                   fontStyle: FontStyle.normal,
//                                                 )),
//                                             Text(
//                                                 "End's At : ${platformData.data.data[index].endTime}",
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: currentTheme ==
//                                                           APP_THEME.DARK
//                                                       ? Colors.white
//                                                       : LightColor.black,
//                                                   fontStyle: FontStyle.normal,
//                                                 )),
//                                             // ignore: deprecated_member_use
//                                             GestureDetector(
//                                               onTap: () {
//                                                 if (platformData.data.data[index].videos2
//                                                         .length >
//                                                     0) {
//                                                   if (widget.date ==
//                                                       (pres == null
//                                                           ? widget.date
//                                                           : pres)) {
//                                                     print(pres);
//                                                     Navigator.pushReplacement(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) => Videoscreen(
//                                                                 widget.username,
//                                                                 widget.masterid,
//                                                                 widget.batchid,
//                                                                 widget.classid,
//                                                                 widget.date,
//                                                                 widget.orgid,
//                                                                 widget.userid,
//                                                                 widget
//                                                                     .user_token,
//                                                                 user.data[index]
//                                                                     .videos2)));
//                                                   } else {
//                                                     print(user.data[index]
//                                                         .videos2[0]);
//                                                     print(pres);
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 WebviewScaffold(
//                                                                   appBar:
//                                                                       AppBar(
//                                                                     backgroundColor:
//                                                                         Colors
//                                                                             .yellow,
//                                                                     centerTitle:
//                                                                         true,
//                                                                     title: Text(
//                                                                       "Recorded Videos",
//                                                                       style: TextStyle(
//                                                                           fontFamily:
//                                                                               'Nunito',
//                                                                           color: Colors
//                                                                               .white,
//                                                                           fontSize:
//                                                                               18.0,
//                                                                           fontWeight:
//                                                                               FontWeight.bold),
//                                                                     ),
//                                                                   ),
//                                                                   url:
//                                                                       '${user.data[index].videos2[0]}',
//                                                                   scrollBar:
//                                                                       true,
//                                                                   withZoom:
//                                                                       true,
//                                                                   withLocalStorage:
//                                                                       true,
//                                                                   hidden: true,
//                                                                   initialChild:
//                                                                       Container(
//                                                                     color: Colors
//                                                                         .lightBlueAccent,
//                                                                     child:
//                                                                         const Center(
//                                                                       child:
//                                                                           SpinKitPouringHourglass(
//                                                                         color: Colors
//                                                                             .yellow,
//                                                                         size:
//                                                                             80.0,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 )));
//                                                   }
//                                                 } else {
//                                                   showDialog(
//                                                       context: context,
//                                                       builder: (context) {
//                                                         Future.delayed(
//                                                             Duration(
//                                                                 seconds: 2),
//                                                             () {
//                                                           Navigator.of(context)
//                                                               .pop(true);
//                                                         });
//                                                         return AlertDialog(
//                                                           content: Stack(
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             children: <Widget>[
//                                                               Image.asset(
//                                                                 'assets/error.png',
//                                                                 height: 200,
//                                                                 fit:
//                                                                     BoxFit.fill,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         );
//                                                       });
//                                                 }
//                                               },
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 5.0),
//                                                 child: SizedBox(
//                                                   child: Row(
//                                                     children: [
//                                                       Icon(
//                                                         Icons
//                                                             .play_circle_filled,
//                                                         color: currentTheme !=
//                                                                 APP_THEME.DARK
//                                                             ? LightColor.orange
//                                                             : LightColor.yellow,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 5,
//                                                       ),
//                                                       Text(
//                                                         "Play Recorded Video",
//                                                         style: TextStyle(
//                                                           fontSize: 14,
//                                                           color: currentTheme ==
//                                                                   APP_THEME.DARK
//                                                               ? Colors.white
//                                                               : LightColor
//                                                                   .black,
//                                                           fontStyle:
//                                                               FontStyle.normal,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ]),
//                                     ]),
//                                 Align(
//                                   alignment: Alignment.topRight,
//                                   child: DateFormat("yMMMMd").format(
//                                     platformData.data.data[index].sessionDate) ==
//                                     DateFormat("yMMMMd")
//                                         .format(DateTime.now()) ? SizedBox(
//                                     height: 30,
//                                     width: 100,
//                                     child: Row(
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 3,
//                                           backgroundColor:
//                                               currentTheme != APP_THEME.DARK
//                                                   ? Colors.red
//                                                   : Colors.white,
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                           _chip(
//                                               "  Today's ",
//                                               currentTheme != APP_THEME.DARK
//                                                   ? Colors.red
//                                                   : Colors.white,
//                                               height: 7),
//                                       ],
//                                     ),
//                                   ):SizedBox(),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: RaisedButton.icon(
//                                       color: currentTheme != APP_THEME.DARK
//                                           ? Colors.white
//                                           : LightColor.black,
//                                       elevation: 2.0,
//                                       onPressed: () async {
//                                        // if (await isZoomistalled()) {
//                                        try{
//                                           launch("${platformData.data.data[index].joinUrl}");
//                                         }
//                                         catch(e) {
//                                           showGeneralDialog(
//                                               barrierColor:
//                                                   Colors.white.withOpacity(0.5),
//                                               transitionBuilder:
//                                                   (context, a1, a2, widget) {
//                                                 return Transform.scale(
//                                                   scale: a1.value,
//                                                   child: Opacity(
//                                                     opacity: a1.value,
//                                                     child: AlertDialog(
//                                                       shape: OutlineInputBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       16.0)),
//                                                       title: Text('Alert!!',
//                                                           style: GoogleFonts
//                                                               .robotoSlab(
//                                                             fontSize: 20,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontStyle: FontStyle
//                                                                 .normal,
//                                                           )),
//                                                       content: Text(
//                                                           'Please install Zoom for having secured Classes',
//                                                           style: GoogleFonts
//                                                               .robotoSlab(
//                                                             fontSize: 17,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontStyle: FontStyle
//                                                                 .normal,
//                                                           )),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               transitionDuration:
//                                                   Duration(milliseconds: 90),
//                                               barrierDismissible: true,
//                                               barrierLabel: '',
//                                               context: context,
//                                               // ignore: missing_return
//                                               pageBuilder: (context, animation1,
//                                                   animation2) {});
//                                         }
//                                       },
//                                       icon: Icon(Icons.video_call),
//                                       label: Text("Join",
//                                           style: GoogleFonts.robotoSlab(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             fontStyle: FontStyle.normal,
//                                           ))),
//                                 ),
//                               ],
//                             ));
//                         }else{
//                           return subjectfilter == platformData.data.data[index].subjectName ?
//                           Container(
//                               height: platformData.data.data[index].subjectName.toString() ==
//                                   "null"
//                                   ? 180
//                                   : 200,
//                               padding: EdgeInsets.fromLTRB(12, 10, 15, 10),
//                               margin:
//                               EdgeInsets.only(bottom: 10, right: 8, left: 8,top: index == 0 ?10:0),
//                               decoration: BoxDecoration(
//                                 color: currentTheme != APP_THEME.DARK
//                                     ? Colors.yellow
//                                     : LightColor.orange,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Stack(
//                                 children: [
//                                   Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               platformData.data.data[index].subjectName
//                                                   .toString() !=
//                                                   "null"
//                                                   ? Text(
//                                                   "Subject : ${platformData.data.data[index].subjectName}",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 17,
//                                                     color: currentTheme ==
//                                                         APP_THEME.DARK
//                                                         ? Colors.white
//                                                         : LightColor.black,
//                                                     fontStyle:
//                                                     FontStyle.normal,
//                                                   ))
//                                                   : SizedBox(),
//                                               Text(
//                                                   "Class : ${platformData.data.data[index].sessionName}",
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     color: currentTheme ==
//                                                         APP_THEME.DARK
//                                                         ? Colors.white
//                                                         : LightColor.black,
//                                                     fontStyle: FontStyle.normal,
//                                                   )),
//                                               Text(
//                                                   "Teacher : ${platformData.data.data[index].createdBy}",
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     color: currentTheme ==
//                                                         APP_THEME.DARK
//                                                         ? Colors.white
//                                                         : LightColor.black,
//                                                     fontStyle: FontStyle.normal,
//                                                   )),
//                                               Text(
//                                                   "Date: ${DateFormat("yyyy-MM-dd").format(platformData.data.data[index].sessionDate)}",
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     color: currentTheme ==
//                                                         APP_THEME.DARK
//                                                         ? Colors.white
//                                                         : LightColor.black,
//                                                     fontStyle: FontStyle.normal,
//                                                   )),
//                                               Text(
//                                                   "Start's At : ${platformData.data.data[index].startTime}",
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     color: currentTheme ==
//                                                         APP_THEME.DARK
//                                                         ? Colors.white
//                                                         : LightColor.black,
//                                                     fontStyle: FontStyle.normal,
//                                                   )),
//                                               Text(
//                                                   "End's At : ${platformData.data.data[index].endTime}",
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     color: currentTheme ==
//                                                         APP_THEME.DARK
//                                                         ? Colors.white
//                                                         : LightColor.black,
//                                                     fontStyle: FontStyle.normal,
//                                                   )),
//                                               // ignore: deprecated_member_use
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   if (platformData.data.data[index].videos2
//                                                       .length >
//                                                       0) {
//                                                     if (widget.date ==
//                                                         (pres == null
//                                                             ? widget.date
//                                                             : pres)) {
//                                                       print(pres);
//                                                       Navigator.pushReplacement(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) => Videoscreen(
//                                                                   widget.username,
//                                                                   widget.masterid,
//                                                                   widget.batchid,
//                                                                   widget.classid,
//                                                                   widget.date,
//                                                                   widget.orgid,
//                                                                   widget.userid,
//                                                                   widget
//                                                                       .user_token,
//                                                                   user.data[index]
//                                                                       .videos2)));
//                                                     } else {
//                                                       print(user.data[index]
//                                                           .videos2[0]);
//                                                       print(pres);
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   WebviewScaffold(
//                                                                     appBar:
//                                                                     AppBar(
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .yellow,
//                                                                       centerTitle:
//                                                                       true,
//                                                                       title: Text(
//                                                                         "Recorded Videos",
//                                                                         style: TextStyle(
//                                                                             fontFamily:
//                                                                             'Nunito',
//                                                                             color: Colors
//                                                                                 .white,
//                                                                             fontSize:
//                                                                             18.0,
//                                                                             fontWeight:
//                                                                             FontWeight.bold),
//                                                                       ),
//                                                                     ),
//                                                                     url:
//                                                                     '${user.data[index].videos2[0]}',
//                                                                     scrollBar:
//                                                                     true,
//                                                                     withZoom:
//                                                                     true,
//                                                                     withLocalStorage:
//                                                                     true,
//                                                                     hidden: true,
//                                                                     initialChild:
//                                                                     Container(
//                                                                       color: Colors
//                                                                           .lightBlueAccent,
//                                                                       child:
//                                                                       const Center(
//                                                                         child:
//                                                                         SpinKitPouringHourglass(
//                                                                           color: Colors
//                                                                               .yellow,
//                                                                           size:
//                                                                           80.0,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   )));
//                                                     }
//                                                   } else {
//                                                     showDialog(
//                                                         context: context,
//                                                         builder: (context) {
//                                                           Future.delayed(
//                                                               Duration(
//                                                                   seconds: 2),
//                                                                   () {
//                                                                 Navigator.of(context)
//                                                                     .pop(true);
//                                                               });
//                                                           return AlertDialog(
//                                                             content: Stack(
//                                                               alignment: Alignment
//                                                                   .center,
//                                                               children: <Widget>[
//                                                                 Image.asset(
//                                                                   'assets/error.png',
//                                                                   height: 200,
//                                                                   fit:
//                                                                   BoxFit.fill,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         });
//                                                   }
//                                                 },
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(
//                                                       top: 5.0),
//                                                   child: SizedBox(
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons
//                                                               .play_circle_filled,
//                                                           color: currentTheme !=
//                                                               APP_THEME.DARK
//                                                               ? LightColor.orange
//                                                               : LightColor.yellow,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5,
//                                                         ),
//                                                         Text(
//                                                           "Play Recorded Video",
//                                                           style: TextStyle(
//                                                             fontSize: 14,
//                                                             color: currentTheme ==
//                                                                 APP_THEME.DARK
//                                                                 ? Colors.white
//                                                                 : LightColor
//                                                                 .black,
//                                                             fontStyle:
//                                                             FontStyle.normal,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                             ]),
//                                       ]),
//                                   Align(
//                                     alignment: Alignment.topRight,
//                                     child: SizedBox(
//                                       height: 30,
//                                       width: 100,
//                                       child: Row(
//                                         children: [
//                                           CircleAvatar(
//                                             radius: 3,
//                                             backgroundColor:
//                                             currentTheme != APP_THEME.DARK
//                                                 ? Colors.red
//                                                 : Colors.white,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           if (DateFormat("yMMMMd").format(
//                                               platformData.data.data[index].sessionDate) ==
//                                               DateFormat("yMMMMd")
//                                                   .format(DateTime.now()))
//                                             _chip(
//                                                 "  Today's ",
//                                                 currentTheme != APP_THEME.DARK
//                                                     ? Colors.red
//                                                     : Colors.white,
//                                                 height: 7),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: RaisedButton.icon(
//                                         color: currentTheme != APP_THEME.DARK
//                                             ? Colors.white
//                                             : LightColor.black,
//                                         elevation: 2.0,
//                                         onPressed: () async {
//                                           try{
//                                             launch("${platformData.data.data[index].joinUrl}");
//                                           }catch(e){
//                                             showGeneralDialog(
//                                                 barrierColor:
//                                                 Colors.white.withOpacity(0.5),
//                                                 transitionBuilder:
//                                                     (context, a1, a2, widget) {
//                                                   return Transform.scale(
//                                                     scale: a1.value,
//                                                     child: Opacity(
//                                                       opacity: a1.value,
//                                                       child: AlertDialog(
//                                                         shape: OutlineInputBorder(
//                                                             borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                 16.0)),
//                                                         title: Text('Alert!!',
//                                                             style: GoogleFonts
//                                                                 .robotoSlab(
//                                                               fontSize: 20,
//                                                               fontWeight:
//                                                               FontWeight.bold,
//                                                               fontStyle: FontStyle
//                                                                   .normal,
//                                                             )),
//                                                         content: Text(
//                                                             'Please install Zoom for having secured Classes',
//                                                             style: GoogleFonts
//                                                                 .robotoSlab(
//                                                               fontSize: 17,
//                                                               fontWeight:
//                                                               FontWeight.bold,
//                                                               fontStyle: FontStyle
//                                                                   .normal,
//                                                             )),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 transitionDuration:
//                                                 Duration(milliseconds: 90),
//                                                 barrierDismissible: true,
//                                                 barrierLabel: '',
//                                                 context: context,
//                                                 // ignore: missing_return
//                                                 pageBuilder: (context, animation1,
//                                                     animation2) {});
//                                           }
//                                         },
//                                         icon: Icon(Icons.video_call),
//                                         label: Text("Join",
//                                             style: GoogleFonts.robotoSlab(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               fontStyle: FontStyle.normal,
//                                             ))),
//                                   ),
//                                 ],
//                               )) : SizedBox();
//                         }
//                       } else {
//                         return Column(
//                           children: [
//                             Image.asset('assets/urlnot.png'),
//                           ],
//                         );
//                       }
//                     },
//                   );
//                 } else {
//                   return Center(child: Image.asset('assets/urlnot.png',width: width/1.5,));
//                 }
//               }),
//         ),
//       ],
//     );
//   }
//
//   Widget _chip(String text, Color textColor,
//       {double height = 0, bool isPrimaryCard = false}) {
//     return Container(
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(30)),
//         color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
//       ),
//       child: Text(text,
//           style: GoogleFonts.ubuntu(
//             color: isPrimaryCard ? Colors.white : textColor,
//             fontSize: 15,
//             fontWeight: FontWeight.normal,
//             fontStyle: FontStyle.normal,
//           )),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: new Scaffold(
//           body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               colors: [Colors.black54, Colors.red[200], Colors.red],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomLeft),
//         ),
//         child: UI12(context),
//       )),
//     );
//   }
//
//   Widget _circularContainer(double height, Color color,
//       {Color borderColor = Colors.transparent, double borderWidth = 2}) {
//     return Container(
//       height: height,
//       width: height,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         border: Border.all(color: borderColor, width: borderWidth),
//       ),
//     );
//   }
//
//   // ignore: unused_element
//   _showerror() {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           Future.delayed(Duration(seconds: 3), () {
//             Navigator.of(context).pop(true);
//           });
//           return AlertDialog(
//             title: Text('No Classes found'),
//           );
//         });
//   }
// }
//
// enum APP_THEME { LIGHT, DARK }
//
// class AppThemes {
//   static ThemeData appThemeLight() {
//     return ThemeData(
//         brightness: Brightness.light,
//         appBarTheme: AppBarTheme(
//           color: Colors.white,
//           iconTheme: IconThemeData(
//             color: Colors.green,
//           ),
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.yellow[600],
//         ),
//         //Theme for FAB
//         floatingActionButtonTheme: FloatingActionButtonThemeData(
//           //White background
//           backgroundColor: Colors.yellow,
//
//           //Black plus (+) sign for FAB
//           foregroundColor: Colors.black,
//         ));
//   }
//
//   static ThemeData appThemeDark() {
//     return ThemeData(
//       brightness: Brightness.dark,
//       appBarTheme: AppBarTheme(
//         color: Colors.black,
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       iconTheme: IconThemeData(
//         color: Colors.orange,
//       ),
//       //Theme for FAB
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         //dark background for FAB
//         backgroundColor: Colors.black,
//
//         //White plus (+) sign for FAB
//         foregroundColor: Colors.white,
//       ),
//     );
//   }
// }
// DateTime picked;
// DateTime ENDdate = DateTime.now();
//
// Future<String> _selectDate(BuildContext context) async {
//   picked = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2021),
//     lastDate: DateTime(2101),
//     builder: (BuildContext context, Widget child) {
//       return Theme(
//         data: ThemeData.dark().copyWith(
//           colorScheme: ColorScheme.light(
//             primary: LightColor.yellow,
//             onPrimary: Colors.white,
//             surface: LightColor.orange,
//             onSurface: Colors.black,
//           ),
//           dialogBackgroundColor: Colors.grey[100],
//         ),
//         child: child,
//       );
//     },
//   );
//   if (picked != null) {
//     ENDdate = picked;
//     return DateFormat("yyyy-MM-d").format(picked);
//   }
// }
//
// // Future<bool> isZoomistalled() async {
// //   //try {
// //     var result;
// //     if (Platform.isAndroid) {
// //       print("here");
// //       result = await  AppAvailability.checkAvailability("us.zoom.videomeetings");
// //     }
// //     else if (Platform.isIOS) {
// //       result = await  AppAvailability.checkAvailability("zoomus://");
// //     }
// //     print("result : $result");
// //     if (result["app_name"] == "Zoom") {
// //       return true;
// //     } else {
// //       return false;
// //     }
// //   // } catch (e) {
// //   //   print(e);
// //   //   return false;
// //   // }
// // }
