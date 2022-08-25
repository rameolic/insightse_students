import 'package:flutter/material.dart';
import '../Contsants.dart';
import 'schoolapis.dart';
class InformationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetSchoolInfo(context),
        builder: (BuildContext context, AsyncSnapshot platformData) {
          if (platformData.hasData) {
            return Column(
                children: [
                  if(data.show_orglogo == '1')
                    Material(
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0,bottom: 5),
                        child: Center(
                          child: Image.network(data.orglogo,fit: BoxFit.cover,
                            loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ?
                                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10.0),
                            //   child: Text(
                            //     "School Logo's :",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 16,
                            //         color: Colors.black),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10.0),
                            //   child: Text(
                            //     "School Detail's :",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 16,
                            //         color: Colors.black),
                            //   ),
                            // ),
                            if(data.show_name == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        data.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: secondarycolor),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_branch == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Branch : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.branch,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_code == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "School code : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.code,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_medium == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Medium : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.medium,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_affliatedto == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Affiliation : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.affliatedto,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_affliationno == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Affiliation No : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.show_affliationno,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_founddate == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Established on : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.founddate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: Text(
                                      "Contact Details :",
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

                            if(data.show_phone == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                                      child: Text(
                                        "Contact No : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: SelectableText(
                                        data.phone,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_alternateno == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Alternate No : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SelectableText(
                                        data.alternateno,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_email == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "E-mail : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SelectableText(
                                        data.email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_fax== "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Fax : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SelectableText(
                                        data.fax,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_website == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Website : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.website,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_educationaldistrict == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Educational District : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.educationaldistrict,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_district == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "District : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.districtname,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_state == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "State : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.statename,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_country == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Country : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.countryname,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_pincode== "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Pincode : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.pincode,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_address1 == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Address : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(data.address1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_address2 == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(data.address1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ),

                            SizedBox(
                              height: 10,
                            ),
                            if(data.show_founder == "1"|| data.show_president == "1"||data.show_vicepresident == "1"||data.show_chairman == "1"||data.show_principal == "1"||
                                data.show_viceprincipal == "1"||data.show_coordinator == "1")
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: Text(
                                      "Management Details :",
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
                            if(data.show_founder == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Founder : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.founder,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_president == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "President : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.president,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if(data.show_vicepresident == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Vice President : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.vicepresident,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_chairman == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Chairman : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.chairman,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_principal== "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Principal : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.principal,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_viceprincipal == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Vice Principal : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.viceprincipal,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(data.show_coordinator == "1")
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                                      child: Text(
                                        "Coordinator : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        data.coordinator,
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
                      ),
                    ),
                  ),
                ],
              );
          } else {
            return  Center(
                child: Image.asset("assets/volume-colorful.gif"));
          }
        });
  }
}
