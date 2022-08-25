import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Contsants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'information.dart';
import 'gallery.dart';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'schoolapis.dart';
import 'resources.dart';
import '../newdashboardui.dart';

class SchoolInfoDb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await getunreadcount();
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                Logindata.orgname.toString() + " ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: secondarycolor),
              )),
          centerTitle: true,
        ),
        body: DefaultTabController(
          length: 4, // length of tabs
          initialIndex: 0,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: TabBar(
                    labelColor: secondarycolor,
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    indicatorColor: primarycolor,
                    tabs: [
                      Tab(
                        text: 'Information',
                        icon: Icon(Icons.info_outlined),
                      ),
                      Tab(
                        text: 'Gallery',
                        icon: Icon(Icons.photo_camera_back_outlined),
                      ),
                      Tab(
                        text: 'Resources',
                        icon: Icon(Icons.my_library_books_outlined),
                      ),
                      Tab(
                        text: 'Social',
                        icon: Icon(CupertinoIcons.globe),
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(children: <Widget>[
                InformationTab(),
                GalleryTab(),
                ResourcesTab(),
                SocialLinks()
              ])),
        ),
      ),
    );
  }
}

class SocialLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetSocialLinks(context),
        builder: (BuildContext context, AsyncSnapshot platformData) {
          if (platformData.hasData) {
            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                if (socialmediadata.showinsta)
                  GestureDetector(
                    onTap: () async {
                        launch(socialmediadata.insta);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/Instagram.png",
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                          Text(
                            "Instagram",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                if (socialmediadata.showfb)
                  GestureDetector(
                    onTap: () async {
                      launch(socialmediadata.fb);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset("assets/Facebook.png",
                              width: MediaQuery.of(context).size.width / 3),
                          Text(
                            "Facebook",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                if (socialmediadata.showtwitter)
                  GestureDetector(
                    onTap: () async {
                        launch(socialmediadata.twitter);

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset("assets/Twitter.png",
                              width: MediaQuery.of(context).size.width / 3),
                          Text(
                            "Twitter",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                if (socialmediadata.showlinkdln)
                  GestureDetector(
                    onTap: () async {
                        launch(socialmediadata.linkdln);

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset("assets/Linkedin.png",
                              width: MediaQuery.of(context).size.width / 3),
                          Text(
                            "LinkedIn",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: Image.asset("assets/volume-colorful.gif"));
          }
        });
  }
}
