import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Contsants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'feeapi.dart';

class DetailsTab extends StatelessWidget {
  int totaltotalfee = 90000;
  int totalfinetilldate = 2500;
  int totalapplicablefee = 30000;
  int totalpaid = 28000;
  int currentlypayable = 20000;
  int currentpayablefee = 20000;
  int currentpayablefine = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdetails(context),
        builder: (BuildContext context,
            AsyncSnapshot platformData) {
          if (platformData.hasData) {
            return StudentInfo(
              totalfee: feedetailsdata.totalfee,
              totalfinetilldate: feedetailsdata.finetilldate,
              totalapplicablefee: feedetailsdata.totalApplicablefee,
              totalpaid: feedetailsdata.totalpaid,
              currentlypayable: feedetailsdata.totalpayable,
              currentlypayablefee: feedetailsdata.payablefee,
              currentlypayablefine: feedetailsdata.payablefine,
            );
          } else {
            return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: secondarycolor,
                    )));
          }
        });
  }
}


class StudentInfo extends StatelessWidget {
  double totalfee;
  double totalfinetilldate;
  double totalapplicablefee;
  double totalpaid;
  double currentlypayable;
  double currentlypayablefee;
  double currentlypayablefine;
  StudentInfo(
      {
        this.totalfee,
        this.totalfinetilldate,
        this.totalapplicablefee,
        this.totalpaid,
        this.currentlypayable,
        this.currentlypayablefee,
        this.currentlypayablefine});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Table(
            children: [
              TableRow(
                children: [
                  Column(
                    children: [
                      Text(
                        "Total Fee   ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600,color: Colors.grey.shade400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$totalfee ₹",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Total Applicable Fee   ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600,color: Colors.grey.shade400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$totalapplicablefee ₹",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Column(
                      children: [
                        Text(
                          "Total Fine Till date   ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600,color: Colors.grey.shade400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$totalfinetilldate ₹",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Column(
                      children: [
                        Text(
                          "Total Paid   ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600,color: Colors.grey.shade400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$totalpaid ₹",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          CircularPercentIndicator(
            animation: true,
            radius: MediaQuery.of(context).size.width/2.3,
            percent: totalfee<1?1:(totalpaid/(totalfee)) > 1.0 ? 0.0 : (totalpaid/(totalfee)),
            lineWidth: 16,
            backgroundColor: Colors.grey.shade200,//borderyellow,
            progressColor: secondarycolor,
            circularStrokeCap: CircularStrokeCap.round,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Text(
                  totalfee<1?"100%":
                  "${((totalpaid/totalfee)*100).toStringAsFixed(0)}%",
                  style:
                  new TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
                ),
                Text(
                  "Paid till date",
                  style:
                  new TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0,color: Colors.grey.shade400),
                ),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: new Text(
                "Fee Payment Progress",
                style:
                new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Divider(color: Colors.black,thickness: 0.3,),
                  ),
                ),
                  Text("Currently Payable",style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: secondarycolor
                  ),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                      child: Divider(color: Colors.black,thickness: 0.3,),
                    ),
                  )
              ],
              ),
              SizedBox(height: 10,),
              Table(
                columnWidths: {
                  0: FractionColumnWidth(.23),
                  1: FractionColumnWidth(.3),
                  2: FractionColumnWidth(.23),
                  3: FractionColumnWidth(.24),
                },
                children: [
                  TableRow(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Fee  ",
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if("${feedetailsdata.scholarshipcurrently}" != "0.0")
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Scholarship  ",
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Fine  ",
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Payable  ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Center(
                        child: Text(
                          "$currentlypayablefee ₹",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      if("${feedetailsdata.scholarshipcurrently}" != "0.0")
                      Center(
                        child: Text(
                          "${feedetailsdata.scholarshipcurrently} ₹",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Center(
                        child: Text(
                          "$currentlypayablefine ₹",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Center(
                        child: Text(
                          "$currentlypayable ₹",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}