import 'package:blendit_2022/screens/tutorials_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/challenge_completed_page.dart';
import '../screens/challenge_active_list.dart';
import '../screens/new_settings.dart';
import '../utilities/constants.dart';






class SettingsTabController extends StatefulWidget {
  static String id = 'settings_tab_controller';


  @override
  _SettingsTabControllerState createState() => _SettingsTabControllerState();
}

class _SettingsTabControllerState extends State<SettingsTabController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
      Scaffold(

          appBar:
          AppBar(
            automaticallyImplyLeading: false,
            foregroundColor: kPureWhiteColor,
            toolbarHeight: 30,
            backgroundColor: kGreenThemeColor,
            // leading: GestureDetector(
            //
            //     onTap: (){
            //       Navigator.pop(context);
            //     },
            //     child: Icon(Icons.arrow_back)),
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
                      colors: [kGreenThemeColor, kGreenThemeColor]),
                  // borderRadius: BorderRadius.circular(10),
                  color: Colors.redAccent),

              //indicatorColor: kPinkDarkThemeColor,
              labelColor: kPureWhiteColor,
              unselectedLabelColor: kCustomColor,
              tabs: [
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Icons.settings, size: 20,),
                      SizedBox(width: 4,),
                      Text('Settings')]
                ),),
                // ),),
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Iconsax.video, size: 16,),
                      SizedBox(width: 4,),
                      Text('Tutorials')]
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
                NewSettingsPage(),
               TutorialPage()

                // VisaPage(),
              ],
            ),
          )
      ),
    );
  }
}
