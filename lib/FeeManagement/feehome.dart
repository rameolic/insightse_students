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
import 'payabletab.dart';
import 'detailstab.dart';
import 'historytab.dart';
import '../newdashboardui.dart';

class FeeMangement extends StatefulWidget {
  @override
  _FeeMangementState createState() => _FeeMangementState();
}

class _FeeMangementState extends State<FeeMangement> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: ()async{
        await getunreadcount();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(context),
        body: DefaultTabController(
          length: 3, // length of tabs
          initialIndex: 1,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: TabBar(
                    labelColor: secondarycolor,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: borderyellow,
                    tabs: [
                      Tab(text: 'Details'),
                      Tab(text: 'Payment'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ),
              body: TabBarView(children: <Widget>[
                DetailsTab(),
                PayableTab(),
                HistoryTab()
              ])),
        ),
      ),
    );
  }
}

_appBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: GestureDetector(
      onTap: () async{
        await getunreadcount();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
      },
      child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
    ),
    title: Text(
      "Fee Management",
      style: TextStyle(color: secondarycolor),
    ),
    centerTitle: true,
  );
}


