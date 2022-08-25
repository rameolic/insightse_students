import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ProgressHUD.dart';
import 'feeapi.dart';
import '../Contsants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'webveiw.dart';

List<String> category = ["First term", "Second term", "Third term"];
TextEditingController _controller;

class PayableTab extends StatelessWidget {
  final terms = new ValueNotifier(false);
  final loading = new ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) {
          return ProgressHUD(
            inAsyncCall: loading.value,
            opacity: 0.3,
            color: secondarycolor,
            child: FutureBuilder(
                      future: getpayablefee(context),
                      builder:
                          (BuildContext context, AsyncSnapshot platformData) {
                        if (platformData.hasData) {
                          _controller = new TextEditingController(
                              text: "$totalpayableamount");
                          return feesdata.length > 0
                              ? Column(
                                  children: [
                                    Card(
                                      elevation: 3,
                                      child: Column(
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                              primarySwatch: Colors.blueGrey,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: TextFormField(
                                                readOnly: !caneditfeee,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: _controller,
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                decoration: new InputDecoration(
                                                  labelText: "Payable Amount",
                                                  labelStyle: TextStyle(
                                                    color: secondarycolor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                  focusColor: primarycolor,
                                                  hintStyle: TextStyle(
                                                    color: grey,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                //expands: true,
                                              ),
                                            ),
                                          ),
                            ValueListenableBuilder<bool>(
                            valueListenable: terms,
                            builder: (context, value, child) {
                            return SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Theme(
                                                      data: ThemeData(
                                                        primarySwatch:
                                                            Colors.teal,
                                                      ),
                                                      child: Checkbox(
                                                          value: terms.value,
                                                          onChanged: (value) {
                                                            terms.value = value;
                                                          }),
                                                    ),
                                                    Text(
                                                      "Agree",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        launch(
                                                            termandcondtions);
                                                      },
                                                      child: Text(
                                                        "Terms and conditions",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color:
                                                                secondarycolor,
                                                            fontSize: 15,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    loading.value = true;
                                                    payabledata data =
                                                        payabledata(
                                                            amount: _controller
                                                                .text,
                                                            feeid:
                                                                feeidforpayment,
                                                            emis: emiidforpayment == "" ? 0 : emiidforpayment,
                                                            concession:
                                                                totalconcession
                                                                    .toString(),
                                                            fine: totalfine
                                                                .toString());
                                                    bool proceed =
                                                        await getpaymenturl(data, context);
                                                    loading.value = false;
                                                    if (proceed) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Webveiw(
                                                                      url:
                                                                          paymenturl,
                                                                    )),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                      color: terms.value
                                                          ? secondarycolor
                                                          : grey,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 15),
                                                      child: Text(
                                                        "Pay Now",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                              ],
                                            ),
                                          );}),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: feesdata.length,
                                          itemBuilder: (context, index) {
                                            return Payablefee(
                                              termname:
                                                  feesdata[index].timeline,
                                              feedata:
                                                  feesdata[index].timelinedata,
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Image.asset(
                                  'assets/urlnot.png',
                                  width: MediaQuery.of(context).size.width,
                                ));
                        } else {
                          return Center(
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: secondarycolor,
                                  )));
                        }
                      }),
          );
        });
  }
}

class Payablefee extends StatefulWidget {
  String termname;
  List<Feedata> feedata;
  Payablefee({this.termname, this.feedata});

  @override
  State<Payablefee> createState() => _PayablefeeState();
}

