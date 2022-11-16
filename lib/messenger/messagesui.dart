import 'dart:io';
import 'api.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import '../ProgressHUD.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'api.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'attachmentsapi.dart';
import 'websocket.dart';
import 'package:flushbar/flushbar.dart';
import 'chatscreen.dart';
import 'audioplayer.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'contacts_screen.dart';

import 'package:intl/intl.dart';
//
// // ignore: must_be_immutable
// class MessageUi extends StatelessWidget {
// String receiverid;
// MessageUi({this.receiverid});
//   final loading = new ValueNotifier(false);
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//         valueListenable: loading,
//         builder: (context, value, child) {
//       return Expanded(
//       key: UniqueKey(),
//       child: ProgressHUD(
//         inAsyncCall: loading.value,
//         child:SingleChildScrollView(
//           reverse: reversedata,
//           key: UniqueKey(),
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               if(showmore)
//                 TextButton(onPressed: ()async{
//                   skip = skip+10;
//                   loading.value=true;
//                   await getmessages(receiverid,skip.toString(),context);
//                   addmessages(tempmessages,context);
//                   loading.value=false;
//                 },
//                     child: Text("Show more",style: TextStyle(color: Colors.white),)),
//               ListView(
//                 padding: EdgeInsets.all(0),
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 reverse: true,
//                 children: data.messages,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );});
//   }
// }
ValueNotifier<bool> delete_mode = ValueNotifier(false);
List<String> messageids = [];
class radiobutton extends StatefulWidget {
  String value;
  bool first_item;
  radiobutton({this.value});
  @override
  State<radiobutton> createState() => _radiobuttonState();
}
class _radiobuttonState extends State<radiobutton> {
  String _radioValue; //Initial definition of radio button value
  String choice;

  void radioButtonChanges(String value) {
    if (messageids.contains(widget.value)) {
      messageids.remove(widget.value);
    } else {
      messageids.add(widget.value);
    }
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          choice = value;
          break;
        default:
          choice = null;
      }
      print(messageids);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Radio(
        value: widget.value,
        groupValue: _radioValue,
        onChanged: radioButtonChanges,
        activeColor: borderyellow,
        toggleable: true,
      ),
    );
  }
}

