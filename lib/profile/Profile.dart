import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../sign_in/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
//import 'package:slimy_card/slimy_card.dart';
//import 'package:shimmer/shimmer.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../newdashboardui.dart';

import '../Contsants.dart';

class ProfilePage extends StatefulWidget {
     // ignore: non_constant_identifier_names
  final String username,masterid, batchid, classid, date, orgid,userid,fixedurl,profileimage,user_token;

  ProfilePage(this.username,this.masterid, this.batchid, this.classid, this.date, this.orgid,this.userid,this.fixedurl,this.profileimage,this.user_token
      );

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var currentTheme = APP_THEME.LIGHT;
  var data;
  var username,
      gen,
      dob,
      userid,
      // ignore: non_constant_identifier_names
      admission_no,
      // ignore: non_constant_identifier_names
      father_name,
      // ignore: non_constant_identifier_names
      mother_name,
      // ignore: non_constant_identifier_names
      sms_number,
      // ignore: non_constant_identifier_names
      curr_class,
      // ignore: non_constant_identifier_names
      curr_division,
      // ignore: non_constant_identifier_names
      notification_email,
      // ignore: non_constant_identifier_names
      login_status,
      // ignore: non_constant_identifier_names
      last_visited_at;
  
  getdata() async {
    print(widget.profileimage);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
       "Authorization": "Bearer ${widget.user_token}_ie_"+"${widget.userid}",
    };
    var response = await http.post(
        Uri.parse(baseurl+"user/myprofile"),
        headers: headers,
        body: jsonEncode({"master_id": widget.masterid}));
    print(response.body);
    this.setState(() {
      data = json.decode(response.body);
    });
    if (response.statusCode == 200) {
      String res = response.body;
      var resjson = json.decode(res);
      userid = resjson['data']['username'];
      username = resjson['data']['full_name'];
      gen = resjson['data']['gender'];
      dob = resjson['data']['dob'];
      curr_division = resjson['data']['curr_division'];
      admission_no = resjson['data']["admission_no"];
      father_name = resjson['data']['father_name'];
      mother_name = resjson['data']['mother_name'];
      sms_number = resjson['data']["sms_number"];
      curr_class = resjson['data']["curr_class"];
      notification_email = resjson['data']["notification_email"];
      login_status = resjson['data']["login_status"];
      last_visited_at = resjson['data']["last_visited_at"];
      print(userid);
      setState(() {});
    } else if (response.statusCode == 404) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    } else {
      print("something went wrong ${response.statusCode}");
    }
    //jio = iop["data"]["idstudent_parent"];
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  // ignore: non_constant_identifier_names
  Widget UI12(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await getunreadcount();
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: buildBodyWidget(),
          //FAB
          // ignore: missing_required_param
          // floatingActionButton: FloatingActionButton(
          //   child: IconButton(
          //     icon: Icon(Icons.wb_sunny),
          //     onPressed: () {
          //       setState(() {
          //         currentTheme == APP_THEME.DARK
          //             ? currentTheme = APP_THEME.LIGHT
          //             : currentTheme = APP_THEME.DARK;
          //       });
          //     },
          //   ),
          //   mini: true,
          // ),
        ),
      ),
    );
  }

  Widget buildBodyWidget() {
    return ListView(
      padding: EdgeInsets.fromLTRB(10,0,10,0),
      children: [
        Card(
          color: borderyellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10,10,0,10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  backgroundImage: widget.fixedurl =="null"?AssetImage("assets/90.png",):NetworkImage(widget.profileimage),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username==null?"Loading...":"$username",
                        style: TextStyle(
                          fontSize: 16.5,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userid==null?"Loading...":"$userid",
                        style: TextStyle(
                          fontSize: 16.5,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        //Container for action items
        // Container(
        //   margin: EdgeInsets.only(top: 8, bottom: 8),
        //   child: profileActionsItems(),
        // ),
        SizedBox(height: 10,),
        //Mobile phone number
        schooldetails(),
        Divider(color: Colors.grey),
        farthersdetails(),
        Divider(color: Colors.grey),
        motherdetail(),
        Divider(color: Colors.grey),
        mobilePhoneListTile(),
        Divider(color: Colors.grey),
        //Other phone number"
        dob12(),
        Divider(color: Colors.grey),
        gender(),
        Divider(color: Colors.grey),
        //Email
        emailListTile(),
       
      ],
    );
  }

//Profile Items
  Widget profileActionsItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //"Call" action item
        //     buildCallButton(),
        //"Text" action item
        //     buildTextButton(),
        //"Video" action item
        //buildVideoCallButton(),
        //"Email" action item
        //   buildEmailButton(),
        //"Directions" action item
        // buildDirectionsButton(),
      ],
    );
  }

