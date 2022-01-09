import 'dart:async';


import 'package:blendit_2022/models/basketItem.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


showDialogFunc(context, img, title, desc, amount){
  var formatter = NumberFormat('#,###,000');
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
          child: Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
            ),
            padding: EdgeInsets.all(15),
            width:  MediaQuery.of(context).size.width,
            height: 400,
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
                        child: Text('${formatter.format(amount)} Ugx', style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),),

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
                      QuantityBtn(onTapFunction: (){
                        Provider.of<BlenditData>(context, listen:false).decreaseItemQty();
                      }, text: '-', size: 30, color: kBiegeThemeColor,),
                      SizedBox(width: 3),
                      Text('${Provider.of<BlenditData>(context).ordinaryItemQty}'),
                      SizedBox(width: 3),
                      QuantityBtn(onTapFunction: (){
                        Provider.of<BlenditData>(context, listen:false).increaseItemQty();
                      }, text: '+', size: 30, color: kBiegeThemeColor),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text(desc,
                  style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                paymentButtons(
                  continueFunction: (){
                    Provider.of<BlenditData>(context, listen: false).addtoBasket(BasketItem(amount: amount, quantity: Provider.of<BlenditData>(context, listen: false).ordinaryItemQty, name: title, details: desc));
                    animationTimer();
                    showCupertinoModalPopup(context: context, builder: (context) => Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      //color: Color(0xFF757575),

                      child: Lottie.asset('images/shopping.json',
                          height: 150),
                    ));
                }, continueBuyingText: 'Add to Basket',
                  checkOutText: 'Buy Now',
                  buyFunction: (){
                    Provider.of<BlenditData>(context, listen: false).addtoBasket(BasketItem(amount: amount, quantity: Provider.of<BlenditData>(context, listen: false).ordinaryItemQty, name: title, details: desc));
                    Navigator.pop(context);
                    Navigator.pushNamed(context, CheckoutPage.id);


                },)
              ],),
          ),
        ),
      ),
    );

  });
}