addmessages(List<message> chatconversations, context) {
  for (int i = 0; i < chatconversations.length; i++) {
    if (chatconversations[i].senderid.toString() == current_userid.toString()) {
      if(!chatconversations[i].isdeleted){
        if ((chatconversations[i].attachment.toString() == "[null]" ||
                chatconversations[i].attachment.toString() == "[]") &&
            chatconversations[i].messagecontent.toString() != "null") {
          data.messages.add(Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    if(datestatus(i))
                      Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 5,bottom: 10),
                        decoration: BoxDecoration(
                            color: borderyellow,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: delete_mode,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onLongPress: () {
                              delete_mode.value = true;
                            },
                            onTap: () {
                              delete_mode.value = false;
                              messageids = [];
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (delete_mode.value)
                                  radiobutton(
                                    value: chatconversations[i].id,
                                  ),
                                SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width /
                                                  1.5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0.0, bottom: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // BubbleSpecialThree(
                                            //   text: chatconversations[i].messagecontent,
                                            //   color: Colors.blueGrey,
                                            //   tail: true,
                                            //   textStyle:
                                            //   TextStyle(color: Colors.white, fontSize: 16),
                                            // ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                color: Colors.blueGrey,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    chatconversations[i]
                                                        .messagecontent,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white60),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //   const EdgeInsets.fromLTRB(8.0, 8.0, 18, 0),
                                                  //   child:
                                                  // ),
                                                  // SizedBox(
                                                  //   height: 15,
                                                  //   child: Stack(
                                                  //     children: [
                                                  //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                  //       Padding(
                                                  //         padding: const EdgeInsets.only(left: 6.0),
                                                  //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                  //       )
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ));
        } else if (chatconversations[i].attachment.toString() != "[null]" &&
            chatconversations[i].attachment.toString() != "[]") {
          for (int u = 0; u < chatconversations[i].attachment.length - 1; u++) {
            if (p.extension(chatconversations[i].attachment[u]) == ".jpg" ||
                p.extension(chatconversations[i].attachment[u]) == ".jpeg" ||
                p.extension(chatconversations[i].attachment[u]) == ".tif" ||
                p.extension(chatconversations[i].attachment[u]) == ".gif" ||
                p.extension(chatconversations[i].attachment[u]) == ".tiff" ||
                p.extension(chatconversations[i].attachment[u]) == ".bmp" ||
                p.extension(chatconversations[i].attachment[u]) == ".png" ||
                p.extension(chatconversations[i].attachment[u]) == ".eps") {
              ///image from sender
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: delete_mode,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onLongPress: () {
                                  delete_mode.value = true;
                                },
                                onTap: () {
                                  delete_mode.value = false;
                                  messageids = [];
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (delete_mode.value)
                                      radiobutton(
                                        value: chatconversations[i].id,
                                      ),
                                    SizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0, bottom: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    SwipeImageGallery(
                                                      context: context,
                                                      children: [
                                                        Image.network(
                                                          chatconversations[i]
                                                              .attachment[u],
                                                          loadingBuilder: (BuildContext
                                                                  context,
                                                              Widget child,
                                                              ImageChunkEvent
                                                                  loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) return child;
                                                            return Center(
                                                              child: SizedBox(
                                                                height: 50,
                                                                width: 50,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      borderyellow,
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes
                                                                      : null,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                      initialIndex: 0,
                                                    ).show();
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.only(right: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.blueGrey,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12))),
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxHeight:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .height /
                                                                  3),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12),
                                                          child: Image.network(
                                                            chatconversations[i]
                                                                .attachment[u],
                                                            // loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                                            //   if (loadingProgress== null) return child;
                                                            //   return BlurFilter(
                                                            //     child: p.extension(
                                                            //         attachmentfile
                                                            //             .path) ==
                                                            //         ".jpg" ||
                                                            //         p.extension(attachmentfile.path) ==
                                                            //             ".jpeg" ||
                                                            //         p.extension(attachmentfile.path) ==
                                                            //             ".tif" ||
                                                            //         p.extension(attachmentfile.path) ==
                                                            //             ".gif" ||
                                                            //         p.extension(attachmentfile
                                                            //             .path) ==
                                                            //             ".tiff" ||
                                                            //         p.extension(attachmentfile
                                                            //             .path) ==
                                                            //             ".bmp" ||
                                                            //         p.extension(attachmentfile
                                                            //             .path) ==
                                                            //             ".png" ||
                                                            //         p.extension(attachmentfile
                                                            //             .path) ==
                                                            //             ".eps"
                                                            //         ? Image.asset(
                                                            //         "assets/rocket-fly.gif"
                                                            //     )
                                                            //         : Container(
                                                            //       height: 50,
                                                            //       color: Colors
                                                            //           .transparent,
                                                            //     ),
                                                            //   );
                                                            // },
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                              8.0, 8.0, 20, 0),
                                                      child: Text(
                                                        DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ));
            } else if (p.extension(chatconversations[i].attachment[u]) ==
                    ".mp4" ||
                p.extension(chatconversations[i].attachment[u]) == ".mov" ||
                p.extension(chatconversations[i].attachment[u]) == ".mkv" ||
                p.extension(chatconversations[i].attachment[u]) == ".hevc") {
              VideoPlayerController _videoPlayerController1;
              ChewieController _chewieController;

              _videoPlayerController1 = VideoPlayerController.network(
                  chatconversations[i].attachment[u]);

              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController1,
                autoPlay: false,
                aspectRatio: 1.77777,
                looping: true,
                showControls: true,
                materialProgressColors: ChewieProgressColors(
                  backgroundColor: Colors.grey,
                ),
                autoInitialize: true,
              );
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: delete_mode,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onLongPress: () {
                                  delete_mode.value = true;
                                },
                                onTap: () {
                                  delete_mode.value = false;
                                  messageids = [];
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (delete_mode.value)
                                      radiobutton(
                                        value: chatconversations[i].id,
                                      ),
                                    SizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0, bottom: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.only(left: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12))),
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                        maxHeight:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                4,
                                                        //   maxWidth: MediaQuery.of(
                                                        //       context)
                                                        //       .size
                                                        //       .width /
                                                        //   1.5,
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12),
                                                          child: Chewie(
                                                            controller:
                                                                _chewieController,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                              8.0, 8.0, 0, 0),
                                                      child: Text(
                                                        DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 15,
                                                    //   child: Stack(
                                                    //     children: [
                                                    //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                    //       Padding(
                                                    //         padding: const EdgeInsets.only(left: 6.0),
                                                    //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                    //       )
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ));
            }
            else if (
                p.extension(chatconversations[i].attachment[u]) == ".mp3"){
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: delete_mode,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onLongPress: () {
                                  delete_mode.value = true;
                                },
                                onTap: () {
                                  delete_mode.value = false;
                                  messageids = [];
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (delete_mode.value)
                                      radiobutton(
                                        value: chatconversations[i].id,
                                      ),
                                    SizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  1.5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0, bottom: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                          1.4),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0, right: 10),
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueGrey,
                                                        borderRadius:
                                                        BorderRadius.only(topLeft:
                                                        Radius.circular(12),
                                                          bottomLeft:
                                                          Radius.circular(12),bottomRight:
                                                            Radius.circular(12),
                              )),
                                                    child: ChatMusic(
                                                      attachment: chatconversations[i]
                                                          .attachment[u],
                                                      onright: true,
                                                    ),
                                                    // Column(
                                                    //   mainAxisSize: MainAxisSize.min,
                                                    //   children: [
                                                    //     Flexible(
                                                    //         child: Text(
                                                    //           (chatconversations[i]
                                                    //               .attachment[u]
                                                    //               .split('/')
                                                    //               .last),
                                                    //           softWrap: true,
                                                    //           style: TextStyle(
                                                    //             color: Colors.white,
                                                    //           ),
                                                    //           maxLines: 1,
                                                    //         )),
                                                    //     ChatMusic(
                                                    //       attachment: chatconversations[i]
                                                    //           .attachment[u],
                                                    //     )
                                                    //   ],
                                                    // ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8.0, 8.0, 18, 0),
                                                      child: Text(
                                                        DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 15,
                                                    //   child: Stack(
                                                    //     children: [
                                                    //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                    //       Padding(
                                                    //         padding: const EdgeInsets.only(left: 6.0),
                                                    //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                    //       )
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ));
            }
            else {
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: delete_mode,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onLongPress: () {
                                  delete_mode.value = true;
                                },
                                onTap: () {
                                  delete_mode.value = false;
                                  messageids = [];
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (delete_mode.value)
                                      radiobutton(
                                        value: chatconversations[i].id,
                                      ),
                                    SizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0, bottom: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => WebveiwUI(
                                                                url: chatconversations[
                                                                            i]
                                                                        .attachment[
                                                                    u])));
                                                  },
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                1.5),
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blueGrey,
                                                          border: Border.all(
                                                              color: Colors.white24,
                                                              width: 2.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.file_copy,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Flexible(
                                                              child: Text(
                                                            (chatconversations[i]
                                                                .attachment[u]
                                                                .split('/')
                                                                .last),
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                            maxLines: 3,
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                              8.0, 8.0, 18, 0),
                                                      child: Text(
                                                        DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 15,
                                                    //   child: Stack(
                                                    //     children: [
                                                    //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                    //       Padding(
                                                    //         padding: const EdgeInsets.only(left: 6.0),
                                                    //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                    //       )
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ));
            }
          }
        }
      }else{
        data.messages.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if(datestatus(i))
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 5,bottom: 10),
                          decoration: BoxDecoration(
                              color: borderyellow,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 0.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            // BubbleSpecialThree(
                            //   text: chatconversations[i].messagecontent,
                            //   color: Colors.blueGrey,
                            //   tail: true,
                            //   textStyle:
                            //   TextStyle(color: Colors.white, fontSize: 16),
                            // ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight:
                                    Radius.circular(10)),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(Icons.lock_clock,color: Colors.grey,size: 20,),
                                      SizedBox(width: 10,),
                                      Flexible(
                                        child : Text("This message has been deleted.",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15),
                                          softWrap: true,
                                          maxLines: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        );
      }
    } else {
      if(!chatconversations[i].isdeleted){
        if ((chatconversations[i].attachment.toString() == "[null]" ||
                chatconversations[i].attachment.toString() == "[]") &&
            chatconversations[i].messagecontent.toString() != "null") {
          // print(i);
          // print(i==0 ? true:DateFormat.yMd().format(DateTime.parse(chatconversations[i].time)) );
          // print(i==0 ? true:DateFormat.yMd().format(DateTime.parse(chatconversations[i-1].time)));
          // print(i==0 ? true:  DateFormat.yMd().format(DateTime.parse(chatconversations[i].time)) != DateFormat.yMd().format(DateTime.parse(chatconversations[i-1].time)));
          data.messages.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(datestatus(i))
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 5,bottom: 10),
                          decoration: BoxDecoration(
                              color: borderyellow,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                        ),
                      ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BubbleSpecialThree(
                            //   isSender: false,
                            //   text: chatconversations[i].messagecontent,
                            //   color: Colors.white,
                            //   tail: true,
                            //   textStyle:
                            //   TextStyle(color: Colors.black, fontSize: 16),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(20.0, 8.0, 0, 0),
                            //   child: Text(
                            //     chatconversations[i].time,
                            //     softWrap: true,
                            //     style: TextStyle(fontSize: 10, color: Colors.white),
                            //   ),
                            // ),

                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (groupstatus)
                                        Text(
                                          chatconversations[i].sendername,
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      if (groupstatus)
                                        SizedBox(
                                          height: 3,
                                        ),
                                      if (chatconversations[i]
                                          .messagecontent
                                          .contains("<br>"))
                                        Text(
                                          chatconversations[i]
                                              .messagecontent
                                              .substring(
                                                  0,
                                                  chatconversations[i]
                                                      .messagecontent
                                                      .indexOf("<br>")),
                                          style: TextStyle(
                                              color: primarycolor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      if (chatconversations[i]
                                          .messagecontent
                                          .contains("<br>"))
                                        SizedBox(
                                          height: 3,
                                        ),
                                      if (chatconversations[i]
                                          .messagecontent
                                          .contains("<br>"))
                                        Text(
                                          chatconversations[i]
                                              .messagecontent
                                              .substring(
                                                  chatconversations[i]
                                                          .messagecontent
                                                          .indexOf("<br>") +
                                                      4,
                                                  chatconversations[i]
                                                      .messagecontent
                                                      .length)
                                              .replaceAll("<p>", "")
                                              .replaceAll("</p>", "\n"),
                                          softWrap: true,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      if (!chatconversations[i]
                                          .messagecontent
                                          .contains("<br>"))
                                        Text(
                                          chatconversations[i].messagecontent,
                                          softWrap: true,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
  DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                    // DateFormat("h:mma").format(DateTime.now())
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
        } else if (chatconversations[i].attachment.toString() != "[null]" &&
            chatconversations[i].attachment.toString() != "[]") {
          for (int u = 0; u < chatconversations[i].attachment.length - 1; u++) {
            if (p.extension(chatconversations[i].attachment[u]) == ".jpg" ||
                p.extension(chatconversations[i].attachment[u]) == ".jpeg" ||
                p.extension(chatconversations[i].attachment[u]) == ".tif" ||
                p.extension(chatconversations[i].attachment[u]) == ".gif" ||
                p.extension(chatconversations[i].attachment[u]) == ".tiff" ||
                p.extension(chatconversations[i].attachment[u]) == ".bmp" ||
                p.extension(chatconversations[i].attachment[u]) == ".png" ||
                p.extension(chatconversations[i].attachment[u]) == ".eps") {
              ///image from receiver
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 1.5),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (groupstatus)
                                Padding(
                                  padding: const EdgeInsets.only(left: 14.0),
                                  child: Text(
                                    chatconversations[i].sendername,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              if (groupstatus)
                                SizedBox(
                                  height: 3,
                                ),
                              GestureDetector(
                                onTap: () {
                                  SwipeImageGallery(
                                    context: context,
                                    children: [
                                      Image(
                                          image: NetworkImage(
                                              chatconversations[i].attachment[u]))
                                    ],
                                    initialIndex: 0,
                                  ).show();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2.0),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height / 3),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                            chatconversations[i].attachment[u])),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                                    child: Text(
  DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 15,
                                  //   child: Stack(
                                  //     children: [
                                  //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                  //       Padding(
                                  //         padding: const EdgeInsets.only(left: 6.0),
                                  //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
            } else if (p.extension(chatconversations[i].attachment[u]) ==
                    ".mp4" ||
                p.extension(chatconversations[i].attachment[u]) == ".mov" ||
                p.extension(chatconversations[i].attachment[u]) == ".mkv" ||
                p.extension(chatconversations[i].attachment[u]) == ".hevc") {
              VideoPlayerController _videoPlayerController1;
              ChewieController _chewieController;

              _videoPlayerController1 = VideoPlayerController.network(
                  chatconversations[i].attachment[u]);

              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController1,
                autoPlay: false,
                aspectRatio: 1.77777,
                looping: true,
                showControls: true,
                materialProgressColors: ChewieProgressColors(
                  backgroundColor: Colors.grey,
                ),
                autoInitialize: true,
              );
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  radiobutton(
                    value: chatconversations[i].id,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [

                          if(datestatus(i))
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 5,bottom: 10),
                                decoration: BoxDecoration(
                                    color: borderyellow,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                              ),
                            ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 1.2),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 0.0, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (groupstatus)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 14.0),
                                      child: Text(
                                        chatconversations[i].sendername,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  if (groupstatus)
                                    SizedBox(
                                      height: 3,
                                    ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2.0),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(12))),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height / 4,
                                        //   maxWidth: MediaQuery.of(
                                        //       context)
                                        //       .size
                                        //       .width /
                                        //   1.5,
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Chewie(
                                            controller: _chewieController,
                                          )),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 8.0, 0, 0),
                                        child: Text(
  DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ));
            }
            else if (
            p.extension(chatconversations[i].attachment[u]) == ".mp3"){
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                      Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: delete_mode,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onLongPress: () {
                                  delete_mode.value = true;
                                },
                                onTap: () {
                                  delete_mode.value = false;
                                  messageids = [];
                                },
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                              .size
                                              .width /
                                              1.5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0.0, bottom: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      1.4),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 0, left: 10),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.blueGrey,
                                                    borderRadius:
                                                    BorderRadius.only(topRight:
                                                    Radius.circular(12),
                                                      bottomLeft:
                                                      Radius.circular(12),bottomRight:
                                                      Radius.circular(12),
                                                    )),
                                                child: ChatMusic(
                                                  attachment: chatconversations[i]
                                                      .attachment[u],
                                                  onright: true,
                                                ),
                                                // Column(
                                                //   mainAxisSize: MainAxisSize.min,
                                                //   children: [
                                                //     Flexible(
                                                //         child: Text(
                                                //           (chatconversations[i]
                                                //               .attachment[u]
                                                //               .split('/')
                                                //               .last),
                                                //           softWrap: true,
                                                //           style: TextStyle(
                                                //             color: Colors.white,
                                                //           ),
                                                //           maxLines: 1,
                                                //         )),
                                                //     ChatMusic(
                                                //       attachment: chatconversations[i]
                                                //           .attachment[u],
                                                //     )
                                                //   ],
                                                // ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 8.0, 18, 0),
                                                  child: Text(
  DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 15,
                                                //   child: Stack(
                                                //     children: [
                                                //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                //       Padding(
                                                //         padding: const EdgeInsets.only(left: 6.0),
                                                //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ));
            }
            else {
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      if(datestatus(i))
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            decoration: BoxDecoration(
                                color: borderyellow,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                          ),
                        ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 1.5),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebveiwUI(
                                              url: chatconversations[i]
                                                  .attachment[u])));
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width / 1.5),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white24, width: 2.0),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (groupstatus)
                                          Text(
                                            chatconversations[i].sendername,
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.file_copy,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                                child: Text(
                                              (chatconversations[i]
                                                  .attachment[u]
                                                  .split('/')
                                                  .last),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              maxLines: 3,
                                            ))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          //  mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  8.0, 8.0, 0, 0),
                                              child: Text(
  DateFormat("h:mma").format(DateTime.parse(chatconversations[i].time)),
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 15,
                                            //   child: Stack(
                                            //     children: [
                                            //       Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                            //       Padding(
                                            //         padding: const EdgeInsets.only(left: 6.0),
                                            //         child: Icon(CupertinoIcons.checkmark_alt,color: Colors.grey,size: 18,),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
            }
          }
        }
      }
      else{
        data.messages.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    if(datestatus(i))
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 5,bottom: 10),
                          decoration: BoxDecoration(
                              color: borderyellow,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(chatconversations[i].time))),
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 0.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            // BubbleSpecialThree(
                            //   text: chatconversations[i].messagecontent,
                            //   color: Colors.blueGrey,
                            //   tail: true,
                            //   textStyle:
                            //   TextStyle(color: Colors.white, fontSize: 16),
                            // ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight:
                                    Radius.circular(10)),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.lock_clock,color: Colors.grey,size: 20,),
                                      SizedBox(width: 10,),
                                      Flexible(
                                        child : Text("This message has been deleted.",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15),
                                          softWrap: true,
                                          maxLines: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        );
      }
    }
  }
  print("length : " + data.messages.length.toString());
}

