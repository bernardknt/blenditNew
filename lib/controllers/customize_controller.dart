import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/blender_page_salad.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/new_settings.dart';





class CustomizeController extends StatefulWidget {
  static String id = 'stock_controller';


  @override
  _CustomizeControllerState createState() => _CustomizeControllerState();
}

class _CustomizeControllerState extends State<CustomizeController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
      Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 30,
            backgroundColor: kBlueDarkColor,
            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, NewSettingsPage.id);
                },
                child: Container(
                    padding:EdgeInsets.all(7),child:
                Icon(CupertinoIcons.settings, color: Colors.grey,size: 20,)),
              )],
            // title: Center(child: Text("Stock Page", style: TextStyle(color: kBiegeThemeColor, fontSize: 13, fontWeight: FontWeight.bold),),),
            bottom: TabBar(
              indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange, Colors.green]),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent),

              //indicatorColor: kPinkDarkThemeColor,
              labelColor: Colors.white,
              unselectedLabelColor: kBiegeThemeColor,
              tabs: [
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(LineIcons.glassCheers, size: 20,),
                      SizedBox(width: 4,),
                      Text('Juice/Smoothie')]
                ),),
                // ),),
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Icons.rice_bowl, size: 16,),
                      SizedBox(width: 4,),
                      Text('Salad')]
                ),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NewBlenderPage(),
              SaladBlenderPage(),
              // VisaPage(),
            ],
          )
      ),
    );
  }
}
