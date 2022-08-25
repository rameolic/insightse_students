import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../newdashboardui.dart';
import '../Contsants.dart';

class DoneMessage extends StatefulWidget {

  @override
  _DoneMessageState createState() => _DoneMessageState();
}

class _DoneMessageState extends State<DoneMessage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
    ));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset("assets/submitted.jpeg"),
            ),
            Text("Submission was Successful",style: TextStyle(fontWeight: FontWeight.bold,color:CupertinoColors.secondaryLabel,fontSize: 17),softWrap: true,),
            Padding(
              padding: const EdgeInsets.only(left:5.0,right: 5.0),
              child: Text("Your test was successfully submitted. Please navigate to the dashboard by using the button provided below.",style: TextStyle(color:CupertinoColors.secondaryLabel,fontSize: 15),softWrap: true,textAlign: TextAlign.center,),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewDashbBard(currentIndex: 0)),
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    color: secondarycolor,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Text("Go to DashBoard",style: TextStyle(fontSize: 15,color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
