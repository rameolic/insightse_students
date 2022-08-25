import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Contsants.dart';
import 'feehome.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';


class Webveiw extends StatelessWidget {
  String url;
  Webveiw({this.url});
  @override
  Widget build(BuildContext webcontext) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child:SafeArea(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                      context: webcontext,
                      builder: (_) => StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                              backgroundColor: Colors.white,//alertboxcolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Are you sure ?",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18),),
                                      Divider(color: Colors.black,),
                                      Text("We suggest to exit only after payment, Please make sure your payment has been done and exit using button provided below.",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey),),
                                      SizedBox(height: 5,),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          Navigator.of(webcontext).pushAndRemoveUntil(MaterialPageRoute(builder: (webcontext) =>
                                              FeeMangement()), (Route<dynamic> route) => false);
                                        },
                                        child: Container(
                                            color:secondarycolor,
                                            padding:
                                            EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 15),
                                            child: Text(
                                              "Exit to app",
                                              style: TextStyle(
                                                  color:
                                                  Colors.white),
                                            )),
                                      ),

                                    ],
                                  );
                                },
                              ),
                            );
                          }));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: secondarycolor,
                  child: Center(child: Text("Navigate Back to App",style: GoogleFonts.roboto(color:Colors.white,fontWeight: FontWeight.w600,fontSize: 15 )),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
