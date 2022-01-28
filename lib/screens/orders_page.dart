
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/showTransactionDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';



class OrdersPage extends StatefulWidget {
  static String id = 'orders_page';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;



  Future<dynamic> getTransaction() async {
    var test = {price: 200, quantity: 7};
    final prefs =  await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    final email = user!.email;
    String? otherEmail = prefs.getString(kEmailConstant);
    productList = [];
    priceList = [];
    descList = [];
    transIdList = [];
    dateList = [];
    orderStatusList = [];
    paidStatusList = [];
    paidStatusListColor = [];



    final transactions = await FirebaseFirestore.instance
        .collection('orders')
        // .where('payment_status', isEqualTo: true)
        .where('sender_id', isEqualTo: otherEmail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //String formatter = DateFormat('yMd').format(doc['date']);

        productList.add(doc['items']);
        priceList.add(doc['total_price'].toString());
        descList.add(doc['instructions']);
        transIdList.add(doc['orderNumber']);
        orderStatusList.add(doc['status']);
        dateList.add(doc['order_time'].toDate());

         if (doc['paymentStatus'] == 'pending'){
           paidStatusList.add('Unpaid');
           paidStatusListColor.add(Colors.red);
           opacityList.add(0.0);
         }else{
           paidStatusList.add('paid');
           paidStatusListColor.add(Colors.grey);
           opacityList.add(1.0);
         }
      });
      setState(() {
        print(productList);
        print(productList.length);
      });
    });

    return transactions;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransaction();
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
    appBar:
    AppBar(
      automaticallyImplyLeading: false,

      backgroundColor: Colors.black,
      // foregroundColor: Colors.blue,

      brightness: Brightness.light,
      elevation:8 ,
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
      title: Text("Your Orders", style: TextStyle(fontSize: 15),),
      centerTitle: true,
    ),
    //backgroundColor: Colors.black87,
    body:
    ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index){

          return Card(
            margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
            shadowColor: kGreenThemeColor,
            elevation: 5.0,
            child: Column(
              children: [

                ListTile(
                  leading: Icon(LineIcons.shippingFast, color: kGreenThemeColor,size: 25,),
                  title:Text( "${productList[index][0]['description']}...", style: TextStyle(fontFamily: fontFamilyMont,fontSize: textSize)),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(priceList[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        Text('Ugx', style: TextStyle(color: kGreenThemeColor, fontSize: 12),)
                      ],
                    ),
                  ),
                  // horizontalTitleGap: 0,Ugx


                  // minVerticalPadding: 0,
                ),
                Stack(
                  children: [ListTile(
                    onTap: (){
                      //print(productList);
                      showTransactionFunc(context, orderStatusList[index], descList[index], priceList[index].toString(), transIdList[index], productList[index], "note", dateList[index], paidStatusList[index]);
                    //Navigator.pushNamed(context, MobileMoneyPage.id);
                    },
                    //subtitle:Text('22/06/2021') ,

                    title:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${ DateFormat('EE, dd, MMM').format(dateList[index])}', style: TextStyle(color: Colors.grey[500], fontSize: 12),),
                        Text('Order Status:  ${orderStatusList[index]}', style: TextStyle(color: Colors.green, fontSize: 13),),
                        Text("Payment: ${paidStatusList[index]}", style: TextStyle( color: paidStatusListColor[index], fontSize: 12),),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("id: ${transIdList[index]}", style: TextStyle( color: Colors.grey[500], fontSize: 12),),

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
                            child: Center(child: Text('Paid', style: TextStyle(color: Colors.white, fontSize: 12),)),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                          ),
                        ))

        ]),

                //_buildDivider(),
              ],
            ),
          );

        }),
  );
  }
}


