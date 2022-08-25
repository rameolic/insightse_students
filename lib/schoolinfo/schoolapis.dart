import 'package:flutter/cupertino.dart';
import '../Contsants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';

class Schoolinfo {
  String id,
      orgid,
      show_name,
      show_code,
      show_orgalias,
      show_affliatedto,
      show_affliationno,
      show_branch,
      show_phone,
      show_alternateno,
      show_email,
      show_website,
      show_orglogo,
      show_logourl,
      show_founddate,
      show_address1,
      show_address2,
      show_pincode,
      show_country,
      show_state,
      show_district,
      show_latlong,
      show_educationaldistrict,
      show_medium,
      show_fax,
      show_principal,
      show_founder,
      show_chairman,
      show_coordinator,
      show_viceprincipal,
      show_president,
      show_vicepresident,
      show_status,
      name,
      code,
      orgalias,
      affliatedto,
      affliationno,
      branch,
      phone,
      alternateno,
      email,
      website,
      orglogo,
      logourl,
      founddate,
      address1,
      address2,
      pincode,
      country,
      state,
      district,
      latlong,
      educationaldistrict,
      medium,
      fax,
      principal,
      founder,
      chairman,
      coordinator,
      viceprincipal,
      president,
      vicepresident,
      districtname,
      statename,
      countryname,
      status;
  Schoolinfo(
      {this.id,
      this.orgid,
      this.show_name,
      this.show_code,
      this.show_orgalias,
      this.show_affliatedto,
      this.show_affliationno,
      this.show_branch,
      this.show_phone,
      this.show_alternateno,
      this.show_email,
      this.show_website,
      this.show_orglogo,
      this.show_logourl,
      this.show_founddate,
      this.show_address1,
      this.show_address2,
      this.show_pincode,
      this.show_country,
      this.show_state,
      this.show_district,
      this.show_latlong,
      this.show_educationaldistrict,
      this.show_medium,
      this.show_fax,
      this.show_principal,
      this.show_founder,
      this.show_chairman,
      this.show_coordinator,
      this.show_viceprincipal,
      this.show_president,
      this.show_vicepresident,
      this.show_status,
      this.name,
      this.code,
      this.orgalias,
      this.affliatedto,
      this.affliationno,
      this.branch,
      this.phone,
      this.alternateno,
      this.email,
      this.website,
      this.orglogo,
      this.logourl,
      this.founddate,
      this.address1,
      this.address2,
      this.pincode,
      this.country,
      this.state,
      this.district,
      this.latlong,
      this.educationaldistrict,
      this.medium,
      this.fax,
      this.principal,
      this.founder,
      this.chairman,
      this.coordinator,
      this.viceprincipal,
      this.president,
      this.vicepresident,
      this.status,
      this.countryname,
      this.districtname,
      this.statename});
}

