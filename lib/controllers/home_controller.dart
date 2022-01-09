

import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/news_page.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';


class ControlPage extends StatefulWidget {
  ControlPage();
  static String id = 'home_control_page';
  //int selectedPage;



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
    // //InputPage(),

    // Container(color: Colors.blue,),
    // Container(color: Colors.red,),
    BlogPage(),
    // Container(color: Colors.pink,),


    //SplashPage()
    OrdersPage(),

];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        shape: CircularNotchedRectangle(),
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
          [
            BottomNavigationBarItem(
                icon: Icon(LineIcons.blender),label:'Your Blender',
                backgroundColor: Colors.green),
            // Item 2
            BottomNavigationBarItem(
                icon: Icon(LineIcons.store , size: 18,),label:'Store',
                backgroundColor: Colors.purple),
            // Item 3
            BottomNavigationBarItem(
                icon: Icon(LineIcons.newspaper, size: 18,),label:'Notes',
                backgroundColor: Colors.purple),
            // Item 3
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart_fill),label:'Orders',
                backgroundColor: Colors.black)],
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
