import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class loggeddata {
  String username;
  String password;
  String image;
  String status;
  String fullname;
  String classanddivision;
  String userid;
  loggeddata({this.password, this.username, this.image,this.status,this.classanddivision,this.fullname,this.userid});
}

List<loggeddata> Loggedinaccounts = [];
List<String> loggedindata;
Addaccounts(String name, String key, String image,String status,bool addnew, String fullname, String classanddivision,String userid) async {
  SharedPreferences data = await SharedPreferences.getInstance();
  loggedindata = data.getStringList('loggeddata');
  try {
    if (loggedindata.length > 0) {
      print("check1");
      print("accounts is adding");
      Loggedinaccounts = [];
      for (int i = 0; i < loggedindata.length; i++) {
        print(loggedindata[i]);
        var decodeddata = jsonDecode(loggedindata[i]);
        print("username"+decodeddata['username']);
        Loggedinaccounts.add(loggeddata(
            username: decodeddata['username'],
            password: decodeddata['password'],
            image: decodeddata['image'],
          status: decodeddata['status'],
          fullname: decodeddata['name'],
          classanddivision: decodeddata['classanddivision'],
          userid: decodeddata['userid'],
        ));
      }
      if(addnew){
        print("check2");
        bool userexits = false;
          for (int i = 0; i < Loggedinaccounts.length; i++) {
            if (Loggedinaccounts[i].username == name) {
              userexits = true;
            }
        }//"{\"org_id\":\"61\",\"batch_id\":\"132\",\"stud_mid\":\"15599\",\"iduser\":\"82775\",\"search\":\"\"}"
        if(!userexits){
          print("check3");
          Map<String, String> adddata = {
            'username': name,
            'password': key,
            "image": image,
            "status": status,
            "name":fullname,
            "classanddivision":classanddivision,
            "userid":userid,
          };
          loggedindata.add("${jsonEncode(adddata)}");
          data.setStringList('loggeddata', loggedindata);
          Loggedinaccounts.add(loggeddata(
              username: name, password: key, image: image, status: status,fullname: fullname,classanddivision: classanddivision,userid: userid));
        }
      }
    }
  } catch (e) {
    print("check4");
    Loggedinaccounts=[];
    print(e);
    print("add new : $addnew");
    if(addnew){
      print("check5");
      Map<String, String> adddata = {
        'username': name,
        'password': key,
        "image": image,
        "status": status,
        "name":fullname,
        "classanddivision":classanddivision,
        "userid":userid,
      };
      print("catch loop"+adddata.toString());
      data.setStringList('loggeddata', ["${jsonEncode(adddata)}"]);
      try{
        Loggedinaccounts.add(loggeddata(
            username: name,
            password: key,
            image: image,
            status: status,
            fullname: fullname,
            classanddivision: classanddivision,userid: userid));
      }catch(e){
        print("error while adding : $e");
      }
    }
  }
  print("number of accounts : " + "${Loggedinaccounts.length}");
}
