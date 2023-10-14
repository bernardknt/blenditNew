import 'package:blendit_2022/screens/appointments_page.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';

import '../utilities/constants.dart';






class OrdersTabController extends StatefulWidget {
  static String id = 'order_tab_controller';


  @override
  _OrdersTabControllerState createState() => _OrdersTabControllerState();
}

class _OrdersTabControllerState extends State<OrdersTabController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
      Scaffold(

          appBar:
          AppBar(
            automaticallyImplyLeading: true,
            // toolbarHeight: 30,
            foregroundColor: kBlueDarkColor,
            backgroundColor: kBackgroundGreyColor,
            elevation: 0,

            bottom: const TabBar(
              indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [kGreenThemeColor, kBackgroundGreyColor]),
                  // borderRadius: BorderRadius.circular(10),
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
                      Text('Orders')]
                ),),
                // ),),
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Iconsax.tick_circle, size: 16,),
                      SizedBox(width: 4,),
                      Text('Appointments')]
                ),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              OrdersPage(),
              AppointmentsPage(),

              // VisaPage(),
            ],
          )
      ),
    );
  }
}
