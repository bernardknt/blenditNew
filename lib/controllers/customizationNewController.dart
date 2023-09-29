
import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/blender_page_salad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


import '../models/blendit_data.dart';
import '../screens/checkout_page.dart';
import '../utilities/constants.dart';







class BlendingController extends StatefulWidget {
  static String id = 'tasks_controller';
  @override
  _BlendingControllerState createState() => _BlendingControllerState();
}

class _BlendingControllerState extends State<BlendingController> {

  @override
  Widget build(BuildContext context) {
    var blendedData = Provider.of<BlenditData>(context);
    return
      DefaultTabController(
        length: 2,
        child:
        Scaffold(
            backgroundColor: kPureWhiteColor,

            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 5,
              backgroundColor: kGreenThemeColor.withOpacity(1),
              // actions: [
              //   Stack(children: [
              //     Positioned(
              //       top: 4,
              //       right: 2,
              //       child: CircleAvatar(radius: 10,
              //           child: Text(
              //             '${blendedData.basketNumber}', style: TextStyle(fontSize: 10),)),
              //     ) ,
              //     IconButton
              //       (onPressed: (){
              //       if (blendedData.basketNumber == 0) {
              //
              //       }else {
              //         Navigator.pushNamed(context, CheckoutPage.id);
              //       }
              //     },
              //       icon: Icon(LineIcons.shoppingBasket),),
              //   ]
              //   )
              // ],
              // shape: ShapeBorder.lerp(, b, t),
              elevation: 0,
              //title: Center(child: Text("Stock Page", style: TextStyle(color: kBiegeThemeColor, fontSize: 13, fontWeight: FontWeight.bold),),),
              bottom: TabBar(
                indicatorPadding: EdgeInsets.all(7),
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kPureWhiteColor, kPureWhiteColor]),
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.redAccent
                ),

                //indicatorColor: kPinkDarkThemeColor,
                labelColor: kBlueDarkColorOld,
                unselectedLabelColor: kPureWhiteColor,
                tabs: [

                  Tab(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[

                        Text('Juice / Smoothie')]
                  ),),
                  Tab(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Salad'),
                  ),),


                ],
              ),
            ),
            body: TabBarView(
              children: [
                // TransactionsOnlinePage(),
                // SummaryWidget(),
                NewBlenderPage(),
                // Container(
                //   child: Center(child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(Iconsax.designtools5, color: kAppPinkColor,),
                //       Text("Different Tasks will appear here", style: kNormalTextStyle,),
                //     ],
                //   )),
                // )
                //  StockSummaryPage(),
                SaladBlenderPage(),



                // VisaPage(),
              ],
            )
        ),
      );
  }
}
