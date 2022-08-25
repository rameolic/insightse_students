import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import '../Contsants.dart';
import 'dart:convert';

Future<String> getattachmenturl(String path) async {
  var request = http.MultipartRequest("POST", Uri.parse(baseurl + "messenger/attachment"));
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Authorization':
    'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  request.headers.addAll(headers);
  Map<String, String> fields = {
    'org_id': '${Logindata.orgid}'
  };
    request.files.add(await http.MultipartFile.
    fromPath('file[]', path,)
    );
    request.fields.addAll(fields);
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.body);
  if(response.statusCode == 200){
    var decodeddata = jsonDecode(response.body);
    return decodeddata['attachment'];
  }else{
    var decodeddata = jsonDecode(response.body);
    print(decodeddata['msg'],);
    // Flushbar(
    //   message: decodeddata['msg'],
    //   icon: const Icon(
    //     Icons.info_outline,
    //     size: 20.0,
    //     color: secondarycolor,
    //   ),
    //   duration: const Duration(seconds: 4),
    //   leftBarIndicatorColor: secondarycolor,
    // ).show(context);
  }
}

class ProfilePage extends StatelessWidget {
  String profileimage;
  String name;
  String designation,department,gender,classname,division;
  ProfilePage({this.profileimage,this.name,this.designation,this.gender,this.department,this.classname,this.division});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
        ),
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "Profile",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: secondarycolor),
            )),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(profileimage,
            height: MediaQuery.of(context).size.height/4,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0,bottom: 10),
            child: SizedBox(
              height: 20,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Divider(
                        color: Colors.black45,
                        thickness: 0.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Text(
                      "Contact Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black45),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Divider(
                        color: Colors.black45,
                        thickness: 0.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                 name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: secondarycolor),
                  maxLines: 5,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "Designation : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    designation,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          if(department!="null")
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "Department : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    department,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          if(gender!="null")
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "Gender : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    gender,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          if(classname!="null")
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "Class : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    classname,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          if(division!="null")
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "Division : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    division,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
