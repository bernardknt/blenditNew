import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/challenge_completed_page.dart';
import '../screens/challenge_active_list.dart';
import '../utilities/constants.dart';






class AppointmentsTabController extends StatefulWidget {
  static String id = 'tab_controller';


  @override
  _AppointmentsTabControllerState createState() => _AppointmentsTabControllerState();
}

class _AppointmentsTabControllerState extends State<AppointmentsTabController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
      Scaffold(

          appBar:
          AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 30,
            backgroundColor: kBackgroundGreyColor,
            // actions: [
            //   GestureDetector(
            //     onTap: (){
            //       // Navigator.pushNamed(context, SettingsPage.id);
            //     },
            //     child: Container(
            //         padding:EdgeInsets.all(7),child:
            //     Icon(CupertinoIcons.settings, color: Colors.grey,size: 20,)),
            //   )
            // ],
            // title: Center(child: Text("Stock Page", style: TextStyle(color: kBiegeThemeColor, fontSize: 13, fontWeight: FontWeight.bold),),),
            bottom: TabBar(
              indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [kGreenThemeColor, kBackgroundGreyColor]),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.redAccent),

              //indicatorColor: kPinkDarkThemeColor,
              labelColor: kBlueDarkColorOld,
              unselectedLabelColor: kFontGreyColor,
              tabs: [
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(LineIcons.calendarCheck, size: 20,),
                      SizedBox(width: 4,),
                      Text('Active')]
                ),),
                // ),),
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Iconsax.tick_circle, size: 16,),
                      SizedBox(width: 4,),
                      Text('Completed')]
                ),),
              ],
            ),
          ),
          body: WillPopScope(
            onWillPop: () async {
              return false; // return a `Future` with false value so this route cant be popped or closed.
            },
            child: TabBarView(
              children: [
                ChallengeActivePage(),
               ChallengeCompletedPage()

                // VisaPage(),
              ],
            ),
          )
      ),
    );
  }
}
