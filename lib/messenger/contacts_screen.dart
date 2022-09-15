import 'dart:ui';
import 'websocket.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'chatscreen.dart';
import '../Contsants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'api.dart';
import 'package:intl/intl.dart';
import '../ProgressHUD.dart';
import '../moduleapi.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

String name;
String receiverid;
String designation;
String department;
String gender;
String classname;
String division;
String profile;
bool group;
bool bot;
bool respond;
Future getTime() async {
  final value = await getconversations();
  return value;
}
class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}
Future futureIntFromPreferences;
class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    futureIntFromPreferences = getTime();
  }
  TextEditingController searchcontroller = TextEditingController();
  final loading = new ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    searchresults=[];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Messenger",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: secondarycolor),
                )),
            centerTitle: true,
          ),
          body: SafeArea(
              child:
              !module.messenger ?
              Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/nomodule.jpg"),
                      SizedBox(height: 50,),
                      Text("Messenger is not available",style: TextStyle(color: grey),),

                    ],
                  )
              ):
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 0, bottom: 15, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Chats",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: loading,
                        builder: (context, value, child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(!hide_search)
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 10, right: 10, bottom: 0),
                                    child: SizedBox(
                                      //height: 45,
                                      child: Theme(
                                        data: new ThemeData(
                                          primaryColor: Colors.grey[50],
                                          primaryColorDark: Colors.red[50],
                                        ),
                                        child: TextField(
                                          onChanged: (val) {
                                            if (val.length == 0) {
                                              setState(() {
                                                searchresults = [];
                                              });
                                            }
                                          },
                                          controller: searchcontroller,
                                          decoration: new InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                            contentPadding:
                                            EdgeInsets.only(right: 15, left: 12),
                                            //prefixIcon: Icon(Icons.search),
                                            //border: InputBorder.none,
                                            hintText: "Search for contacts",
                                            suffix: GestureDetector(
                                              onTap: () async {
                                                if (searchcontroller.text.isNotEmpty) {
                                                  loading.value = true;
                                                  await usesearch(searchcontroller.text, context);
                                                  loading.value = false;
                                                }
                                              },
                                              child: Icon(Icons.search),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.grey, fontSize: 15),
                                            focusColor: primarycolor,
                                          ),
                                          maxLines: null,
                                          //expands: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                if(loading.value)
                                  Center(child: Image.asset(
                                      "assets/volume-colorful.gif")),
                                if (searchresults.length > 0)
                                  ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      scrollDirection: Axis.vertical,
                                      itemCount: searchresults.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return
                                          Stack(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  socketstatus = await checksystem();
                                                  skip = 0;
                                                  try {
                                                    name =
                                                        searchresults[index]
                                                            .fullname;
                                                    receiverid =
                                                        searchresults[index]
                                                            .memberuid;
                                                    designation =
                                                        searchresults[index]
                                                            .usertype;
                                                    department =
                                                        searchresults[index]
                                                            .department;
                                                    gender =
                                                        searchresults[index]
                                                            .gender;
                                                    classname =
                                                        searchresults[index]
                                                            .classname;
                                                    division =
                                                        searchresults[index]
                                                            .division;
                                                    respond =  searchresults[index]
                                                        .canrespond;
                                                    profile = searchresults[
                                                    index]
                                                        .profilepic
                                                        .toString() ==
                                                        "" ||
                                                        searchresults[
                                                        index]
                                                            .profilepic
                                                            .toString() ==
                                                            "null"
                                                        ? defaultimage
                                                        : searchresults[index]
                                                        .profilepic
                                                        .toString();
                                                    group = searchresults[index].usertype == "group" ? true:false;
                                                    bot = searchresults[index].usertype == "bot" ? true:false;
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                  groupstatus = group;
                                                  is_bot = bot;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                              chatname: name,
                                                              receiverid:
                                                              receiverid,
                                                              designation:
                                                              designation,
                                                              department:
                                                              department,
                                                              gender: gender,
                                                              classname:
                                                              classname,
                                                              division:
                                                              division,
                                                              profileimage:
                                                              profile,
                                                              canrespond: respond,
                                                            )),
                                                  );
                                                },
                                                child: Ink(
                                                  // height: 80 ,
                                                  color: Colors.white,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width, //-
                                                  //90,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            showdialog(
                                                                context,
                                                                searchresults[index].profilepic.toString() ==
                                                                    "" ||
                                                                    searchresults[index].profilepic.toString() ==
                                                                        "null"
                                                                    ? defaultimage
                                                                    : searchresults[
                                                                index]
                                                                    .profilepic
                                                                    .toString());
                                                          },
                                                          child: CircleAvatar(
                                                            radius: 30,
                                                            backgroundImage: NetworkImage(searchresults[index]
                                                                .profilepic
                                                                .toString() ==
                                                                "" ||
                                                                searchresults[index]
                                                                    .profilepic
                                                                    .toString() ==
                                                                    "null"
                                                                ? defaultimage
                                                                : searchresults[
                                                            index]
                                                                .profilepic
                                                                .toString()),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width -
                                                              90,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Row(
                                                                // mainAxisSize: MainAxisSize.max,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Text(
                                                                          searchresults[
                                                                          index]
                                                                              .fullname,
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              16.0,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.w500)),
                                                                    ),
                                                                  ),
                                                                  //    Spacer(),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 7,
                                                              ),
                                                              Text(
                                                                  searchresults[
                                                                  index].usertype,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14.0,
                                                                      color: Colors
                                                                          .grey)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (searchresults[index].status !=
                                                  "null" &&
                                                  searchresults[index].status != "" &&
                                                  searchresults[index].status == "1")
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                      right: 20.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Active",
                                                          style: TextStyle(
                                                              color: Colors.green,
                                                              fontSize: 10),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                          Colors.green,
                                                          radius: 3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ],
                                          );
                                      }),
                                if (searchresults.length > 0)
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Divider(
                                                color: secondarycolor,
                                                thickness: 0.5,
                                              ),
                                            )),
                                        Text(
                                          "Conversations",
                                          style: TextStyle(
                                              color: secondarycolor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Divider(
                                                color: secondarycolor,
                                                thickness: 0.5,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                    FutureBuilder(
                        future:  futureIntFromPreferences,
                        builder: (BuildContext context, AsyncSnapshot platformData) {
                          print("data : ${platformData.data}");
                          if (platformData.hasData) {
                            if (conversations.length > 0) {
                              return SingleChildScrollView(
                                child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    scrollDirection: Axis.vertical,
                                    itemCount: conversations.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              socketstatus = await checksystem();
                                              skip = 0;
                                              try {
                                                name =
                                                    conversations[index]
                                                        .fullname;
                                                receiverid =
                                                    conversations[index]
                                                        .memberuid;
                                                designation =
                                                    conversations[index]
                                                        .usertype;
                                                department =
                                                    conversations[index]
                                                        .department;
                                                gender =
                                                    conversations[index]
                                                        .gender;
                                                classname =
                                                    conversations[index]
                                                        .classname;
                                                division =
                                                    conversations[index]
                                                        .division;
                                                respond =  conversations[index]
                                                    .canrespond;
                                                profile = conversations[
                                                index]
                                                    .profilepic
                                                    .toString() ==
                                                    "" ||
                                                    conversations[
                                                    index]
                                                        .profilepic
                                                        .toString() ==
                                                        "null"
                                                    ? defaultimage
                                                    : conversations[index]
                                                    .profilepic
                                                    .toString();
                                                group = conversations[index].usertype == "group" ? true:false;
                                                bot = conversations[index].usertype == "bot" ? true:false;
                                              } catch (e) {
                                                print(e);
                                              }
                                              groupstatus = group;
                                              is_bot = bot;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                          chatname: name,
                                                          receiverid:
                                                          receiverid,
                                                          designation:
                                                          designation,
                                                          department:
                                                          department,
                                                          gender: gender,
                                                          classname:
                                                          classname,
                                                          division:
                                                          division,
                                                          profileimage:
                                                          profile,
                                                          canrespond: respond,
                                                        )),
                                              );

                                            },
                                            child: Ink(
                                              // height: 80 ,
                                              color: Colors.white,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width, //-
                                              //90,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        showdialog(
                                                            context,
                                                            conversations[index].profilepic.toString() ==
                                                                "" ||
                                                                conversations[index].profilepic.toString() ==
                                                                    "null"
                                                                ? defaultimage
                                                                : conversations[
                                                            index]
                                                                .profilepic
                                                                .toString());
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: borderyellow,
                                                        backgroundImage: NetworkImage(conversations[index]
                                                            .profilepic
                                                            .toString() ==
                                                            "" ||
                                                            conversations[index]
                                                                .profilepic
                                                                .toString() ==
                                                                "null"
                                                            ? defaultimage
                                                            : conversations[
                                                        index]
                                                            .profilepic
                                                            .toString()),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width -
                                                          90,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            // mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                             //   width: MediaQuery.of(context).size.width/2.5,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right: 10.0),
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: Text(
                                                                        conversations[
                                                                        index]
                                                                            .fullname,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            16.0,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight:
                                                                            FontWeight.w500),
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //    Spacer(),
                                                              if(conversations[
                                                              index]
                                                                  .time.toString() != "null")
                                                                Text(
                                                                    conversations[
                                                                    index]
                                                                        .time,
                                                                    style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      12.0,
                                                                      color: Colors
                                                                          .grey,
                                                                    )),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          if(conversations[
                                                          index]
                                                              .message.toString()!="null")
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              child: Text(
                                                                  conversations[index].message.contains("<br>") ?
                                                                  conversations[
                                                                  index]
                                                                      .message.substring(0,conversations[index].message.indexOf("<br>")):
                                                                  conversations[
                                                                  index]
                                                                      .message,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14.0,
                                                                      color: conversations[index].readstatus.toString() == "0" && conversations[index].senderid.toString() != messengerid
                                                                          ? Colors
                                                                          .black
                                                                          : Colors
                                                                          .grey,
                                                                      fontWeight: conversations[index].readstatus.toString() == "0" && conversations[index].senderid.toString() != messengerid
                                                                          ? FontWeight
                                                                          .bold
                                                                          : FontWeight
                                                                          .normal)),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (conversations[index]
                                              .status
                                              .toString() ==
                                              "1")
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 5.0,
                                                    top: 8),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                  Colors.green.shade300,
                                                  radius: 6,
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    }),
                              );
                            }
                            else {
                              return Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Center(
                                  child: Text("No Chats found"),
                                ),
                              );
                            }
                          } else {
                            return Center(
                                child: Image.asset(
                                    "assets/volume-colorful.gif"));
                          }
                        })
                  ],
                ),
              )
          )),
    );
  }

  void showdialog(BuildContext context, item) {
    showGeneralDialog(
      barrierLabel: "Insightse",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Image.network(
            item,
            fit: BoxFit.fitWidth,
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
