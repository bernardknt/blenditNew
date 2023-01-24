



import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';




class TransactionButtons extends StatelessWidget {
   TransactionButtons({ required this.labelText, required this.pageToGoTo, required this.icon, this.width = 130,  this.height = 130, this.colour = kPureWhiteColor, required this.amount, required this.number, required this.reason, required this.transactionId, });


    final String labelText;
    final String amount;
    final String number;
    final String reason;
    final String transactionId;
    final double width;
    final double height;
    final String pageToGoTo;
    final Icon icon;
    final Color colour;



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(kBillValue, amount);
        prefs.setString(kOrderId, transactionId);
        prefs.setString(kOrderReason, reason);
        // String newAmount = prefs.getString(kBillValue) ?? '0';
        // String newPhoneNumber = removeCountryCode(prefs.getString(kPhoneNumberConstant) ?? '0') ;
        // String? newOrderId = prefs.getString(kOrderId);
        // String? newOrderReason = prefs.getString(kOrderReason);
        Navigator.pop(context);
        Navigator.pushNamed(context, pageToGoTo);


      },
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colour,
      ),
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(labelText,textAlign: TextAlign.center, style: kNormalTextStyle,),
        ],
      )),

      // width: double.maxFinite,
    ),
    );
    }
  }


