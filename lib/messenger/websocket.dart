import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:convert';
import 'api.dart';
import 'chatscreen.dart';
//import 'messagesui.dart';
// WebSocketChannel channel = IOWebSocketChannel.connect(
//   Uri.parse('wss://insightse.com/wss2/iemsg?access_token=${Logindata.userid}'),
//   pingInterval: Duration(seconds: 1),
// );


onDisconnected() async {
    //await connect();
}

connects() async {
  IOWebSocketChannel.connect(
      Uri.parse('wss://insightse.com/wss2/iemsg?access_token=${Logindata.userid}'),
      pingInterval: Duration(seconds: 1),
    ).stream.listen((event) {
      print(event);
      //ChatScreen().onchange(event);
  },
      onDone: () async {
        debugPrint('ws channel closed');
        IOWebSocketChannel.connect(
          Uri.parse('wss://insightse.com/wss2/iemsg?access_token=${Logindata.userid}'),
          pingInterval: Duration(seconds: 1),
        ).sink.close();
        await onDisconnected();
      }, onError: (error) async {
        // counter = 0;
        debugPrint('ws error $error');
        IOWebSocketChannel.connect(
          Uri.parse('wss://insightse.com/wss2/iemsg?access_token=${Logindata.userid}'),
          pingInterval: Duration(seconds: 1),
        ).sink.close();
        await onDisconnected();
      }
    );
}

