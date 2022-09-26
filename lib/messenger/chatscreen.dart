import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import 'dart:ui' as ui;
import '../ProgressHUD.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'dart:ui';
import '../newdashboardui.dart';
import 'messagesui.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File, Platform;
import 'package:path/path.dart' as p;
import 'attachmentsapi.dart';

import 'package:flushbar/flushbar.dart';
bool socketstatus;
final showpickedfiles = new ValueNotifier(true);
IOWebSocketChannel channel;
// ignore: must_be_immutable
bool groupstatus;
bool is_bot;

class ChatScreen extends StatelessWidget with WidgetsBindingObserver {
  String chatname;
  String designation;
  String receiverid, department, gender, classname, division;
  String profileimage;
  bool canrespond;
  ChatScreen({
    this.chatname,
    this.designation,
    this.receiverid,
    this.department,
    this.gender,
    this.classname,
    this.division,
    this.canrespond,
    this.profileimage,
  });
  @override
  void initState() async {
    data.messages = [];
    tempmessages = [];
    chatconversations = [];
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    //don't forget to dispose of it when not needed anymore
    WidgetsBinding.instance.removeObserver(this);
    try {
      print("started");
    } catch (e) {
      print(e);
    }
    _scrollController.dispose();
  }

  AppLifecycleState _lastState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed &&
        _lastState == AppLifecycleState.paused) {
      //now you know that your app went to the background and is back to the foreground
    }
    _lastState =
        state; //register the last state. When you get "paused" it means the app went to the background.
  }

  TextEditingController typedmsg = TextEditingController();
  final typingstarted = new ValueNotifier(false);
  final loading = new ValueNotifier(false);
  ScrollController _scrollController;

  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: delete_mode,
        builder: (context, value, child) {
          return WillPopScope(
      onWillPop: () async {
        await channel.sink.close();
        //  channel.sink.done;
        await getunreadcount();
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => NewDashbBard(
                      currentIndex: 1,
                    )),
            (Route<dynamic> route) => false);
        return true;
      },
      child: GestureDetector(
        onTap: (){
          delete_mode.value = false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 10,
            backgroundColor: Colors.white,
            leadingWidth: 0,
            title: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              //width: MediaQuery.of(context).size.width,
              child:  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await channel.sink.close();
                            // channel.sink.done;
                            await getunreadcount();
                            await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => NewDashbBard(
                                          currentIndex: 1,
                                        )),
                                (Route<dynamic> route) => false);
                            return true;
                          },
                          child: Icon(Icons.arrow_back_ios_sharp,
                              color: Colors.blueGrey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  profileimage:
                                      profileimage == "" || profileimage == "null"
                                          ? defaultimage
                                          : profileimage,
                                  name: chatname,
                                  designation: designation,
                                  department: department,
                                  gender: gender,
                                  classname: classname,
                                  division: division,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  profileimage == "" || profileimage == "null"
                                      ? defaultimage
                                      : profileimage,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.6,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(chatname,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Text(designation,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if(delete_mode.value)
                        GestureDetector(
                          onTap: (){
                            if(messageids.length>0){
                                showDialog(
                                    context: context,
                                    builder: (_) => StatefulBuilder(
                                            builder: (deletecontext, setState) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            content: Builder(
                                              builder: (deletecontext) {
                                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Alert',
                                                      style: TextStyle(
                                                          color: secondarycolor,
                                                          fontSize: 20),
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 0.8,
                                                    ),
                                                    Text(
                                                      "Do you want to delete the selected messages.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            loading.value = true;
                                                            for(int i=0;i<messageids.length;i++) {
                                                              print("Id: $messengerid");
                                                              print("login Id: ${Logindata.userid}");
                                                              print("parent Id: ${Logindata.parentid}");
                                                              await deletemessages(messageids[i]);
                                                            }
                                                            Map refresh ={
                                                              "type": "refresh",
                                                              "receiver": "$receiverid",
                                                              "sender": "$messengerid"
                                                            };
                                                            await channel.sink.add(jsonEncode(refresh));
                                                            loading.value = false;
                                                            Navigator.pop(deletecontext);
                                                            delete_mode.value = false;
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                deletecontext);
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                    'cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }));
                              }else{
                              Flushbar(
                                message: "No messages were selected",
                                icon: const Icon(
                                  Icons.info_outline,
                                  size: 20.0,
                                  color: secondarycolor,
                                ),
                                duration: const Duration(seconds: 4),
                                leftBarIndicatorColor: secondarycolor,
                              ).show(context);
                            }
                            },
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
            ),
          ),
          // drawer: Drawer(
          //   child: Menu(),
          // ),
          body: Stack(
            children: [
              BackdropFilter(
                filter: ui.ImageFilter.blur(
                    sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.mirror),
                child: Image.asset("assets/chatbackground.jpg",
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    fit:
                        MediaQuery.of(context).orientation == Orientation.portrait
                            ? BoxFit.fitHeight
                            : BoxFit.fitWidth),
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: loading,
                  builder: (context, value, child) {
                    return ProgressHUD(
                      inAsyncCall: loading.value,
                      child: FutureBuilder(
                          future:
                              getmessages(receiverid, skip.toString(), context),
                          builder:
                              (BuildContext context, AsyncSnapshot platformData) {
                            if (platformData.hasData) {
                              data.messages = [];
                              if (socketstatus) {
                                channel = IOWebSocketChannel.connect(
                                  Uri.parse(websocket),
                                  pingInterval: Duration(seconds: 1),
                                );
                                channel.stream.listen((event) async {
                                  if (attachmentfile != null) {
                                    attachmentfile = null;
                                  }
                                  loading.value = true;
                                  var decodeddata = jsonDecode(event);
                                  print("socket data : $decodeddata");
                                  if (decodeddata['sender_message_id']
                                              .toString() ==
                                          "$receiverid" ||
                                      decodeddata['receiver_message_id']
                                              .toString() ==
                                          "$receiverid") {
                                    if(chatconversations.length>0){
                                      if ((chatconversations[0].time
                                          .toString() !=
                                          decodeddata['time'].toString() &&
                                          chatconversations[0]
                                              .messagecontent
                                              .toString() !=
                                              decodeddata['message']
                                                  .toString()) ||
                                          (chatconversations[0].time
                                              .toString() ==
                                              decodeddata['time'].toString() &&
                                              chatconversations[0]
                                                  .messagecontent
                                                  .toString() !=
                                                  decodeddata['message']
                                                      .toString())) {
                                        reversed = true;

                                        if (chatconversations.length > 0) {
                                          if(attachmentfile != null){
                                                  chatconversations.insert(
                                                      0,
                                                      message(
                                                          time: decodeddata['time']
                                                              .toString(),
                                                          senderid: decodeddata[
                                                                  'sender_message_id']
                                                              .toString(),
                                                          receiverid: decodeddata[
                                                                  'receiver_message_id']
                                                              .toString(),
                                                          messagecontent:
                                                              decodeddata[
                                                                      'message']
                                                                  .toString(),
                                                          attachment: decodeddata[
                                                                  'attachment']
                                                              .toString()
                                                              .split("<,>"),
                                                          sendername: decodeddata[
                                                                  'sender_name']
                                                              .toString(),
                                                          readstatus: decodeddata[
                                                                  'read_status']
                                                              .toString(),
                                                          isdeleted: false));
                                                }else{
                                            attachmentfile = null;
                                            addmessages([message(
                                                time: decodeddata['time']
                                                    .toString(),
                                                senderid: decodeddata[
                                                'sender_message_id']
                                                    .toString(),
                                                receiverid: decodeddata[
                                                'receiver_message_id']
                                                    .toString(),
                                                messagecontent:
                                                decodeddata[
                                                'message']
                                                    .toString(),
                                                attachment: decodeddata[
                                                'attachment']
                                                    .toString()
                                                    .split("<,>"),
                                                sendername: decodeddata[
                                                'sender_name']
                                                    .toString(),
                                                readstatus: decodeddata[
                                                'read_status']
                                                    .toString(),
                                                isdeleted: false)], context);
                                          }
                                              }
                                      }
                                    }
                                  } else {
                                    print("here bro");
                                    await sendnotification(
                                        decodeddata['sender_name'].toString() +
                                            " sent you a message.",
                                        decodeddata['message'].toString().length >
                                                25
                                            ? decodeddata['message']
                                                    .toString()
                                                    .substring(0, 25) +
                                                ".."
                                            : decodeddata['message'].toString());
                                  }
                                  // }
                                  loading.value = false;
                                }, onDone: () async {
                                  debugPrint('ws channel closed');
                                  channel.sink.close();
                                  channel = IOWebSocketChannel.connect(
                                    Uri.parse(websocket),
                                    pingInterval: Duration(seconds: 1),
                                  );
                                  loading.value = false;
                                }, onError: (error) async {
                                  // counter = 0;
                                  debugPrint('ws error $error');
                                  channel.sink.close();
                                  channel = IOWebSocketChannel.connect(
                                    Uri.parse(websocket),
                                    pingInterval: Duration(seconds: 1),
                                  );
                                  loading.value = false;
                                });
                              }
                              if (chatconversations.length > 0) {
                                addmessages(chatconversations, context);
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (chatconversations.length > 0)
                                    Expanded(
                                      key: UniqueKey(),
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        reverse: reversed,
                                        key: UniqueKey(),
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (showmore)
                                              TextButton(
                                                  onPressed: () async {
                                                    reversed = false;
                                                    // _scrollToTop();
                                                    skip = skip + 10;
                                                    loading.value = true;
                                                    // await getmessages(
                                                    //     receiverid,
                                                    //     skip.toString(),
                                                    //     context);
                                                    // addmessages(tempmessages,
                                                    //     context);
                                                    loading.value = false;
                                                    // Future.delayed(
                                                    //     const Duration(
                                                    //         seconds: 10), () {
                                                    //   print("started");
                                                    //   _scrollToTop();
                                                    // });
                                                  },
                                                  child: Text(
                                                    "Show more",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            // ListView.builder(
                                            //     padding: EdgeInsets.all(0),
                                            //     scrollDirection: Axis.vertical,
                                            //     itemCount: 1,
                                            //     shrinkWrap: true,
                                            //     //reverse: true,
                                            //     physics: NeverScrollableScrollPhysics(),
                                            //     itemBuilder: (context, index) {
                                            //       var widgetdata = data.messages.reversed;
                                            //       return Column(
                                            //         children: widgetdata,
                                            //       );
                                            //     }),
                                            ListView(
                                              padding: EdgeInsets.all(0),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              reverse: true,
                                              children: data.messages,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (attachmentfile != null &&
                                      chatconversations.length > 0)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(context).size.width /
                                                    1.5,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0, bottom: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.blueGrey,
                                                          width: 2.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(12))),
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxHeight:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                3),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(12),
                                                        child: BlurFilter(
                                                          child: p.extension(
                                                                          attachmentfile
                                                                              .path) ==
                                                                      ".jpg" ||
                                                                  p.extension(attachmentfile.path) ==
                                                                      ".jpeg" ||
                                                                  p.extension(attachmentfile.path) ==
                                                                      ".tif" ||
                                                                  p.extension(
                                                                          attachmentfile
                                                                              .path) ==
                                                                      ".gif" ||
                                                                  p.extension(
                                                                          attachmentfile
                                                                              .path) ==
                                                                      ".tiff" ||
                                                                  p.extension(
                                                                          attachmentfile
                                                                              .path) ==
                                                                      ".bmp" ||
                                                                  p.extension(
                                                                          attachmentfile
                                                                              .path) ==
                                                                      ".png" ||
                                                                  p.extension(
                                                                          attachmentfile.path) ==
                                                                      ".eps"
                                                              ? Image.file(attachmentfile)
                                                              : Container(
                                                                  height: 50,
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (chatconversations.length == 0)
                                    Expanded(
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: (){
                                            print("messenger id : $messengerid");
                                            print("login id : ${Logindata.userid}");
                                            print("parent id : ${Logindata.parentid}");
                                          },
                                          child: Text(
                                            "Start a conversation by sending a message",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!is_bot && canrespond)
                                    SafeArea(
                                      child: ValueListenableBuilder<bool>(
                                          valueListenable: typingstarted,
                                          builder: (context, value, child) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0, left: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  if (socketstatus)
                                                    GestureDetector(
                                                      onTap: () async {
                                                        FilePickerResult picked =
                                                            await getFile();
                                                        if (picked != null) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    AttachmentPreveiw(
                                                                      attachmentpath:
                                                                          picked.paths[
                                                                              0],
                                                                      receiverid:
                                                                          receiverid,
                                                                    )),
                                                          );
                                                          picked.paths[0];
                                                          attachmentfile = File(
                                                              picked.paths[0]);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 12.0,
                                                                right: 12),
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .photo_fill_on_rectangle_fill,
                                                          color: borderyellow,
                                                        ),
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10.0),
                                                      margin: EdgeInsets.fromLTRB(
                                                          0, 5, 5, 5.0),
                                                      decoration: BoxDecoration(
                                                        // color:Colors.blueGrey,
                                                        border: Border.all(
                                                            color: borderyellow),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color: Colors.grey,
                                                        //     blurRadius: 10.0,
                                                        //   ),
                                                        // ],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                25.0),
                                                      ),
                                                      child: TextField(
                                                        maxLines: 5,
                                                        minLines: 1,
                                                        readOnly: !socketstatus,
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                        controller: typedmsg,
                                                        cursorColor: Colors.white,
                                                        onChanged: (String val) {
                                                          if (val.length > 0) {
                                                            typingstarted.value =
                                                                true;
                                                          } else {
                                                            typingstarted.value =
                                                                false;
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintMaxLines: null,
                                                          isCollapsed: true,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          20.0),
                                                          focusColor:
                                                              Colors.white,
                                                          hintText: socketstatus
                                                              ? 'Your message here'
                                                              : "our systems are offline, Try again later.",
                                                          hintStyle: TextStyle(
                                                              color: Colors.white
                                                                  .withOpacity(
                                                                      0.5)),
                                                          border:
                                                              InputBorder.none,
                                                          // suffix: Icon(Icons.send,color: borderyellow,)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  if (typingstarted.value)
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (typedmsg
                                                            .text.isNotEmpty) {
                                                          //loading.value = true;
                                                          Map body = {
                                                            "message":
                                                                typedmsg.text,
                                                            "time": DateFormat(
                                                                    'yyyy-MM-dd hh:mm:ss')
                                                                .format(DateTime
                                                                    .now()),
                                                            "receiver":
                                                                receiverid,
                                                            "sender": messengerid,
                                                            "attachment": "",
                                                            "sender_name":
                                                            Logindata.fullname
                                                          };
                                                          print(body);
                                                          try {
                                                            channel.sink.add(
                                                                jsonEncode(body));
                                                          } catch (e) {
                                                            print(e);
                                                          }
                                                          typingstarted.value =
                                                              false;
                                                          typedmsg.clear();
                                                          //loading.value = false;
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 12),
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              borderyellow,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4.0),
                                                            child: Icon(
                                                              Icons.send,
                                                              color:
                                                                  secondarycolor
                                                              //.withOpacity(0.8)
                                                              ,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  if (is_bot)
                                    SafeArea(
                                      child: Container(
                                        width: 150,
                                        margin:
                                            EdgeInsets.only(top: 10, bottom: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: grey.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          "Chat is disabled here!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12),
                                        )),
                                      ),
                                    ),
                                  if (!canrespond)
                                    SafeArea(
                                      child: Container(
                                        width: 200,
                                        margin:
                                            EdgeInsets.only(top: 10, bottom: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: grey.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          "Only Admins can send messages.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12),
                                        )),
                                      ),
                                    )
                                ],
                              );
                            } else {
                              return Center(
                                  child:
                                      Image.asset("assets/volume-colorful.gif"));
                            }
                          }),
                    );
                  }),
            ],
          ),
        ),
      ),
    );});
  }
  // @override
  // void dispose() async {
  //   await channelsink.done;
  //  // await channelsink.close();
  // }
}

File attachmentfile;
String getFileExtension(String fileName) {
  try {
    return "." + fileName.split('.').last;
  } catch (e) {
    return null;
  }
}

FilePickerResult file;
Future getFile() async {
  if (Platform.isAndroid) {
    file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: [
        'jpg',
        'mov',
        'jpeg',
        'png',
        'mkv' 'mp4',
        'pdf',
        'doc',
        'mov'
      ],
    );
  } else if (Platform.isIOS) {
    file = await FilePicker.platform.pickFiles(allowMultiple: false);
  }
  print(file.paths);
  return file;
}

bool reversed = true;

class BlurFilter extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  BlurFilter({this.child, this.sigmaX = 5.0, this.sigmaY = 5.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        child,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Opacity(
              opacity: 0.01,
              child: child,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Attachment...",
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.av_timer_sharp,
              color: Colors.white,
            )
          ],
        ),
      ],
    );
  }
}
