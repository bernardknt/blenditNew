import 'dart:async';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'orderedContentsWidget.dart';


showTransactionFunc(context, orderStatus, description, price, transactionList, product, note, time, paidStatus){
  String formattedDate = DateFormat('EE, dd, MM– kk:mm aaa').format(time);


  CollectionReference customerOrderStatus = FirebaseFirestore.instance.collection('orders');
  Future<void> changeOrderStatus() {
    // Call the user's CollectionReference to add a new user
    return customerOrderStatus.doc(transactionList).update({
      "status": "preparing",
      "prepareStartTime": DateTime.now(),
      "chef":"Salim"

    })
        .then((value) => print("Status Changed"))
        .catchError((error) => print("Failed to change status: $error"));
  }

  Timer _timer;
  return showDialog(context: context,barrierLabel: 'Items', builder: (context){
    return
      Stack(
          children: [ListView.builder(
              shrinkWrap: true,
              itemCount: product.length,
              itemBuilder: (context, index){
                return OrderedContentsWidget(productDescription: product[index]['description'], productName: product[index]['product'],quantity: product[index]['quantity'], orderIndex: index + 1, note: note,);
              }),
            Positioned(
              left: 30,
              right: 20,
              bottom: 20,
              child:
                paymentButtons(lineIconFirstButton: CupertinoIcons.bubble_right, lineIconSecondButton: LineIcons.alternateWavyMoneyBill, continueFunction: ()async{
                  var prefs = await SharedPreferences.getInstance();
                  
                  
                  launch('tel://+256${prefs.getString(kSupportNumber)}');

                }, continueBuyingText: 'Support', checkOutText: "Pay for Order", buyFunction: ()async{
                  print(paidStatus);
                  if (paidStatus == 'paid'){
                    Navigator.pop(context);
                    CoolAlert.show(
                        lottieAsset: 'images/success.json',
                        context: context,
                        type: CoolAlertType.success,
                        text: 'Thank You, this order was already paid for!',
                        title: 'Payment Already Made',
                        confirmBtnText: 'Ok 👍',
                        confirmBtnColor: Colors.green,
                        backgroundColor: kBlueDarkColor
                    );

                  }else{
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setString(kBillValue, price);
                  prefs.setString(kOrderId, transactionList);
                  Navigator.pushNamed(context, MobileMoneyPage.id);
                  }

                })

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
                    Text(formattedDate, style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                ),
              ),
            ),
          ]
      );
  }
  );
}