Schoolinfo data;
Future<bool> GetSchoolInfo(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {};
  http.Response response = await http.post(
      Uri.parse(baseurl + "school/display_info/${Logindata.orgid}"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    try {
      data = Schoolinfo(
        id: decodeddata['data']['id'],
        orgid: decodeddata['data']['org_id'],
        show_name: decodeddata['data']['is_org_name'],
        show_code: decodeddata['data']['is_org_code'],
        show_orgalias: decodeddata['data']['is_org_alias'],
        show_affliatedto: decodeddata['data']['is_affliate_to'],
        show_affliationno: decodeddata['data']['is_affliation_no'],
        show_branch: decodeddata['data']['is_branch_name'],
        show_phone: decodeddata['data']['is_org_phone'],
        show_alternateno: decodeddata['data']['is_org_phone_alternative'],
        show_email: decodeddata['data']['is_org_email'],
        show_website: decodeddata['data']['is_org_website'],
        show_orglogo: decodeddata['data']['is_org_logo'],
        show_logourl: decodeddata['data']['is_logo_url'],
        show_founddate: decodeddata['data']['is_org_found_date'],
        show_address1: decodeddata['data']['is_org_address_line1'],
        show_address2: decodeddata['data']['is_org_address_line2'],
        show_pincode: decodeddata['data']['is_org_pincode'],
        show_country: decodeddata['data']['is_org_pincode'],
        show_state: decodeddata['data']['is_org_state'],
        show_district: decodeddata['data']['is_org_district'],
        show_latlong: decodeddata['data']['is_org_lat_lng'],
        show_educationaldistrict: decodeddata['data']
            ['is_educational_district'],
        show_medium: decodeddata['data']['is_medium'],
        show_fax: decodeddata['data']['is_fax'],
        show_principal: decodeddata['data']['is_principal_id'],
        show_founder: decodeddata['data']['is_founder_id'],
        show_chairman: decodeddata['data']['is_chairman_id'],
        show_coordinator: decodeddata['data']['is_coordinator_id'],
        show_viceprincipal: decodeddata['data']['is_vice_principal_id'],
        show_president: decodeddata['data']['is_president_id'],
        show_vicepresident: decodeddata['data']['is_vice_president_id'],
        show_status: decodeddata['data']['is_status'],
        name: decodeddata['data']['org_name'],
        code: decodeddata['data']['org_code'],
        orgalias: decodeddata['data']['org_alias'],
        affliatedto: decodeddata['data']['affliate_type'],
        affliationno: decodeddata['data']['affliation_no'],
        branch: decodeddata['data']['branch_name'],
        phone: decodeddata['data']['org_phone'],
        alternateno: decodeddata['data']['org_phone_alternative'],
        email: decodeddata['data']['org_email'],
        website: decodeddata['data']['org_website'],
        orglogo: decodeddata['data']['org_logo'],
        logourl: decodeddata['data']['logo_url'],
        founddate: decodeddata['data']['org_found_date'],
        address1: decodeddata['data']['org_address_line1'],
        address2: decodeddata['data']['org_address_line2'],
        pincode: decodeddata['data']['org_pincode'],
        country: decodeddata['data']['org_country'],
        state: decodeddata['data']['org_state'],
        district: decodeddata['data']['org_district'],
        latlong: decodeddata['data']['org_lat_lng'],
        educationaldistrict: decodeddata['data']['educational_district'],
        medium: decodeddata['data']['lang'],
        fax: decodeddata['data']['fax'],
        principal: decodeddata['data']['pi_name'],
        founder: decodeddata['data']['founder'],
        chairman: decodeddata['data']['chairman'],
        coordinator: decodeddata['data']['coordinator'],
        viceprincipal: decodeddata['data']['vice_principal'],
        president: decodeddata['data']['president'],
        vicepresident: decodeddata['data']['vice_president'],
        status: decodeddata['data']['is_status'],
        districtname: decodeddata['data']['district_name'],
        statename: decodeddata['data']['state_name'],
        countryname: decodeddata['data']['country_name'],
      );
      return true;
    } catch (e) {
      Flushbar(
        message: "${decodeddata['data']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )..show(context);
      return false;
    }
  } else {
    Flushbar(
      message:
          "ERROR while connecting server Status code : ${response.statusCode}",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )..show(context);
  }
  return false;
}

List<event> gallerydata = [];
List<resource> resourcedata = [];

class event {
  String title;
  List<String> images;
  event({this.images, this.title});
}

Future<bool> GetGallery(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {};
  http.Response response = await http.post(
      Uri.parse(baseurl + "school/display_gallery/${Logindata.orgid}"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    gallerydata = [];
    List<String> imagedata = [];
    var decodeddata = jsonDecode(response.body);
    try {
      for (int i = 0; i < decodeddata['data'].length; i++) {
        if (decodeddata['data'][i]["img_url"] == '0') {
          gallerydata.add(event(
            title: decodeddata['data'][i]["heading_name"],
            images: [],
          ));
        }
      }
      int length = gallerydata.length;
      for(int j = 0; j < length; j++){
        List<String>image=[];
        for (int i = 0; i < decodeddata['data'].length; i++) {
          if (decodeddata['data'][i]["img_url"] != '0') {
            if(decodeddata['data'][i]["heading_name"] ==gallerydata[j].title){
              image.add(decodeddata['data'][i]["img_url"]);
            }
          }
        }
        gallerydata[j].images=image;
      }
      // print(i);
        // if (decodeddata['data'][i]["img_url"] != '0') {
        //   if (headerchanged) {
        //     print("came in header changed");
        //     gallerydata.add(event(
        //       title: decodeddata['data'][i - 2]["heading_name"],
        //       images: imagedata,
        //     ));
        //     imagedata = ["${decodeddata['data'][i]["img_url"]}"];
        //     headerchanged = false;
        //   } else {
        //     imagedata.add(decodeddata['data'][i]["img_url"]);
        //     if (i + 1 == decodeddata['data'].length) {
        //       print("came in");
        //       gallerydata.add(event(
        //         title: decodeddata['data'][i]["heading_name"],
        //         images: imagedata,
        //       ));
        //     }
        //   }
        // } else {
        //   if (i != 0) {
        //     headerchanged = true;
        //   }
        // }
     // }
      print(gallerydata.length.toString() + " ikkadaa mowaa");
      return true;
    } catch (e) {
      Flushbar(
        message: "${decodeddata['data']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )..show(context);
      return false;
    }
  } else {
    Flushbar(
      message:
          "ERROR while connecting server Status code : ${response.statusCode}",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )..show(context);
  }
  return false;
}

class resource {
  String title;
  List<attachement> attachments;
  resource({
    this.attachments,
    this.title,
  });
}

class attachement {
  String name;
  String attachmnet;
  attachement({this.name, this.attachmnet});
}

Future<bool> Getresources(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {};
  print(Logindata.orgid);
  http.Response response = await http.post(
      Uri.parse(baseurl + "school/display_resource/${Logindata.orgid}"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    resourcedata = [];
    var decodeddata = jsonDecode(response.body);
    try {
      for (int i = 0; i < decodeddata['data'].length; i++) {
        if (decodeddata['data'][i]["resource_url"] == '0') {
          resourcedata.add(resource(
            title: decodeddata['data'][i]["heading_name"],
            attachments: [],
          ));
        }
      }
      int length = resourcedata.length;
      for(int j = 0; j < length; j++){
        List<attachement>attachmentlist=[];
        for (int i = 0; i < decodeddata['data'].length; i++) {
          if (decodeddata['data'][i]["resource_url"] != '0') {
            if(decodeddata['data'][i]["heading_name"] ==resourcedata[j].title){
              attachmentlist.add(attachement(
                  attachmnet: decodeddata['data'][i]["resource_url"],
                  name: decodeddata['data'][i]["resource_name"]));
            }
          }
        }
        resourcedata[j].attachments=attachmentlist;
      }
      return true;
      //
      // bool headerchanged = false;
      // for (int i = 0; i < decodeddata['data'].length; i++) {
      //   print(i);
      //   if (decodeddata['data'][i]["resource_url"] != '0') {
      //     if (headerchanged) {
      //       print("came in header changed");
      //       resourcedata.add(resource(
      //         title: decodeddata['data'][i - 2]["heading_name"],
      //         attachments: attachmentlist,
      //       ));
      //       attachmentlist = [
      //         attachement(
      //             attachmnet: decodeddata['data'][i]["resource_url"],
      //             name: decodeddata['data'][i]["resource_name"])
      //       ];
      //       headerchanged = false;
      //     } else {
      //       attachmentlist.add(attachement(
      //           attachmnet: decodeddata['data'][i]["resource_url"],
      //           name: decodeddata['data'][i]["resource_name"]));
      //       if (i + 1 == decodeddata['data'].length) {
      //         print("came in");
      //         resourcedata.add(resource(
      //           title: decodeddata['data'][i]["heading_name"],
      //           attachments: attachmentlist,
      //         ));
      //       }
      //     }
      //   } else {
      //     if (i != 0 && resourcedata.length > 0) {
      //       headerchanged = true;
      //     }
      //   }
      // }
      // return true;
    } catch (e) {
      Flushbar(
        message: "${decodeddata['data']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )..show(context);
      return false;
    }
  } else {
    Flushbar(
      message:
          "ERROR while connecting server Status code : ${response.statusCode}",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )..show(context);
  }
  return false;
}

class social {
  String fb;
  String insta;
  String twitter;
  String linkdln;
  bool showfb;
  bool showinsta;
  bool showtwitter;
  bool showlinkdln;
  social(
      {this.fb,
      this.insta,
      this.linkdln,
      this.showfb,
      this.showinsta,
      this.showlinkdln,
      this.showtwitter,
      this.twitter});
}
social socialmediadata;
Future<bool> GetSocialLinks(context) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${Logindata.usertoken}' + '_ie_' + '${Logindata.userid}'
  };
  Map inputbody = {};
  http.Response response = await http.post(
      Uri.parse(baseurl + "school/display_social/${Logindata.orgid}"),
      headers: headers,
      body: jsonEncode(inputbody));
  print("response : ${response.body}");
  if (response.statusCode == 200) {
    var decodeddata = jsonDecode(response.body);
    print("mowa: ${decodeddata['is_instagram'].toString()}");
    try {
      socialmediadata = social(
        showfb: decodeddata['data'][0]['is_facebook'].toString()=="1"?true:false,
        showinsta: decodeddata['data'][0]['is_instagram'].toString()=="1"?true:false,
        showlinkdln: decodeddata['data'][0]['is_linkedin'].toString()=="1"?true:false,
        showtwitter: decodeddata['data'][0]['is_twitter'].toString()=="1"?true:false,
        fb: decodeddata['data'][0]['facebook'],
        insta: decodeddata['data'][0]['instagram'],
        twitter: decodeddata['data'][0]['twitter'],
        linkdln: decodeddata['data'][0]['linkedin']
      );
      return true;
    } catch (e) {
      Flushbar(
        message: "${decodeddata['data']}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: secondarycolor,
        ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: secondarycolor,
      )..show(context);
      return false;
    }
  } else {
    Flushbar(
      message:
          "ERROR while connecting server Status code : ${response.statusCode}",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: secondarycolor,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: secondarycolor,
    )..show(context);
  }
  return false;
}
