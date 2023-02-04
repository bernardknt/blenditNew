import 'dart:math';

import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/utilities/icons_constants.dart';
import 'package:blendit_2022/widgets/transaction_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var name = "";
  var basePrice = [];
  var optionsState = [];
  var fruitInfo = [];
  var extraInfo = [];
  var uuid = Uuid();
  Random random = Random();
  var about = ['I really enjoy helping you on your Journey. However to do this together please get a Subscription. It helps support our work',
  'We have made amazing progress. Please make a subscription so I can continue guiding you',
  'We have shared so much, and their is more to come.. Please get a subscription so we can continue this journey.'];
  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(kFirstNameConstant)!;
    setState(() {

    });

  }

  @override


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();



  }


  Widget build(BuildContext context) {
    String orderId = 'nutri${uuid.v1().split("-")[0]}${DateTime.now().month}${DateTime.now().day}';
    return Container(color: kBackgroundGreyColor,
      child: Container(color: kBlueDarkColorOld,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Text(about[random.nextInt(about.length)],textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 14),),),
                Container(
                  height: 150,
                ),
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
            Positioned(
                bottom: 220,
                right: 10,
                child: Lottie.asset('images/lisa.json', height: 120, width: 120,)),
            Positioned(
                bottom: 280,
                right: 90,

                child: Card(

                  // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  shadowColor: kGreenThemeColor,
                  color: kGreenThemeColor,
                  elevation: 2.0,
                  child: Container(
                    width: 260,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text( "$name ${about[random.nextInt(about.length)]}",textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 14, color: kPureWhiteColor)),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
      // InputPage()
    );
  }
}

