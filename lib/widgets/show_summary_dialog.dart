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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';


showSummaryDialog(context, img, challengeName, challengePromo, challengeAmount, daysList, schedule, challengeId,  welcome, rules, promo, heading, shopping){
  var formatter = NumberFormat('#,###,000');
  List<String> parts = challengePromo.split(".");
  String result = parts.join("\n");
  CollectionReference userOrder = FirebaseFirestore.instance.collection('challenges');
  CollectionReference planUpload = FirebaseFirestore.instance.collection('plans');
  String orderId = 'ch${uuid.v1().split("-")[0]}${DateTime.now().month}${DateTime.now().day}';
  String challengeCreateId = 'plan${uuid.v1().split("-")[0]}${DateTime.now().month}${DateTime.now().day}';


  Timer _timer;

  Future<void> upLoadActualChallenges ( )async {
    final prefs =  await SharedPreferences.getInstance();
    final dateNow = DateTime.now();
   // var products = Provider.of<BlenditData>(context, listen: false).basketItems;
    return planUpload.doc(challengeCreateId)
        .set({
      'active': true,
      'challenge': 'Weightloss plan',
      'challengeEndTime': dateNow.add(Duration(days: 15)),
      'community': [],
      'number': 0,
      'challengeCreateId': challengeCreateId,
      'heading': 'Weightloss plan',
      'promo': 'This is an amazing promo',
      'rules': "These are the rules of the fitness challenge",
      'welcome': 'Welcome to the fitness challenge',
      'rating':0,
      'rating_comment': '',
      'status': 'submitted',
      'total_price': 10000,
      'schedule': 'This is how the challenge will be played',
      'shopping': shopping,
      'image': 'https://mcusercontent.com/f78a91485e657cda2c219f659/images/b3ccb120-d79a-819c-d303-759bad9e7bde.png',
      'days': {
        'day 1':
        {'Ginger shot': DateTime.now().add(Duration(hours: 12)),
          'Breakfast': DateTime.now().add(Duration(hours: 13)),
          'Lunch': DateTime.now().add(Duration(hours: 14)),
          'Dinner': DateTime.now().add(Duration(hours: 20)),},
        'day 2':
        {'Ginger shot': DateTime.now().add(Duration(hours: 12)),
          'Breakfast': DateTime.now().add(Duration(hours: 13)),
          'Lunch': DateTime.now().add(Duration(hours: 14)),
          'Dinner': DateTime.now().add(Duration(hours: 20)),},
        'day 3':
        {'Ginger shot': DateTime.now().add(Duration(hours: 12)),
          'Breakfast': DateTime.now().add(Duration(hours: 13)),
          'Lunch': DateTime.now().add(Duration(hours: 14)),
          'Dinner': DateTime.now().add(Duration(hours: 20)),},


      }

    })
        .then((value) {
      // Navigator.pushNamed(context, MobileMoneyPage.id);
      // updatePoints();
      Provider.of<BlenditData>(context, listen: false).setLoyaltyApplied(false, 1.0);
      CommonFunctions().showNotification('Challenge has been created', '${prefs.getString(kFirstNameConstant)} we have received your request!');
    } )
        .catchError((error) => Get.snackbar('Error', 'Something went wrong, please try again'));
  }

  Future<void> upLoadOrder ( )async {
    final prefs =  await SharedPreferences.getInstance();
    final dateNow = DateTime.now();
    return userOrder.doc(orderId)
        .set({
      'active': false,
      'challenge': challengeName,
      'challengeCreateId': challengeId,
      'challengeEndTime': dateNow.add(Duration(days: 5)),
      'challengeStartTime': dateNow.add(Duration(days: 1)),
      'challengeStatus': false,
      'community': challengeId,
      'client': prefs.getString(kFullNameConstant),
      'heading': heading,
      'personalImages': [],
      'position': 0,
      'promo': promo,
      'rules': rules,
      'welcome': welcome,
      'client_phoneNumber': prefs.getString(kPhoneNumberConstant), // John Doe
      'sender_id': prefs.getString(kEmailConstant),
      'orderNumber': orderId,
      'paymentMethod': 'mobileMoney',
      'paymentStatus': 'pending',
      'rating':0,
      'rating_comment': '',
      'hasRated': false,
      'country': prefs.getString(kUserCountryName),
      'status': 'submitted',
      'total_price': challengeAmount,
      'order_time': dateNow,
      'token': prefs.getString(kToken),
      'phoneNumber': prefs.getString(kPhoneNumberConstant),
      'schedule': schedule,
      'image': img,
      'shopping': shopping,
      'completed': false,
      'days': daysList

      // {
      //   'day 1':
      //   {'Ginger shot': DateTime.now().add(Duration(hours: 12)),
      //   'Breakfast': DateTime.now().add(Duration(hours: 13)),
      //   'Lunch': DateTime.now().add(Duration(hours: 14)),
      //   'Dinner': DateTime.now().add(Duration(hours: 20)),},
      //   'day 2':
      //   {'Ginger shot': DateTime.now().add(Duration(hours: 12)),
      //     'Breakfast': DateTime.now().add(Duration(hours: 13)),
      //     'Lunch': DateTime.now().add(Duration(hours: 14)),
      //     'Dinner': DateTime.now().add(Duration(hours: 20)),},
      //   'day 3':
      //   {'Ginger shot': DateTime.now().add(Duration(hours: 12)),
      //     'Breakfast': DateTime.now().add(Duration(hours: 13)),
      //     'Lunch': DateTime.now().add(Duration(hours: 14)),
      //     'Dinner': DateTime.now().add(Duration(hours: 20)),},
      //
      //
      // }
      // 'days': [for(var i = 0; i < products.length; i ++){
      //   'name': products[i].name,
      //   'instruction': products[i].details,
      //   'completed': false,
      //   'photo':''
       // }
     // ]
    })
        .then((value) {
      // Navigator.pushNamed(context, MobileMoneyPage.id);
      // updatePoints();
      Provider.of<BlenditData>(context, listen: false).setLoyaltyApplied(false, 1.0);
      CommonFunctions().showNotification('Challenge has been created', '${prefs.getString(kFirstNameConstant)} we have received your request!');
    } )
        .catchError((error) => Get.snackbar('Error', 'Something went wrong, please try again'));
  }


  return showDialog(context: context,barrierLabel: 'Items', builder: (context){
    animationTimer() {
      _timer = new Timer(const Duration(milliseconds: 3500), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }

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
              height: result.length < 100 ? 500 : 600,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                        children: [

                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child:
                              Container(
                                height: 200,
                                width: 300,
                                // margin: const EdgeInsets.only(
                                //     top: 10,
                                //     right: 0,
                                //     left: 0,
                                //     bottom: 3),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    // color: backgroundColor,
                                    image: DecorationImage(
                                      image:  CachedNetworkImageProvider(img),
                                      //NetworkImage(images[index]),
                                      fit: BoxFit.cover,
                                    )
                                  //colours[index],
                                ),

                              ),

                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10), ),color: Colors.orange ),
                              //color: Colors.red,
                              child: Column(
                                children: [
                                  Text('${formatter.format(challengeAmount)} Ugx', style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text('Duration: ${daysList.length  } days', style: kNormalTextStyle.copyWith(color:kPureWhiteColor, fontSize: 12),)
                                ],
                              ),

                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 10,),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(challengeName, overflow: TextOverflow.ellipsis, style:kHeading2TextStyleBold.copyWith(color: kBlack, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          SizedBox(width: 5),

                          // QuantityBtn(onTapFunction: (){
                          //   Provider.of<BlenditData>(context, listen:false).decreaseJuiceItemQty();
                          // }, text: '-', size: 30, color: kBiegeThemeColor,),
                          // SizedBox(width: 3),
                          // Text('${Provider.of<BlenditData>(context).ordinaryItemQty}'),
                          // SizedBox(width: 3),
                          // QuantityBtn(onTapFunction: (){
                          //   Provider.of<BlenditData>(context, listen:false).increaseJuiceItemQty();
                          // }, text: '+', size: 30, color: kBiegeThemeColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(

                      height: result.length < 100 ? 80 : 200,
                      child:
                      ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Text('$result', style: kNormalTextStyle.copyWith(fontSize: 14),);
                        },
                      ),
                    ),

                    const SizedBox(height: 10,),
                    SliderButton(

                      action: () async{
                        final prefs = await SharedPreferences.getInstance();
                        // changeOrderStatus();
                        prefs.setString(kBillValue, challengeAmount.toString() );
                        prefs.setString(kOrderReason, challengeName );
                        prefs.setString(kOrderId, orderId );
                        Navigator.pop(context);
                        // upLoadActualChallenges();
                         upLoadOrder();
                        // print(time);
                        Navigator.pushNamed(context, SuccessPageNew.id);
                      },
                      ///Put label over here
                      label: Text(
                        "Slide to Join Challenge",
                        style: kHeading2TextStyleBold.copyWith(color: Colors.white),),
                      icon: Lottie.asset('images/workout5.json', width: 70, height: 70, fit: BoxFit.cover),

                      //Put BoxShadow here
                      boxShadow: BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                      ),


                      width: 250,
                      radius: 50,
                      buttonColor: kPureWhiteColor ,
                      backgroundColor: kBlack,
                      highlightedColor: Colors.black,
                      baseColor: kGreenThemeColor,
                    ),
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