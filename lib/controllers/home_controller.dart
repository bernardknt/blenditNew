

import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/chat_designed_page.dart';
import 'package:blendit_2022/screens/chat_third_design.dart';
import 'package:blendit_2022/screens/home_page.dart';

import 'package:blendit_2022/screens/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../screens/chat_page.dart';


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
    OrdersPage(),
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
      BottomNavigationBar(
        currentIndex: selectedPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        iconSize: 18,
        items:
        // Item 1
        const [

          // Item 2
          BottomNavigationBarItem(
              icon: Icon(LineIcons.magic , size: 18,),label:'Nutri',
              backgroundColor: Colors.purple),
          // Item 3
          // BottomNavigationBarItem(
          //     icon: Icon(LineIcons.retroCamera, size: 18,),label:'Meal Scan ',
          //     backgroundColor: Colors.purple),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.airpod4),label:'Challenges',
              backgroundColor: Colors.green),
         //  Item 4
          BottomNavigationBarItem(
              icon: Icon(LineIcons.receipt, size: 18,),label:'Orders',
              backgroundColor: Colors.purple),
          // Item 4
          // BottomNavigationBarItem(
          //     icon: Icon(LineIcons.newspaper, size: 18,),label:'Blog',
          //     backgroundColor: Colors.purple),

        ],
        onTap: (index){
          setState(() {
              selectedPage = index;
          });
        },
      ),
    );
  }
}
