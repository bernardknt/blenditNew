import 'dart:async';

import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';



class PaymentMode extends StatefulWidget {
  static String id = 'paymentMode';


  @override
  _PaymentModeState createState() => _PaymentModeState();
}

class _PaymentModeState extends State<PaymentMode> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    Timer _timer;
    animationTimer() {
      _timer = new Timer(const Duration(milliseconds: 2000), () {

        Navigator.pushNamed(context, ControlPage.id);
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
              paymentButtons(lineIconFirstButton:LineIcons.creditCard,lineIconSecondButton: LineIcons.alternateWavyMoneyBill, continueFunction: (){
                Navigator.pushNamed(context, MobileMoneyPage.id);
              }, continueBuyingText: 'Mobile Money', checkOutText: 'Pay Cash', buyFunction: (){
                // showCupertinoModalPopup(context: context, builder: (context) => Container(
                //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                //   //color: Color(0xFF757575),
                //   child: Lottie.asset('images/thankyou.json',
                //       height: 200),
                // ));
                Navigator.pushNamed(context, ControlPage.id);
                // animationTimer();
              }),
            ],
          )
        ),
      ),
    );
  }
}
