import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/utilities/icons_constants.dart';
import 'package:blendit_2022/widgets/transaction_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../screens/nutri_mobile_money.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';


class NutriPayment extends StatefulWidget {
  const NutriPayment({
    Key? key,
  }) : super(key: key);

  @override
  State<NutriPayment> createState() => _NutriPaymentState();
}


class _NutriPaymentState extends State<NutriPayment> {

  // THIS IS SERVICES VARIABLES
  var mainServices = [];
  var otherServices = [];
  var options = [];
  var basePrice = [];
  var optionsState = [];
  var fruitInfo = [];
  var extraInfo = [];
  var uuid = Uuid();


  @override


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }


  Widget build(BuildContext context) {
    String orderId = 'nutri${uuid.v1().split("-")[0]}${DateTime.now().month}${DateTime.now().day}';
    return Container(color: kBackgroundGreyColor,
      child: Container(color: kBlueDarkColorOld,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('To continue getting recommendations from Nutri please get a subscription',textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 14),),),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TransactionButtons(labelText: '1 Month/ UGX 15,000', pageToGoTo: NutriMobileMoneyPage.id, icon: Icon(Iconsax.moneys), amount: '15000', reason: 'Monthly Subsciption for Nutri', number: '', transactionId: orderId,),

                    kSmallWidthSpacing,
                    kSmallWidthSpacing,
                    TransactionButtons(labelText: '1 Year / UGX 170,000', pageToGoTo: NutriMobileMoneyPage.id, icon: Icon(Icons.credit_card_outlined), amount: '170000', reason: 'Annual Subscription for Nutri', number: '', transactionId: orderId,),
                   // TransactionButtons(labelText: '1 Year / UGX 170,000', pageToGoTo: NutriMobileMoneyPage.id, icon: Icon(Icons.credit_card_outlined)),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // InputPage()
    );
  }
}

