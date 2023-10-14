
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/showTransactionDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/responsive/dimensions.dart';
import 'checkout_page.dart';



class OrdersPage extends StatefulWidget {
  static String id = 'orders_page';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // final dateNow = new DateTime.now();
int price = 0;
 int quantity = 1;
 String emailConstant = "";






  Future<dynamic> defaultInitialization() async {
    final prefs =  await SharedPreferences.getInstance();
    emailConstant = prefs.getString(kEmailConstant)!;
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
  }

  var productList = [];
  var orderStatusList = [];
  var priceList = [];
  var descList = [];
  var transIdList = [];
  var dateList = [];
  var paidStatusList = [];
  var paidStatusListColor = [];
  List<double> opacityList = [];

  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';
  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;
  var blendedData = Provider.of<BlenditData>(context);

  return Scaffold(

    floatingActionButton:
    FloatingActionButton(
      onPressed: () async {

        var prefs = await SharedPreferences.getInstance();


        launch('${prefs.getString(kWhatsappNumber)}');


      },
      child: Lottie.asset('images/whatsapp.json', ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    //backgroundColor: Colors.black87,
    body:
    Center(
      child: Container(
        width: MediaQuery.of(context).size.width >mobileWidth? screenDisplayWidth : MediaQuery.of(context).size.width,

        child: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance
                .collection('orders')
                .where('sender_id', isEqualTo: emailConstant).where('type', isEqualTo: "Order")
                .orderBy('deliveryTime', descending: false).orderBy('order_time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(

                );
              } else {
                var docs = snapshot.data!.docs;

                productList = [];
                priceList = [];
                descList = [];
                transIdList = [];
                paidStatusListColor = [];
                orderStatusList = [];
                opacityList = [];
                dateList = [];
                paidStatusList = [];
                for (var doc in docs) {
                  productList.add(doc.get('items'));
                  priceList.add(doc.get('total_price'));
                  descList.add(doc.get('instructions'));
                  transIdList.add(doc.get('orderNumber'));
                  orderStatusList.add(doc.get('status'));
                  dateList.add(doc.get('order_time').toDate());

                  if (doc.get('paymentStatus') == 'paid') {
                    paidStatusList.add('Paid');
                    paidStatusListColor.add(kGreenThemeColor);
                    opacityList.add(1.0);
                  } else if (doc.get('paymentStatus') == 'cancelled') {
                    paidStatusList.add('CANCELLED');
                    paidStatusListColor.add(Colors.red);
                    opacityList.add(0.0);
                  } else {
                    paidStatusList.add('UnPaid');
                    paidStatusListColor.add(Colors.grey);
                    opacityList.add(0.0);
                  }
                }
                return productList.length == 0?Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Lottie.asset("images/pourJuice.json", height: 100),
                    Text("No orders Yet", style: kNormalTextStyle.copyWith(color: kBlack),),
                  ],
                ): ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showTransactionFunc(
                                context,
                                orderStatusList[index],
                                descList[index],
                                priceList[index].toString(),
                                transIdList[index],
                                productList[index],
                                "note",
                                dateList[index],
                                paidStatusList[index]);
                          },
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(
                                25.0, 8.0, 25.0, 8.0),
                            color: orderStatusList[index] != "CANCELLED"? kPureWhiteColor:kBlack,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            shadowColor: kBlack,
                            elevation: 1.0,
                            child: Column(
                              children: [

                                ListTile(
                                  leading: const Icon(LineIcons.shippingFast,
                                    color: kGreenThemeColor, size: 25,),
                                  title: Text(
                                      "${productList[index][0]['description']}...",
                                      style: TextStyle(
                                          fontFamily: fontFamilyMont,
                                          fontSize: textSize)),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      children: [
                                        Text(CommonFunctions().formatter.format(priceList[index]),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                        const Text('Ugx', style: TextStyle(
                                            color: kGreenThemeColor,
                                            fontSize: 10),)
                                      ],
                                    ),
                                  ),
                                  // horizontalTitleGap: 0,Ugx


                                  // minVerticalPadding: 0,
                                ),
                                Stack(
                                    children: [
                                      ListTile(


                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text('${ DateFormat('EE, dd, MMM')
                                                .format(dateList[index])}',
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),),
                                            Text(
                                              'Order Status:  ${orderStatusList[index]}',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 13),),
                                            paidStatusList[index] == 'Paid'
                                                ? Icon(
                                              Icons.check_circle_outlined,
                                              color: kGreenThemeColor,)
                                                : Text(
                                              "Payment: ${paidStatusList[index]}",
                                              style: TextStyle(
                                                  color: paidStatusListColor[index],
                                                  fontSize: 12),),
                                          ],
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .end,
                                          children: [
                                            Text("id: ${transIdList[index]}",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),),

                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          right: 4,
                                          bottom: 4,
                                          child: Opacity(
                                            opacity: opacityList[index],
                                            child: Container(
                                              width: 100,
                                              height: 20,
                                              child: const Center(child: Text(
                                                'Paid', style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),)),
                                              decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: const BorderRadius
                                                      .all(Radius.circular(20))
                                              ),
                                            ),
                                          ))

                                    ]),

                                //_buildDivider(),
                              ],
                            ),
                          ),
                        );
                      });
              }
            }),



      ),
    ),
  );
  }
}


