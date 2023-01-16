import 'dart:async';


import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/basketItem.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/screens/success_appointment_create.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';
import 'package:blendit_2022/utilities/roundedButtons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';


showShoppingListDialog(context, heading, data, split, joiningString){
  var formatter = NumberFormat('#,###,000');
  List<String> parts = data.split(split);
  // String result = parts.join("\n - ");
   String result = parts.join(joiningString);
  //String result = data;





  return showDialog(context: context,barrierLabel: 'Items', builder: (context){


    return Center(
      //heightFactor: 300,

        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Material(
            elevation: 10.0,

            type: MaterialType.transparency,
            child:

            Container(

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              padding: EdgeInsets.all(15),
              width:  MediaQuery.of(context).size.width,
              height: 800,
              // result.length < 100 ? 500 : 600,
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(heading, overflow: TextOverflow.ellipsis, style:kHeading2TextStyleBold.copyWith(color: kBlack, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          GestureDetector(
                              onTap: (){
                                Share.share('$result',
                                    subject: 'Check out $heading');
                              },
                              child: Icon(Icons.ios_share_outlined, color: kBlack, size: 20,)),

                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(

                      height: 500,
                      // result.length < 100 ? 80 : 200,
                      child:
                      ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Text('$result', style: kNormalTextStyle.copyWith(fontSize: 16),);
                        },
                      ),
                    ),

                    const SizedBox(height: 10,),
                    TextButton(onPressed: (){
                      Navigator.pop(context);

                    }, child: Text('Cancel', style: kNormalTextStyle.copyWith(color: kGreenThemeColor),))
                    //   roundedButtons(
                    //       buttonHeight: 40,
                    //       buttonWidth: 130,
                    //       buttonColor: kGreenThemeColor, title: "Join Challenge ${result.length}", onPressedFunction: (){})]
                    // )
                    //   paymentButtons(
                    //     continueFunction: (){
                    //       Provider.of<BlenditData>(context, listen: false).addToBasket(BasketItem(amount: amount, quantity: Provider.of<BlenditData>(context, listen: false).ordinaryItemQty, name: title, details: desc));
                    //       animationTimer();
                    //       showCupertinoModalPopup(context: context, builder: (context) => Container(
                    //         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    //         //color: Color(0xFF757575),
                    //
                    //         child: Lottie.asset('images/shopping.json',
                    //             height: 150),
                    //       ));
                    //     }, continueBuyingText: 'Add to Basket',
                    //     checkOutText: 'Buy Now',
                    //     buyFunction: (){
                    //       Provider.of<BlenditData>(context, listen: false).addToBasket(BasketItem(amount: amount, quantity: Provider.of<BlenditData>(context, listen: false).ordinaryItemQty, name: title, details: desc));
                    //       Navigator.pop(context);
                    //       Navigator.pushNamed(context, CheckoutPage.id);
                    //
                    //
                    //     },)
                    // ],),
                  ]),
            ),
          ),
        ));

  });
}