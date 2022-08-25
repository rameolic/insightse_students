import 'package:flutter/material.dart';
import '../Contsants.dart';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/cupertino.dart';import 'package:intl/intl.dart';
final progress = new ValueNotifier(0);
class Receipt extends StatefulWidget {
  String url;
  Receipt({@required this.url});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }


  void _download(String url) async {
    final status = await Permission.storage.request();

    if(status.isGranted) {
      String path = await _findLocalPath();
      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir:path,
        fileName: "Fee_receipt_${DateFormat('yyyyMMddkkmms').format(DateTime.now())}.pdf",
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      // Scaffold(
      // backgroundColor: Colors.white,
      //   appBar: _appBar(context),
      //   body: PDF(
      //     swipeHorizontal: true,
      //   ).cachedFromUrl(url),
     Scaffold(
        appBar: _appBar(context),
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
       floatingActionButton: IconButton(
         onPressed: (){
           print("hello");
           _download(widget.url);
         },
         icon: Icon(Icons.download),
       ),
      );

      // WebView(
        //   initialUrl: url,
        //   javascriptMode: JavascriptMode.unrestricted,
        // )
    //);
  }

  _appBar(context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
      ),
      title: Text(
        "Receipt",
        style: TextStyle(color: secondarycolor),
      ),
      centerTitle: true,
    );
  }
}
Future<String> _findLocalPath() async {
  var externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}
initFlutterDownloader() async {
  await FlutterDownloader.initialize(
      debug: true
  );
}