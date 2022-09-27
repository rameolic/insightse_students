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
import 'chatscreen.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'contacts_screen.dart';

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
    print("Delete Status : ${chatconversations[i].isdeleted}");
    if (chatconversations[i].senderid.toString() == messengerid.toString()) {
      if(!chatconversations[i].isdeleted){
        if ((chatconversations[i].attachment.toString() == "[null]" ||
            chatconversations[i].attachment.toString() == "[]") &&
            chatconversations[i].messagecontent.toString() != "null") {
          data.messages.add(Row(
            children: [
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
                                                chatconversations[i].time
                                                // DateFormat("h:mma").format(DateTime.now())
                                                ,
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
              ),
            ],
          ));
        } else if (chatconversations[i].attachment.toString() != "[null]" &&
            chatconversations[i].attachment.toString() != "[]") {
          for (int u = 0; u < chatconversations[i].attachment.length - 1; u++) {
            if (p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".jpg" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".jpeg" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".tif" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".gif" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".tiff" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".bmp" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".png" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".eps") {
              ///image from sender
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                                    chatconversations[i].time,
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
              ));
            } else if (p.extension(chatconversations[i].attachment[u]).toLowerCase() ==
                ".mp4" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".mov" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".mkv" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".hevc") {
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
                                                    chatconversations[i].time,
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
              ));
            } else {
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                                    chatconversations[i].time,
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
            )
        );
      }
    } else {
      if(!chatconversations[i].isdeleted){
        if ((chatconversations[i].attachment.toString() == "[null]" ||
            chatconversations[i].attachment.toString() == "[]") &&
            chatconversations[i].messagecontent.toString() != "null") {
          data.messages.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                              chatconversations[i].time
                              // DateFormat("h:mma").format(DateTime.now())
                              ,
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
          ));
        } else if (chatconversations[i].attachment.toString() != "[null]" &&
            chatconversations[i].attachment.toString() != "[]") {
          for (int u = 0; u < chatconversations[i].attachment.length - 1; u++) {
            if (p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".jpg" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".jpeg" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".tif" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".gif" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".tiff" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".bmp" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".png" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".eps") {
              ///image from receiver
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                                  chatconversations[i].time,
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
              ));
            } else if (p.extension(chatconversations[i].attachment[u]).toLowerCase() ==
                ".mp4" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".mov" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".mkv" ||
                p.extension(chatconversations[i].attachment[u]).toLowerCase() == ".hevc") {
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
                                      chatconversations[i].time,
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
              ));
            } else {
              data.messages.add(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                                            chatconversations[i].time,
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
  @override
  Widget build(BuildContext context) {
    if (p.extension(attachmentpath).toLowerCase() == ".mov" ||
        p.extension(attachmentpath).toLowerCase() == ".mp4" ||
        p.extension(attachmentpath).toLowerCase() == ".mkv" ||
        p.extension(attachmentpath).toLowerCase() == ".hevc") {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: (p.extension(attachmentpath).toLowerCase() == ".jpg" ||
              p.extension(attachmentpath).toLowerCase() == ".jpeg" ||
              p.extension(attachmentpath).toLowerCase() == ".tif" ||
              p.extension(attachmentpath).toLowerCase() == ".gif" ||
              p.extension(attachmentpath).toLowerCase() == ".tiff" ||
              p.extension(attachmentpath).toLowerCase() == ".bmp" ||
              p.extension(attachmentpath).toLowerCase() == ".png" ||
              p.extension(attachmentpath).toLowerCase() == ".eps")
              ? Image.file(File(attachmentpath))
: (p.extension(attachmentpath).toLowerCase() == ".mov" ||
              p.extension(attachmentpath).toLowerCase() == ".mp4" ||
              p.extension(attachmentpath).toLowerCase() == ".mkv" ||
              p.extension(attachmentpath).toLowerCase() == ".hevc")
              ? Chewie(
            controller: _chewieController,
          )
          //         :
          // (p.extension(attachmentpath) == ".mp3")
          //     ? Chewie(
          //   controller: _chewieController,
          // )
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
            attachmentfile = File(attachmentpath);
            String link = await getattachmenturl(attachmentpath);
            print("link : " + link);
            Map body = {
              "message": "",
              "time": DateTime.now().toString(),
              "receiver": receiverid,
              "sender": messengerid,
              "attachment": link,
              "sender_name": Logindata.fullname
            };
            print(body);
            try {
              channel.sink.add(jsonEncode(body));
            } catch (e) {
              print("error : " + e);
            };
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
    );
  }

  uploadattachment(path) async {
    String link = await getattachmenturl(path);
    print("link : " + link);
    Map body = {
      "message": "",
      "time": DateTime.now().toString(),
      "receiver": receiverid,
      "sender": messengerid,
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