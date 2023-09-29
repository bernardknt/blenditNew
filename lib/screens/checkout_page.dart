
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/DeliveryOptionsBottomSheet.dart';
import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CheckoutPage extends StatefulWidget {
  static String id = 'checkout_page';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final dateNow = new DateTime.now();


  Future<dynamic> AlertPopUpDialogue(BuildContext context,
      {required String imagePath, required String text, required String title}) {

    return CoolAlert.show(
      onConfirmBtnTap: (){
        Navigator.pop(context);
        },

      showCancelBtn: true,
      lottieAsset: imagePath,
      context: context,
      type: CoolAlertType.success,
      text: text,
      title: title,
      confirmBtnText: 'Ok',
      confirmBtnColor: Colors.green,
      backgroundColor: kBlueDarkColor,
    );
  }
  var formatter = NumberFormat('#,###,000');
  String phoneNumber = '';
  double textSize = 15.0;
  String fontFamilyMont = 'Montserrat-Medium';
  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;
  var blendedData = Provider.of<BlenditData>(context);

  return Scaffold(
    appBar:
    AppBar(

      backgroundColor: kPureWhiteColor,
      foregroundColor: kBlack,

      // brightness: Brightness.light,
      elevation:0 ,
      actions: [
        Stack(children: [
          Positioned(
            top: 4,
            right: 2,
            child: CircleAvatar(radius: 10,
                child: Text(
                  '${blendedData.basketNumber}', style: TextStyle(fontSize: 10),)),
          ) ,
          IconButton
            (onPressed: (){},
            icon: Icon(LineIcons.shoppingBasket),),
        ]
        )
      ],
      title: Text("Basket Total: ${formatter.format(Provider.of<BlenditData>(context).totalPrice)} Ugx", style: TextStyle(fontSize: 15),),
      centerTitle: true,
    ),
    //backgroundColor: Colors.black87,
    body: Stack
      (
      children:[

      ListView.builder(
          itemCount: blendedData.basketNumber,
          itemBuilder: (context, index){

            return Stack(
              children:[
                Container(
                  //color:Colors.grey,
                  //height: 100,
                  margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15), ),color:Colors.white,
                     boxShadow: [BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                  )]),
                  // shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  // shadowColor: kGreenThemeColor,
                  // elevation: 5.0,
                  child: Column(
                    children: [

                      ListTile(
                        leading: GestureDetector(
                            onTap: (){
                              CoolAlert.show(
                                  lottieAsset: 'images/pourJuice.json',
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Are you sure you want to Delete this item",
                                  title: "Delete Item",
                                  confirmBtnText: 'Yes',
                                  confirmBtnColor: Colors.red,
                                  cancelBtnText: 'Cancel',
                                  showCancelBtn: true,
                                  backgroundColor: kBlueDarkColor,
                                onConfirmBtnTap: (){
                                    Provider.of<BlenditData>(context, listen: false).deleteItemFromBasket(blendedData.basketItems[index]);
                                    Navigator.pop(context);
                                }
                              );

                            },
                            child: const Icon(Icons.cancel, color: Colors.red,size: 20,)),
                        title:Text('${blendedData.basketItems[index].name} x ${blendedData.basketItems[index].quantity} ', style: TextStyle(fontFamily: fontFamilyMont,fontSize: textSize)),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatter.format(blendedData.basketItems[index].amount * blendedData.basketItems[index].quantity), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                              Text('Ugx', style: TextStyle(color: kGreenThemeColor, fontSize: 13),)
                            ],
                          ),
                        ),
                        horizontalTitleGap: 0,
                        minVerticalPadding: 0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text( blendedData.basketItems[index].details,textAlign: TextAlign.start, style: TextStyle(fontFamily: fontFamilyMont,fontSize: textSize)),
                            SizedBox(height: 8,),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Share.share('Hi, I am getting a ${blendedData.basketItems[index].name}: ${blendedData.basketItems[index].details}. with Blendit, think you would like it. Follow to see more ${blendedData.shareUrl}', subject: 'See what am having😋!');

                                    },
                                    child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.lightGreenAccent,
                                        child: Icon(Icons.share, size: 15, color: Colors.black,)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      QuantityBtn(onTapFunction: (){
                                      Provider.of<BlenditData>(context, listen: false).updateBasketItem(blendedData.basketItems[index], blendedData.basketItems[index].quantity, '-');
                                    }, text: '-', size: 30,),
                                      SizedBox(width: 2,),
                                      Text(blendedData.basketItems[index].quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      SizedBox(width: 2,),
                                      QuantityBtn(onTapFunction: (){
                                        Provider.of<BlenditData>(context, listen: false).updateBasketItem(blendedData.basketItems[index], blendedData.basketItems[index].quantity, '+');
                                      }, text: '+', size: 30,),],
                                  ),
                                ],
                              ),

                            ),
                          ]

                        ),
                      ),

                    ],
                  ),
                ),
              ]

            );

          }),
        Positioned(
            bottom: 30,
            left: 0,
            right: 0,

            child:
            Container(
              padding: EdgeInsets.all(20),


              child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextButton.icon(onPressed: (){
                        // AlertPopUpDialogue(context, imagePath: 'images/longpress.json', text: "To Continue Buying, Sign In or, Sign Up required", title: "Sign Up Required");
                      Navigator.pop(context);
                      },
                        style: TextButton.styleFrom(
                          //elevation: ,
                            shadowColor: kBlueDarkColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                            backgroundColor: Color(0xFFF2efe4)),icon: Icon(LineIcons.shoppingBasket, color: kBlueDarkColor,),
                        label: Text('Continue Buying', style: TextStyle(fontWeight: FontWeight.bold,
                            color: kBlueDarkColor), ), ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 3,
                      child: TextButton.icon(onPressed: ()async{
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString(kOrderReason, "Ordered Items");
                        if (blendedData.storeOpen == false){

                          AlertPopUpDialogue(context, imagePath: 'images/closed.json', text: 'We cannot make deliveries right now because our Stores are closed', title: "Store Closed 😔"
                              "");
                        }else{

                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return DeliveryOptionsDialog();
                              });
                        }

                      },
                        style: TextButton.styleFrom(
                          //elevation: ,
                            shadowColor: kBlueDarkColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                            backgroundColor: Colors.green),icon: Icon(LineIcons.motorcycle, color: Color(0xFFF2efe4),),
                        label: Text('Deliver', style: TextStyle(fontWeight: FontWeight.bold,
                            color: Color(0xFFF2efe4)), ), ),
                    ),
                  ]),

            )
            ),

    ]),
  );
  }
}


