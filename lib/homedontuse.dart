//import 'dart:io';
import 'careertests/careertestdashbord.dart';
import 'dart:convert';
import 'package:flutter_icons/flutter_icons.dart';
import 'homework/homeworkpage.dart';
import 'online_classes/onlineUIupdated.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../circulars/circularhome.dart';
import 'eventcalendar/calendarui.dart';
import 'Onlineexams/onlineexamhome.dart';
// ignore: unused_import
import '../loginScren.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import '../FeeManagement/feehome.dart';
import '../profile/Profile.dart';
import '../sign_in/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Contsants.dart';
import 'reportcard/report.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences logindata;
  String usernamedata;
  String masterid;
  String batchid;
  String classid;
  String date;
  String orgid;
  String userid;
  String password;
  String deviceid;
// ignore: non_constant_identifier_names
  String org_name;
  String profileimage;
// ignore: non_constant_identifier_names
  String org_logo;
  String fixedurl;
// ignore: non_constant_identifier_names
  String full_name;
  List sliders = [];
// ignore: non_constant_identifier_names
  String user_token;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      usernamedata = logindata.getString('username');
      userid = logindata.getString('userid');
      masterid = logindata.getString('master_id');
      classid = logindata.getString('curr_class_id');
      batchid = logindata.getString('batch_id');
      userid = logindata.getString('userid');
      date = logindata.getString('curr_date');
      orgid = logindata.getString('org_id');
      password = logindata.getString('password');
      full_name = logindata.getString('full_name');
      deviceid = logindata.getString('deviceids');
      org_name = logindata.getString('org_name');
      profileimage = logindata.getString('profileimage');
      org_logo = logindata.getString('org_logo');
      fixedurl = logindata.getString('fixedurl');
      user_token = logindata.getString('user_token');
      slidersdata(usernamedata, password, deviceid);
      Logindata.userid = userid;
      Logindata.username = usernamedata;
      Logindata.password = password;
      Logindata.fullname = full_name;
      Logindata.image = profileimage;
      Logindata.orgid = orgid;
      Logindata.batchid = batchid;
      Logindata.usertoken = user_token;
      Logindata.org_logo = org_logo;
      Logindata.master_id = masterid;
      Logindata.curr_class_id = classid;
      Logindata.fixedurl = fixedurl;
      print(
          'FRom home page name=$full_name,username=$usernamedata,userid=$userid,masterid=$masterid,classid=$classid,userid=$userid,batchid=$batchid,date=$date,orgid=$orgid,password=$password,deviceid:$deviceid,orgname:$org_name,profileimage:$profileimage,orglogo:$org_logo,fixedurl:$fixedurl,user_token:$user_token');
    });
  }

  Future<void> slidersdata(
      String usernamedata, String password, String deviceid) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // print("sliders here");
    final msg = jsonEncode(<String, String>{
      "username": usernamedata,
      "password": password,
      "deviceid": deviceid
    });
    final res = await http.post(
      Uri.parse(finalurl + "users/student/login"),
      headers: headers,
      body: msg,
    );
    // print(res.body);
    //final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      var urlio = json.decode(res.body);

      sliders = urlio["data"]["sliders"];
      //print(sliders);
      setState(() {});
    }
  }

  //int _currentIndex = 0;
  List cardList = [Item1(), Item2(), Item3(), Item4()];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final List<String> imageList = [
    "assets/logo.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    print(fixedurl + "/assets/images/" +
        org_logo);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            org_name == "null" ? "School" : org_name,
            style: GoogleFonts.roboto(
              color: Colors.black,
              //textStyle: Theme.of(context).textTheme.display1,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          backgroundColor: Colors.yellow[600],
          // actions: [
          //   Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.notifications_active,
          //           color: Colors.black,
          //         ),
          //         onPressed: () {
          //           // Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(
          //           //       builder: (context) => Notify(usernamedata, masterid,
          //           //           batchid, classid, date, orgid, userid)),
          //           // );
          //         },
          //       )),
          // ],
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
          Colors.transparent, //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
          elevation: 1,
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                 org_logo.toString() != "null" ? Padding(
                   padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                   child: DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:  AssetImage("assets/Elogo.png"), //NetworkImage(fixedurl+"/assets/images/"+org_logo),//
                          fit: BoxFit.fitWidth),
                    ),
                ),
                 ):
                ListTile(
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:25.0,bottom: 25),
                      child: Text(
                        org_name.toString() == "null" ? "School" : org_name,
                        style: TextStyle(
                          color: Colors.white,
                          //textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      //textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                              usernamedata,
                              masterid,
                              batchid,
                              classid,
                              date,
                              orgid,
                              userid,
                              fixedurl,
                              profileimage,
                              user_token)),
                    );
                  },
                ),

                // ListTile(
                //   title: Text(
                //     'Report Card',
                //     style: TextStyle(
                //       color: Colors.white,
                //       //textStyle: Theme.of(context).textTheme.display1,
                //       fontSize: 16,
                //       fontStyle: FontStyle.normal,
                //     ),
                //   ),
                //   leading: Icon(
                //     CupertinoIcons.doc_append,
                //     color: Colors.white,
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => ReportCard()),
                //     );
                //   },
                // ),
                // ListTile(
                //   title: Text(
                //     'Events',
                //     style: TextStyle(
                //       color: Colors.white,
                //       //textStyle: Theme.of(context).textTheme.display1,
                //       fontSize: 16,
                //       fontStyle: FontStyle.normal,
                //     ),
                //   ),
                //   leading: Icon(
                //     CupertinoIcons.calendar_today,
                //     color: Colors.white,
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => CalendarApp()),
                //     );
                //   },
                // ),
                ListTile(
                  title: Text('LogOut',
                    style: TextStyle(
                      color: Colors.white,
                      //textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                    ),),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onTap: () async {
                   var data =  await SharedPreferences.getInstance();
                   data.clear();
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(builder: (context) => SignIn()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.symmetric(),
          children: <Widget>[
            //new Image(image: new AssetImage('assets/splashlogo.gif')),

            /*FutureBuilder(
future: slidersdata(usernamedata,password),
builder: (BuildContext context,AsyncSnapshot snapshot){
  return
  CarouselSlider(
              items: <Widget>[
                for (var i = 0; i < sliders.length; i++)
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(sliders[i]),
                          fit: BoxFit.fitHeight,
                        ),
                        // border:
                        //     Border.all(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onTap: () {
                      showdialog(context, sliders[i]);
                    },
                  ),
              ],
              options: CarouselOptions(
                  //height: MediaQuery.of(context).size.height * 0.30,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  scrollDirection: Axis.horizontal),
            );

},
           ),*/ ////////////////remove for sliders are here
            Container(
              child: sliders.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top:25.0),
                    child: Center(
                      child: SizedBox(
                width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                color: secondarycolor,
              ),
                      ),
                    ),
                  )
                  : sliders.length >0 ? CarouselSlider(
                      items: <Widget>[
                        for (var i = 0; i < sliders.length; i++)
                          GestureDetector(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 20.0, left: 20.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(sliders[i]),
                                  fit: BoxFit.fitHeight,
                                ),
                                // border:
                                //     Border.all(color: Theme.of(context).accentColor),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onTap: () {
                              showdialog(context, sliders[i]);
                            },
                          ),
                        if (sliders.length == null) CircularProgressIndicator()
                      ],
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.30,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          scrollDirection: Axis.horizontal),
                    ) : SizedBox(),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => NewOnlineClassUi()));
                  },
                  child: _buildWikiCategory(Icons.description_outlined, "LMS",
                      secondarycolor.withOpacity(0.7)),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CareerTestDashBord()),
                    );
                  },
                  child: _buildWikiCategory(CupertinoIcons.doc, "Skill Assessment",
                      secondarycolor.withOpacity(0.7)),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CircularHome()),
                    );
                  },
                  child: _buildWikiCategory(Icons.document_scanner, "Circular",
                      secondarycolor.withOpacity(0.7)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeeMangement()),
                    );
                  },
                  child: _buildWikiCategory(Icons.attach_money_rounded, "Fee management",
                      secondarycolor.withOpacity(0.7)),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarApp()),
                    );
                  },
                  child: _buildWikiCategory(Icons.calendar_today_sharp, "Calendar",
                      secondarycolor.withOpacity(0.7)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportCard()),
                    );
                  },
                  child: _buildWikiCategory(Icons.credit_card_outlined, "Report card",
                      secondarycolor.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildWikiCategory(IconData icon, String label, Color color) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width/2.2,
          padding: const EdgeInsets.all(26.0),
          alignment: Alignment.centerRight,
          child: Opacity(
              opacity: 0.3,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              )),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 17.0),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  //textStyle: Theme.of(context).textTheme.display1,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void showdialog(BuildContext context, item) {
    showGeneralDialog(
      barrierLabel: "Insightse",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: SizedBox.expand(
                child: Image.network(
              item,
              fit: BoxFit.fill,
            )),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Colors.yellow,
              Color(0xffffcc66),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo.jpeg',
            height: 180.0,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
