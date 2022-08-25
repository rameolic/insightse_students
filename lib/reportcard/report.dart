import 'dart:isolate';
import 'dart:ui';
import 'reportcardapi.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../Contsants.dart';
import 'dart:async';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart';
import '../newdashboardui.dart';

class ReportCard extends StatefulWidget {
  String url;
  ReportCard({this.url});
  @override
  _ReportCardState createState() => _ReportCardState();
}

final progress = new ValueNotifier(0);

class _ReportCardState extends State<ReportCard> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return WillPopScope(
      onWillPop: ()async{
        await getunreadcount();
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
        return true;
      },
      child: ValueListenableBuilder<int>(
          valueListenable: progress,
          builder: (context, value, child) {
            return Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white, //Colors.white,
                appBar: _appBar(context),
                body: SafeArea(
                  child: FutureBuilder(
                      future: getreport(context),
                      builder: (BuildContext context, AsyncSnapshot platformData) {
                        if (platformData.hasData) {
                          List<Widget>children=[];
                          for(int i=0; i <List.from(cards.reversed).length;i++){
                            children.add(
                                Events(
                                  title: List.from(cards.reversed)[i].cardname,
                                  attachments: List.from(cards.reversed)[i].attachment,
                                  publishedat:  List.from(cards.reversed)[i].publishedat,
                                )
                            );
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: children,
                            ),
                          );
                        } else {
                          return  Center(
                              child: Image.asset("assets/volume-colorful.gif"));
                        }
                      }),
                ));
          }),
    );
  }
}
class PdfVeiw extends StatefulWidget {
  String filename;
  String attachmentlink;
  PdfVeiw({this.filename,this.attachmentlink});
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  State<PdfVeiw> createState() => _PdfVeiwState();
}

class _PdfVeiwState extends State<PdfVeiw> {
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

    FlutterDownloader.registerCallback(PdfVeiw.downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void _download(String url) async {
    final status = await Permission.storage.request();

    if(status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      String path = await _findLocalPath();
      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir:path,
        fileName: "report_card_${DateFormat('yyyyMMddkkmms').format(DateTime.now())}.pdf",
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          Expanded(
              child: Container(
                color: Colors.white,
                child: PDF().cachedFromUrl(
                  widget.attachmentlink,
                  placeholder: (progress) =>
                      Center(child: Text('$progress %')),
                  errorWidget: (error) =>
                      Center(child: Text(error.toString())),
                ),
              )),
          TextButton(
            onPressed: () async {
              _download(widget.attachmentlink);
              // print(progress.value);
              // String path = await _findLocalPath();
              // if (progress.value == 100) {
              //   OpenFile.open(path + "/$filename");
              // } else {
              //   bool granted =
              //   await Permission.storage.isGranted;
              //   if (granted) {
              //     filename = "Reportcard_${DateFormat('yyyyMMddkkmms').format(DateTime.now())}.pdf";
              //     //deleteFile(File(path + "/$filename"));
              //     final id =
              //     await FlutterDownloader.enqueue(
              //         url: link,
              //         savedDir: path,
              //         fileName: filename);
              //   } else {
              //     bool permanentlydenied =
              //     await Permission
              //         .storage.isPermanentlyDenied;
              //     if (permanentlydenied) {
              //       Flushbar(
              //         message:
              //         "Error : Storage access was permanently Denied.",
              //         icon: Icon(
              //           Icons.info_outline,
              //           size: 28.0,
              //           color: secondarycolor,
              //         ),
              //         duration: Duration(seconds: 4),
              //         leftBarIndicatorColor:
              //         secondarycolor,
              //       )..show(context);
              //     } else {
              //       print("requested");
              //       await Permission.storage.request();
              //     }
              //   }
              // }
            },
            child: Container(
              margin: EdgeInsets.all(0),
              //height: 20,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: Text(
                  progress.value == 0
                      ? "Save Report Card"
                      : progress.value == 100
                      ? "Downloaded Open File"
                      : "Downloading.. (${progress.value})",
                  style: TextStyle(
                      color: secondarycolor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
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

Future<void> deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print("Error in getting access to the file.");
  }
}

_appBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: GestureDetector(
      onTap: () async{
        Navigator.pop(context);
        // await getunreadcount();
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        //     NewDashbBard(
        //       currentIndex: 0,
        //     )), (Route<dynamic> route) => false);
      },
      child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
    ),
    title: Text(
      "Report card",
      style: TextStyle(color: secondarycolor),
    ),
    centerTitle: true,
  );
}

class Events extends StatelessWidget {
  String title;
  String attachments;
  String publishedat;
  Events({this.title,this.attachments,this.publishedat});
  @override
  List<Widget> children=[];
  Widget build(BuildContext context) {
   // for(int i=0;i<attachments.length;i++){
      children.add(
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PdfVeiw(
                attachmentlink:attachments,
                filename: title,
              )),
            );
          },
          child: Container(
              margin: EdgeInsets.fromLTRB(10,5,10,5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: borderyellow,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Report card name",style: TextStyle(color: Colors.grey),),
                      SizedBox(height: 5,),
                      Text(title),
                    ],
                  ),
                  Icon(CupertinoIcons.doc_plaintext,color: secondarycolor,)
                ],
              )),
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Divider(thickness: 0.3,color:grey ,),
              )),
              Text((publishedat),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: grey),),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Divider(thickness: 0.3,color: grey,),
              ))
            ],
          ),
        ),
        Column(
            children: children
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}