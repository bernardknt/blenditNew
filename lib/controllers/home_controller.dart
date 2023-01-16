

import 'package:blendit_2022/controllers/gym_tabs_controller.dart';
import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
import 'package:blendit_2022/screens/chat_designed_page.dart';
import 'package:blendit_2022/screens/chat_third_design.dart';
import 'package:blendit_2022/screens/home_page.dart';

import 'package:blendit_2022/screens/orders_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../screens/chat_page.dart';
import '../utilities/constants.dart';


class ControlPage extends StatefulWidget {

  static String id = 'home_control_page';


  @override
  _ControlPageState createState() => _ControlPageState();

}

class _ControlPageState extends State<ControlPage> {




  // int selectPage;
  int selectedPage = 0;
  double buttonHeight = 40.0;
  int amount = 0;
  final tabs = [
    // ChatDesignedPage(),
    ChatThirdDesignedPage(),
    HomePage(),
    // CustomizeController(),

    // Container(color: Colors.amber,),
    // AiCameraPage(),
    AppointmentsTabController()
    // ChallengePage()
    // OrdersPage(),
    // BlogPage()
    // SettingsPage()
  ];
  void defaultInitialization(){
    // This initialization gets the default value of the tab you set when a notification comes in and changes it
    selectedPage = Provider.of<BlenditData>(context, listen: false).tabIndex;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: tabs[selectedPage],
      bottomNavigationBar:
        Container(
          color: kPureWhiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: GNav(
              backgroundColor: kPureWhiteColor,
              rippleColor: kCustomColor,
              gap: 6,

              tabs: [
              GButton(
                icon: CupertinoIcons.chat_bubble_text,
                text: 'Nutri',
                iconColor: kGreenThemeColor,
                iconActiveColor: kBlack,
                textColor: kBlack,
                backgroundColor: kCustomColor,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                gap: 4,
              ),
              GButton(
                icon: Iconsax.airpod,
                text: 'Challenges',
                iconColor: kGreenThemeColor,
                iconActiveColor: Colors.white,
                textColor: Colors.white,

                // backgroundColor: kGreenThemeColor,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                gap: 4,
              ),
              GButton(
                icon: LineIcons.dumbbell,
                text: 'Active Workouts',
                iconColor: kGreenThemeColor,
                iconActiveColor: Colors.white,
                textColor: Colors.white,
                backgroundColor: kBlueDarkColorOld,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                gap: 4,
              ),
            ],
              selectedIndex: selectedPage,
              onTabChange: (index) {
                setState(() {
                  selectedPage = index;
                });
              },
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 500),
              tabBackgroundColor: kGreenThemeColor,
              color: Colors.white,
              activeColor: Colors.white,
              // backgroundColor: kGreenThemeColor,
              // tabBackgroundColor: Colors.grey[800],
              // color: Colors.grey[800],
              // activeColor: Colors.white,
              // backgroundColor: Colors.grey[800],
              // tabBackgroundColor: Colors.grey[800],
              // color: Colors.grey[800],
              // activeColor: Colors.white,
              // backgroundColor: Colors.grey[800],
              // tabBackgroundColor: Colors.grey[800],
              // color: Colors.grey[800],
              // activeColor: Colors.white,
              // backgroundColor: Colors.grey[800],
              // tabBackgroundColor: Colors.grey[800],
              // color: Colors.grey[800],
              // activeColor: Colors.white,
              // backgroundColor: Colors.grey[800],
              // tabBackgroundColor: Colors.grey[800],
              // color: Colors.grey[800],
              // activeColor: Colors.white,
              // backgroundColor: Colors.grey[800],
              // tabBackgroundColor: Colors.grey[800],
              //



            ),
          ),
        )
      // BottomNavigationBar(
      //   currentIndex: selectedPage,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.green,
      //   iconSize: 18,
      //   items:
      //   // Item 1
      //   const [
      //
      //     // Item 2
      //     BottomNavigationBarItem(
      //         icon: Icon(LineIcons.magic , size: 18,),label:'Nutri',
      //         backgroundColor: Colors.purple),
      //     // Item 3
      //     // BottomNavigationBarItem(
      //     //     icon: Icon(LineIcons.retroCamera, size: 18,),label:'Meal Scan ',
      //     //     backgroundColor: Colors.purple),
      //     BottomNavigationBarItem(
      //         icon: Icon(Iconsax.airpod4),label:'Challenges',
      //         backgroundColor: Colors.green),
      //    //  Item 4
      //     BottomNavigationBarItem(
      //         icon: Icon(LineIcons.receipt, size: 18,),label:'Orders',
      //         backgroundColor: Colors.purple),
      //     // Item 4
      //     // BottomNavigationBarItem(
      //     //     icon: Icon(LineIcons.newspaper, size: 18,),label:'Blog',
      //     //     backgroundColor: Colors.purple),
      //
      //   ],
      //   onTap: (index){
      //     setState(() {
      //         selectedPage = index;
      //     });
      //   },
      // ),
    );
  }
}