//Adding "Call" action item
  Widget buildCallButton() {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.call,
          ),
          onPressed: () {
            launch("tel://$sms_number");
          },
        ),
        Text("Call"),
      ],
    );
  }

//Adding "Text" action item
  Widget buildTextButton() {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
          ),
          onPressed: () {
            launch("sms://$sms_number");
          },
        ),
        Text("Text"),
      ],
    );
  }

//Adding "Video" action item
  Widget buildVideoCallButton() {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () {},
        ),
        Text("Video"),
      ],
    );
  }

//Adding "Email" action item
  Widget buildEmailButton() {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.email,
          ),
          onPressed: () {
            launch("mailto:$notification_email");
          },
        ),
        Text("Email"),
      ],
    );
  }

//Adding "Directions" action item
  Widget buildDirectionsButton() {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.directions,
          ),
          onPressed: () {},
        ),
        Text("Directions"),
      ],
    );
  }

//Adding "Mobile phone number" item
  Widget mobilePhoneListTile() {
    return ListTile(
      leading: Icon(
        Icons.phone_android,
        //color: Colors.yellow,
      ),
      title: Text("Mobile"),
      subtitle: Text(
        sms_number==null?"Loading...":"+91-$sms_number",
        style: TextStyle(
            //fontFamily: 'Nunito',
            // color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

//Adding "Other phone number" item
  Widget motherdetail() {
    return ListTile(
      leading: Icon(Icons.group),
      title: Text("Mother Name"),
      subtitle: Text(
         mother_name==null?"Loading...":"Mrs.$mother_name",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget dob12() {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text("Date of Birth"),
      subtitle: Text(
         dob==null?"Loading...":"$dob",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget farthersdetails() {
    return ListTile(
      leading: Icon(Icons.group),
      title: Text("Father Name"),
      subtitle: Text(
        father_name==null?"Loading...":"Mr.$father_name",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget gender() {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text("Gender"),
      subtitle: Text(
        gen==null?"Loading...":"$gen",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

//Adding "Email" item
  Widget emailListTile() {
    return ListTile(
      leading: Icon(Icons.email),
      title: Text("Email"),
      subtitle: Text(
        notification_email==null?"Loading...":"$notification_email",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget schooldetails() {
    return ListTile(
      leading: Icon(Icons.home_work),
      title: Text("Academic Details"),
      subtitle: Text(
        admission_no==null?"Loading...":"Admission Number : $admission_no\nClass : $curr_class\nDivison : $curr_division",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

//Adding "Adress" item
  Widget loginstatus() {
    return ListTile(
      leading: Icon(Icons.tap_and_play),
      title: Text("Login Details"),
      subtitle: Text(
        "Logged In : $login_status \nLast Visted at: $last_visited_at",
        style: TextStyle(
            // fontFamily: 'Nunito',
            //color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  // This widget will be passed as Top Card's Widget.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () async{
                await getunreadcount();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    NewDashbBard(
                      currentIndex: 0,
                    )), (Route<dynamic> route) => false);
              },
              child: Icon(
                Icons.arrow_back_ios_sharp,
                color: secondarycolor,// add custom icons also
              ),
            ),
            title: Text(
              "Profile",
             style: GoogleFonts.nunito(
                    //textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 20.0,
                    color: secondarycolor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
            ),
            centerTitle: true,
            // backgroundColor: Colors.yellow[600],
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black54, Colors.red[200], Colors.red],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft),
            ),
            child: UI12(context),
          )),
    );
  }
}

enum APP_THEME { LIGHT, DARK }

class AppThemes {
  static ThemeData appThemeLight() {
    return ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.indigo.shade800,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.yellow[600],
        ),
        //Theme for FAB
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          //White background
          backgroundColor: Colors.yellow,

          //Black plus (+) sign for FAB
          foregroundColor: Colors.black,
        ));
  }

  static ThemeData appThemeDark() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.orange,
      ),
      //Theme for FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        //dark background for FAB
        backgroundColor: Colors.black,

        //White plus (+) sign for FAB
        foregroundColor: Colors.white,
      ),
    );
  }
}
