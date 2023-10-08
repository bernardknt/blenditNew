import 'dart:async';
import 'dart:math';

import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/responsive/responsive_layout.dart';

import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PaymentMode extends StatefulWidget {
  static String id = 'paymentMode';


  @override
  _PaymentModeState createState() => _PaymentModeState();
}

class _PaymentModeState extends State<PaymentMode> {
  double discountValue = 0.0;
  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    discountValue = prefs.getDouble(kDiscountPercentage)!;
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
  }
  @override
  Widget build(BuildContext context) {
    Timer _timer;
    animationTimer() {
      _timer = new Timer(const Duration(milliseconds: 2000), () {

        // Navigator.pushNamed(context, ControlPage.id);
        Navigator.pushNamed(context, ResponsiveLayout.id);
      });
    }
    return Scaffold(
      backgroundColor: kBlueDarkColor,

      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('How Would You Like to Pay?', style: TextStyle(color: Colors.white, fontSize: 20),),
              SizedBox(height: 40,),
              paymentButtons(lineIconFirstButton:LineIcons.creditCard,lineIconSecondButton: LineIcons.alternateWavyMoneyBill,
                  continueFunction: ()async{
                final prefs = await SharedPreferences.getInstance();
                double amount = double.parse(prefs.getString(kBillValue)!);
                double discoutMultiplier = 1 - discountValue;
                double newAmount = amount * discoutMultiplier;
                int roundedAmount = max(0, (newAmount / 10).floor() * 10);
                print(roundedAmount);

                await prefs.setString(kBillValue, roundedAmount.toString());


                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Discount Applied: Payable now ${CommonFunctions().formatter.format(roundedAmount)} Ugx')));
                //
                Navigator.pushNamed(context, ResponsiveLayout.id);
                Navigator.pushNamed(context, MobileMoneyPage.id);
              }, continueBuyingText: 'Mobile Money', checkOutText: 'Pay Cash', buyFunction: (){
                Navigator.pushNamed(context, ResponsiveLayout.id);
                // animationTimer();
              }),
              discountValue == 0.0 ? Container():Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: kYellowThemeColor,size: 20,),
                      kSmallWidthSpacing,
                      Text("${(discountValue*100).round()}% Discount", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                    ],
                  ),
                  Container(width: 200,)
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
