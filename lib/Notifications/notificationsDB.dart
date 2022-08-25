import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Contsants.dart';
import 'notificationsapi.dart';

class NotificationHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: SizedBox(),
        backgroundColor: Colors.white,
        leadingWidth: 0,
        title: Center(
          child:
        Text(
          'Notifications',
          style: TextStyle(color: secondarycolor),
        ),
      )),
      body:

      FutureBuilder(
          future: notificationsapi(context),
          builder: (BuildContext context, AsyncSnapshot platformData) {
            if (platformData.hasData) {
              if (notificationlist.length > 0) {
                markreadstatus(context);
                return ListView.builder(
                  itemCount: notificationlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return notificationlist[index].historystatus == "1"?
                      Column(
                        mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: notificationlist[index].readstatus=='0' ?secondarycolor.withOpacity(0.7) :Colors.white
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          notificationlist[index].title,
                                          maxLines: 3,
                                          style: TextStyle(color: notificationlist[index].readstatus=='0'?borderyellow :secondarycolor,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          notificationlist[index].template_content,
                                          style: TextStyle(color:notificationlist[index].readstatus=='0' ?Colors.white :Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(notificationlist[index].readstatus=='0')
                                    ConstrainedBox(
                                      constraints: BoxConstraints(minHeight: 20),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red[900],
                                          radius: 3,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              if(notificationlist[index].time != null)
                                SizedBox(
                                  height: 5,
                                ),
                              if(notificationlist[index].time != null)
                                Text(
                                  notificationlist[index].time,
                                  style: TextStyle(
                                      color: notificationlist[index].readstatus=='0' ?borderyellow : secondarycolor,//borderyellow,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        )
                      ],
                    ):SizedBox();
                  });
              } else {
                return Center(
                  child: Text("No New Notifications"),
                );
              }
            } else {
              return  Center(
                  child: Image.asset("assets/volume-colorful.gif"));
            }
          }));
  }
}
