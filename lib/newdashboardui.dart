import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'Contsants.dart';
import '../Notifications/notificationsDB.dart';
import 'more.dart';
import 'package:badges/badges.dart';
import '../circulars/circularhome.dart';
import 'online_classes/onlineUIupdated.dart';
import 'eventcalendar/calendarui.dart';
import 'messenger/api.dart';
import 'messenger/contacts_screen.dart';


class NewDashbBard extends StatefulWidget {
  int currentIndex;
  NewDashbBard({@required this.currentIndex});
  @override
  State<NewDashbBard> createState() => _NewDashbBardState();
}

class _NewDashbBardState extends State<NewDashbBard> {
  @override
  Widget build(BuildContext context) {
    print(widget.currentIndex);
    print('unreadcount : $unreadcount');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar:Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SalomonBottomBar(
            currentIndex: widget.currentIndex,
            onTap: (i) => setState(() => widget.currentIndex = i),
            items: [
              /// Home
              SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  selectedColor: secondarycolor,
                  unselectedColor: Colors.grey
              ),

              SalomonBottomBarItem(
                  icon: Badge(
                      badgeColor: Colors.red[900],
                      toAnimate: true,
                      showBadge: unreadcount == 0 ? false:true,
                      badgeContent: Text('$unreadcount',style: TextStyle(color: Colors.white),),
                      child: Icon(Icons.chat_outlined)),
                  title: Text("Messenger"),
                  selectedColor: secondarycolor,
                  unselectedColor: Colors.grey
              ),
              SalomonBottomBarItem(
                  icon: Icon(Icons.calendar_month),
                  title: Text("Event Calendar"),
                  selectedColor: secondarycolor,
                  unselectedColor: Colors.grey
              ),
              // SalomonBottomBarItem(
              //   icon:  Badge(
              //     badgeColor: Colors.red[900],
              //       badgeContent: Text('3',style: TextStyle(color: Colors.white),), child: Icon(CupertinoIcons.bell_fill)),
              //
              //     // icon:  Icon(CupertinoIcons.bell_fill),
              //   title: Text("  Notifications"),
              //   selectedColor: secondarycolor,
              //     unselectedColor: Colors.grey
              // ),
              SalomonBottomBarItem(
                  icon:  Icon(CupertinoIcons.bell_fill),

                  // icon:  Icon(CupertinoIcons.bell_fill),
                  title: Text("  Notifications"),
                  selectedColor: secondarycolor,
                  unselectedColor: Colors.grey
              ),
              // SalomonBottomBarItem(
              //   icon: Icon(Icons.credit_card_outlined),
              //   title: Text("Report card"),
              //   selectedColor: secondarycolor,
              // ),
            ],
          ),
        ),
        body: widget.currentIndex == 1
            ? ContactsScreen()
            : widget.currentIndex == 2
                ? CalendarApp()
                : widget.currentIndex == 3
                    ? NotificationHome()
                    : HomePage(),
      ),
    );
  }
}