class _PayablefeeState extends State<Payablefee> {
  final showamountcontroller = new ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: showamountcontroller,
        builder: (context, value, child) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  showamountcontroller.value = !showamountcontroller.value;
                },
                child: Row(
                  children: [
                    Icon(
                      showamountcontroller.value
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right_outlined,
                      color: secondarycolor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        widget.termname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              if (showamountcontroller.value)
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: borderyellow,style: BorderStyle.solid),
                  //     borderRadius: BorderRadius.circular(15)
                  // ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      scrollDirection: Axis.vertical,
                      itemCount: widget.feedata.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Fee Details :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: secondarycolor),
                                      ),
                                      if (widget.feedata[index].paymentstatus ==
                                          "Upcoming")
                                        CheckStatus(
                                          feevalue: double.parse(widget
                                                  .feedata[index].totalamount
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(','), '')) -
                                              double.parse(widget
                                                  .feedata[index].scholarship
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(','), '')) +
                                              double.parse(widget
                                                  .feedata[index].fine
                                                  .toString()
                                                  .replaceAll(RegExp(','), '')
                                                  .replaceAll(RegExp('-'), '')),
                                          isupcomining: widget.feedata[index]
                                                      .paymentstatus ==
                                                  "Upcoming"
                                              ? true
                                              : false,
                                          emiid:widget
                                              .feedata[index].emiid,
                                          feeid: widget
                                              .feedata[index].feeid,
                                        ),
                                      if (widget.feedata[index].paymentstatus !=
                                          "Upcoming")
                                      Checkbox(
                                        value: true,
                                        activeColor: secondarycolor,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 5),
                                  child: Text(
                                    widget.feedata[index].headername,
                                    softWrap: true,
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10),
                                  child: Text(
                                    widget.feedata[index].feedefinition,
                                    softWrap: true,
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Schedule Start date : ",
                                        style: TextStyle(
                                            color: secondarycolor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.feedata[index].scheduledate,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Due date : ",
                                        style: TextStyle(
                                            color: secondarycolor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.feedata[index].duedate,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 5, 5),
                                            child: Text(
                                              "Applicable",
                                              style: TextStyle(
                                                  color: secondarycolor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 5, 5),
                                            child: Text(
                                              "Fine  ",
                                              style: TextStyle(
                                                  color: secondarycolor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        if("${widget.feedata[index].scholarship}" != "0")
                                          SizedBox(),

                                        if("${widget.feedata[index].scholarship}" == "0")
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 5, 5),
                                            child: Text(
                                              "Scholarship",
                                              style: TextStyle(
                                                  color: secondarycolor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              "${widget.feedata[index].totalamount} ₹",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              "${widget.feedata[index].fine.replaceAll(RegExp('-'), '')} ₹",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        if("${widget.feedata[index].scholarship}" == "0")
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              "${widget.feedata[index].scholarship} ₹",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        if("${widget.feedata[index].scholarship}" != "0")
                                          SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 5,
                                      bottom: 5,
                                      right: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Amount :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: secondarycolor),
                                      ),
                                      Text(
                                        "${double.parse(widget.feedata[index].totalamount.toString().replaceAll(RegExp(','), '')) - double.parse(widget.feedata[index].scholarship.toString().replaceAll(RegExp(','), '')) + double.parse(widget.feedata[index].fine.toString().replaceAll(RegExp(','), '').replaceAll(RegExp('-'), ''))} ₹",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                if (index != widget.feedata.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 0.3,
                                    ),
                                  )
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      radius: 3,
                                      backgroundColor:
                                          widget.feedata[index].paymentstatus ==
                                                  "Due"
                                              ? Colors.redAccent
                                              : primarycolor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.feedata[index].paymentstatus,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: widget.feedata[index]
                                                      .paymentstatus ==
                                                  "Due"
                                              ? Colors.redAccent
                                              : primarycolor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
            ],
          );
        });
  }
}

class CheckStatus extends StatefulWidget {
  bool isupcomining;
  double feevalue;
  String emiid;
  String feeid;
  CheckStatus({this.feevalue, this.isupcomining, this.emiid,this.feeid});
  @override
  State<CheckStatus> createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  @override
  bool checkvalue = false;
  Widget build(BuildContext context) {
    return Checkbox(
        value: checkvalue,
        activeColor: secondarycolor,
        onChanged: (value) {
          if (widget.isupcomining) {
            try {
              double value = double.parse(_controller.text);
              setState(() {
                checkvalue = !checkvalue;
              });
              if (checkvalue) {
                _controller.text = (value + widget.feevalue).toString();
                if(emiidforpayment==""){
                  emiidforpayment ="${widget.emiid}";
                }else{
                  emiidforpayment = emiidforpayment + "-${widget.emiid}";
                }
                if(feeidforpayment==""){
                  feeidforpayment = "${widget.feeid}";
                }else{
                  feeidforpayment = feeidforpayment + "-${widget.feeid}";
                }
              } else {
                _controller.text = (value - widget.feevalue).toString();
                emiidforpayment = !emiidforpayment.contains("-")?emiidforpayment.replaceFirst("${widget.emiid}", "") :emiidforpayment.replaceFirst("-${widget.emiid}", "");
                feeidforpayment = !feeidforpayment.contains("-")?feeidforpayment.replaceFirst("${widget.feeid}", "") :feeidforpayment.replaceFirst("-${widget.feeid}", "");
              }
              print("emi : $emiidforpayment");
              print("fee : $feeidforpayment");
            } catch (e) {
              print(e);
            }
          }
        });
  }
}
