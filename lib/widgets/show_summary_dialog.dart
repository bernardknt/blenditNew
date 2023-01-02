import 'dart:async';


import 'package:blendit_2022/models/basketItem.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';
import 'package:blendit_2022/utilities/roundedButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';


showSummaryDialog(context, img, title, desc, amount){
  var formatter = NumberFormat('#,###,000');
  List<String> parts = desc.split(".");
  String result = parts.join("\n");

  Timer _timer;



  //var blendedData = Provider.of<BlenditData>(context);

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
              height: result.length < 100 ? 450 : 600,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                        children: [

                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'images/loading.gif',
                                image: img,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,

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
                                  Text('${formatter.format(amount)} Ugx', style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text('Duration: 3 days', style: kNormalTextStyle.copyWith(color:kPureWhiteColor, fontSize: 12),)
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
                          Text(title, overflow: TextOverflow.ellipsis, style:TextStyle(fontSize: 18, color: Colors.grey,
                              fontWeight: FontWeight.bold),textAlign: TextAlign.center),
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
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Text('$result $index', style: kNormalTextStyle.copyWith(fontSize: 14),);
                        },
                      ),
                    ),

                    const SizedBox(height: 10,),
                    SliderButton(

                      action: () {
                        // changeOrderStatus();
                        Navigator.pop(context);
                        // print(time);
                        Navigator.pushNamed(context, MobileMoneyPage.id);
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