

import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/input_page.dart';
import 'package:blendit_2022/screens/loyalty_page.dart';
import 'package:blendit_2022/screens/blog_page.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:blendit_2022/screens/settings_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';


class ControlPage extends StatefulWidget {
  ControlPage();
  static String id = 'home_control_page';


  @override
  _ControlPageState createState() => _ControlPageState();

}

class _ControlPageState extends State<ControlPage> {


  int _currentIndex = 0;
  double buttonHeight = 40.0;
  int amount = 0;
  final tabs = [
    CustomizeController(),
    HomePage(),
    OrdersPage(),
    BlogPage()
    // SettingsPage()

];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   shadowColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   //title: Text(''),
      //   backgroundColor: kBlueDarkColor,
      //   leading:Transform.translate(offset: Offset(20*0.7, 0),
      //     child: IconButton(
      //       icon: Icon(LineIcons.trophy, color: Colors.grey,),
      //       onPressed: () {
      //        // showNotification('notificationTitle', 'notificationBody');
      //
      //         Navigator.pushNamed(context, LoyaltyPage.id);
      //       },
      //     ),
      //   ),
      //   actions: [
      //     GestureDetector(
      //       onTap: (){
      //         Navigator.pushNamed(context, SettingsPage.id);
      //       },
      //       child: Container(
      //           padding:EdgeInsets.all(10),child:
      //       Icon(CupertinoIcons.settings, color: Colors.grey,)),
      //     )],
      // ),




      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   Navigator.pushNamed(context, BlenditPage.id);
      // },
      //   backgroundColor: Colors.orange,
      //   child: Icon(LineIcons.blender, size: 30,color: Colors.black,),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[_currentIndex],
      bottomNavigationBar:
      BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAliasWithSaveLayer ,
        notchMargin: 7,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          iconSize: 18,
          items:
          // Item 1
          const [
            BottomNavigationBarItem(
                icon: Icon(LineIcons.blender),label:'Your Blender',
                backgroundColor: Colors.green),
            // Item 2
            BottomNavigationBarItem(
                icon: Icon(LineIcons.store , size: 18,),label:'Store',
                backgroundColor: Colors.purple),
            // Item 3
            BottomNavigationBarItem(
                icon: Icon(LineIcons.receipt, size: 18,),label:'Orders',
                backgroundColor: Colors.purple),
            // Item 4
            BottomNavigationBarItem(
                icon: Icon(LineIcons.newspaper, size: 18,),label:'Blog',
                backgroundColor: Colors.purple),

          ],
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
