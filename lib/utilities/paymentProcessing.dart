import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'constants.dart';

class PaymentProcessing extends StatefulWidget {

  @override
  _PaymentProcessingState createState() => _PaymentProcessingState();
}

class _PaymentProcessingState extends State<PaymentProcessing> {
  @override
  //CountDownController _controller = CountDownController();


  String countdownText = 'Awaiting Payment Confirmation.\nA USSD prompt will be sent to your phone to complete the transaction';

  Widget build(BuildContext context) {
    return Container(
      color: kRoundedContainerColor,

      child: Container(
        child: Column(children: [
          Text('Payment in Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          kLargeHeightSpacing,
          CircularCountDownTimer(isReverse: true, width: 100, height: 100, duration: 30,
            fillColor: kGreenThemeColor, ringColor: Colors.grey,onStart:(){


            },onComplete: (){
              Navigator.pushNamed(context, ControlPage.id);
            },
          ),
          kLargeHeightSpacing,
          Text(countdownText, maxLines: 5,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54, fontSize: 16),),

        ],),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white ,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      ),


    );
  }
}