class AttachmentPreveiw extends StatelessWidget {
  String attachmentpath;
  String receiverid;
  AttachmentPreveiw({this.attachmentpath, this.receiverid});
  ChewieController _chewieController;
  final loading = new ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    if (p.extension(attachmentpath) == ".mov" ||
        p.extension(attachmentpath) == ".mp4" ||
        p.extension(attachmentpath) == ".mp4" ||
        p.extension(attachmentpath) == ".hevc") {
      VideoPlayerController _videoPlayerController1;
      _videoPlayerController1 = VideoPlayerController.file(
        File(attachmentpath),
      );
      print("ratio : ${_videoPlayerController1.value.size.aspectRatio}");
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: 1.77777, //_videoPlayerController1.value.aspectRatio,
        // autoPlay: false,
        // looping: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          backgroundColor: Colors.grey,
        ),
        autoInitialize: true,
      );
    }
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) {
          return  ProgressHUD(
            inAsyncCall: loading.value,
            child: Scaffold(
        backgroundColor:Colors.black,
        appBar: AppBar(
            elevation: 10,
            title: Text("Attachment preview",style: TextStyle(color: Colors.blueGrey),),
            centerTitle: true,
            backgroundColor: borderyellow,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_sharp, color:Colors.blueGrey),
            ),
        ),
        body: Center(
              child: (p.extension(attachmentpath) == ".jpg" ||
                      p.extension(attachmentpath) == ".jpeg" ||
                      p.extension(attachmentpath) == ".tif" ||
                      p.extension(attachmentpath) == ".gif" ||
                      p.extension(attachmentpath) == ".tiff" ||
                      p.extension(attachmentpath) == ".bmp" ||
                      p.extension(attachmentpath) == ".png" ||
                      p.extension(attachmentpath) == ".eps")
                  ? Image.file(File(attachmentpath))
                  : (p.extension(attachmentpath) == ".mov" ||
                          p.extension(attachmentpath) == ".mp4" ||
                          p.extension(attachmentpath) == ".mkv" ||
                          p.extension(attachmentpath) == ".hevc")
                      ? Chewie(
                          controller: _chewieController,
                        )
                      :
              (p.extension(attachmentpath) == ".mp3")
                  ? MusicApp(
                attachment:attachmentpath,
              )
                  :
              PDF().fromPath(attachmentpath)),
        floatingActionButton: FloatingActionButton(
              elevation: 3.0,
              child: new Icon(
                Icons.send,
                color: Colors.blueGrey,
              ),
              backgroundColor: borderyellow,
              onPressed: () async {
                loading.value = true;
                attachmentfile = File(attachmentpath);
                String link = await getattachmenturl(attachmentpath);
                print("link : " + link);
                Map body = {
                  "message": "",
                  "time": DateTime.now().toString(),
                  "receiver": receiverid,
                  "sender": current_userid,
                  "attachment": link,
                  "sender_name": Logindata.fullname
                };
                print(body);
                try {
                  channel.sink.add(jsonEncode(body));
                } catch (e) {
                  print("error : " + e);
                  Flushbar(
                    message: "Error while uploading",
                    icon: const Icon(
                      Icons.info_outline,
                      size: 20.0,
                      color: secondarycolor,
                    ),
                    duration: const Duration(seconds: 4),
                    leftBarIndicatorColor: secondarycolor,
                  ).show(context);
                  return false;
                };
                loading.value = false;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatname: name,
                          receiverid: receiverid,
                          designation: designation,
                          department: department,
                          gender: gender,
                          classname: classname,
                          division: division,
                          profileimage: profile,
                          canrespond: true,
                        )),
                        (Route<dynamic> route) => false);
              }),
      ),
          );
  });
  }

  uploadattachment(path) async {
    String link = await getattachmenturl(path);
    print("link : " + link);
    Map body = {
      "message": "",
      "time": DateTime.now().toString(),
      "receiver": receiverid,
      "sender": current_userid,
      "attachment": link,
      "sender_name": Logindata.fullname
    };
    print(body);
    try {
      channel.sink.add(jsonEncode(body));
    } catch (e) {
      print("error : " + e);
    }
  }
}

bool datestatus(int i){
  if(i+1==chatconversations.length) {
    return true;
  }else{
    if(DateFormat.yMd().format(DateTime.parse(chatconversations[i].time)) != DateFormat.yMd().format(DateTime.parse(chatconversations[i+1].time))){
      return true;
}else{
      return false;
    }
}

}