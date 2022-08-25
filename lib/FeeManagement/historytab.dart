import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Contsants.dart';
import '../online_classes/onlineUIupdated.dart';
import 'webveiw.dart';
import 'feeapi.dart';
import 'receipt.dart';
class HistoryTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FutureBuilder(
            future: getpaymenthistory(context),
            builder: (BuildContext context,
                AsyncSnapshot platformData) {
              if (platformData.hasData) {
                return feehistory.length > 0
                    ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: feehistory.length,
                    itemBuilder: (context, index) {
                      return PaymentHistory(
                          feedescription: feehistory[index].feedefinition,
                          fine: feehistory[index].fine,
                          background: borderyellow,
                          ontap: () {},
                          scheduledstartdate: feehistory[index].scheduledstartdate,
                          totalamount: feehistory[index].paid,
                          receipt: feehistory[index].receipt,
                          transactiondate: feehistory[index].transactiondate,
                          paymentmode: feehistory[index].paymentmode);
                    })
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
            })
      );
  }
}


class PaymentHistory extends StatefulWidget {
  String feedescription;
  String scheduledstartdate;
  String receipt;
  String transactiondate;
  String totalamount;
  String fine;
  String paymentmode;
  Function ontap;
  Color background;
  PaymentHistory(
      {this.feedescription,
        this.fine,
        this.background,
        this.ontap,
        this.scheduledstartdate,
        this.totalamount,
        this.receipt,
        this.transactiondate,
        this.paymentmode});
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
          margin: EdgeInsets.only(bottom: 10, left: 10),
          height: 150,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            color: secondarycolor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${widget.feedescription}",
                maxLines: null,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Scheduled Date : ${widget.scheduledstartdate}",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Mode : ${widget.paymentmode}",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Fine : ${widget.fine} ₹",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Amount : ${widget.totalamount} ₹",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Paid on : ${widget.transactiondate}",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: GestureDetector(
            onTap: () {
              print(widget.receipt);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Receipt(url:widget.receipt
                    )),
              );
            },
            child: Container(
                width: 150,
                margin: EdgeInsets.only(bottom: 10, left: 10),
                height: MediaQuery.of(context).size.width / 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: widget.background,
                ),
                child: Center(
                    child: Text(
                      "Receipt",
                      style: TextStyle(
                          color: secondarycolor, fontWeight: FontWeight.bold),
                    ))),
          ),
        ),
      ],
    );
  }
}