import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Contsants.dart';
import '../ProgressHUD.dart';
import 'carrerquestions.dart';
import 'careertestapi.dart';
import 'verbalreasoning.dart';
import 'workingmeomry.dart';
import 'Visualattention.dart';
import '../newdashboardui.dart';

final loading = new ValueNotifier(false);
class CareerTestDashBord extends StatelessWidget {
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
      child: ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, value, child) {
            return ProgressHUD(
              inAsyncCall: loading.value,
              opacity: 0.3,
              color: secondarycolor,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: _appBar(context),
                body: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white,
                    child: FutureBuilder(
                        future: Careerlist(context),
                        builder:
                            (BuildContext context, AsyncSnapshot platformData) {
                          if (platformData.hasData) {
                            return testlist.length > 0
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: testlist.length,
                                    itemBuilder: (context, index) {
                                      return CareerTestCard(
                                        index: index,
                                      );
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
                        })),
              ),
            );
          }),
    );
  }

  _appBar(context) {
    return AppBar(
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
      title: Text(
        "Career Test",
        style: TextStyle(color: secondarycolor),
      ),
      centerTitle: true,
    );
  }
}

class CareerTestCard extends StatelessWidget {
  int index;
  CareerTestCard({@required this.index});
  @override
  Widget build(BuildContext context) {
    print(index);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderyellow),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              testlist[index].title,
              style: TextStyle(
                color: CupertinoColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              softWrap: true,
              maxLines: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
              child: Text("Total question : ${testlist[index].totalquestion}"),
            ),
            Text("Time Limit : ${testlist[index].timelimit}"),
          ]),
        ),
        GestureDetector(
          onTap: () async {
            if (testlist[index].status != "Completed") {
              if(testlist[index].title.toString() == "Verbal Reasoning" ){
                loading.value = true;
                await getquestionsforverbalreasoning(testlist[index].quizid, testlist[index].testnumber, context);
                loading.value = false;
                questionnumber = testlist[index].answeredques + 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerbalReasUI(
                    index: index,
                    duration: (testlist[index].timelimit/testlist[index].totalquestion).round(),
                  )),
                );
              }else if(testlist[index].title.toString().contains("Working Memory")){
                loading.value = true;
                await getworkingmemoryquestions(testlist[index].quizid, testlist[index].testnumber, context);
                loading.value = false;
                questionnumber = testlist[index].answeredques + 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage(
                    index: index,
                    duration: (testlist[index].timelimit/testlist[index].totalquestion).round(),
                  )),
                );
              }
              else if(testlist[index].title.toString() == "Visual Attention"){
                loading.value = true;
                await getquestionsforVisualAttention(testlist[index].quizid, testlist[index].testnumber, context);
                loading.value = false;
                questionnumber = testlist[index].answeredques + 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualattentionUI(
                    index: index,
                    duration: (testlist[index].timelimit/testlist[index].totalquestion).round(),
                  )),
                );
              }else{
                loading.value = true;
                await getquestions(testlist[index].quizid, testlist[index].testnumber, context);
                loading.value = false;
                questionnumber = testlist[index].answeredques + 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CareerQuestionUI(
                    index: index,
                    duration: (testlist[index].timelimit/testlist[index].totalquestion).round(),
                  )),
                );
              }
            }
          },
          child: Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: testlist[index].status == "Completed"
                      ? borderyellow.withOpacity(0.35)
                      : testlist[index].status == "Start Test" ? secondarycolor : primarycolor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Center(
                  child: Text(
                testlist[index].status,
                style: TextStyle(color: testlist[index].status == "Completed"
                    ? Colors.black.withOpacity(0.35):CupertinoColors.white),
              ))),
        ),
      ],
    );
  }
}
