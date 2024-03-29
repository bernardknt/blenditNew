import 'dart:async';


import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/service_providers_model.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/screens/success_appointment_create.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/TicketDots.dart';
import 'package:blendit_2022/widgets/mm_payment_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

import '../../widgets/appointmentDateOption.dart';
import '../../widgets/carousel_for_photo_widget.dart';
import '../../widgets/dateSelectionWidget.dart';

Map<String, dynamic> splitString(String input) {
  RegExp regex = RegExp(r'(\d+)\$(\d+)');
  Match match = regex.firstMatch(input) as Match;
  if (match != null) {
    String? number = match.group(1);
    String? day = match.group(2);
    return {'number': int.parse(number!), 'day': int.parse(day!)};
  } else {
    return {};
  }
}



showGymProvider(context, img, providerName, location, Map products, about, phoneNumber, coordinates, locationImages, id, sessionTime
    ){
  var formatter = NumberFormat('#,###,000');






  CollectionReference userOrder = FirebaseFirestore.instance.collection('challenges');
  CollectionReference planUpload = FirebaseFirestore.instance.collection('plans');
  String orderId = 'ch${uuid.v1().split("-")[0]}${DateTime.now().month}${DateTime.now().day}';
  String challengeCreateId = 'plan${uuid.v1().split("-")[0]}${DateTime.now().month}${DateTime.now().day}';
  List boxElevation = [0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,];
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
      'heading': 'Weight loss plan',
      'promo': 'This is an amazing promo',
      'rules': "These are the rules of the fitness challenge",
      'welcome': 'Welcome to the fitness challenge',
      'rating':0,
      'rating_comment': '',
      'status': 'submitted',
      'total_price': 10000,
      'schedule': 'This is how the challenge will be played',

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


  return showDialog(context: context,barrierLabel: 'Items', builder: (context){
    animationTimer() {
      _timer = new Timer(const Duration(milliseconds: 3500), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
    var providersData = Provider.of<AiProvider>(context, listen: false);
    var providersDataListen = Provider.of<AiProvider>(context, listen: true);
    var blendedData = Provider.of<BlenditData>(context);
    return
      Scaffold(
        backgroundColor: kPureWhiteColor,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   foregroundColor: kAppPinkColor,
        // ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 170,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background:

                //Image.asset(img, fit: BoxFit.cover,),
                Stack(
                    children: [

                      Center(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(2),
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
                      providersDataListen.gymItemSelected.isEmpty?Container():Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10), ),color: Colors.orange ),
                          //color: Colors.red,
                          child: Column(
                            children: [
                              Text('Total Fee:', style: kNormalTextStyle.copyWith(color:kPureWhiteColor, fontSize: 12),),
                              Text('${formatter.format(providersDataListen.gymItemPrices * providersDataListen.onlineAppointmentTimeArray.length)} Ugx', style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),

                        ),
                      ),
                    ]
                ),
                title:  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(2),
                    height: 25,
                    width: double.infinity,
                    decoration: BoxDecoration(color: kGreenThemeColor, borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(providerName, textAlign: TextAlign.center,
                        style: kNormalTextStyle.copyWith(color: Colors.white, fontSize: 10),),
                    )),
                centerTitle: true ,

              ),
              backgroundColor:kBlueDarkColor ,),
            SliverFixedExtentList(delegate:
            SliverChildListDelegate([

              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(about,textAlign: TextAlign.justify, style: kNormalTextStyle.copyWith(color: kBlack),),
                    providersDataListen.gymItemSelected.isEmpty?Container():kSmallHeightSpacing,
                    providersDataListen.gymItemSelected.isEmpty?Container():Text("Select Time", textAlign: TextAlign.justify, style: kNormalTextStyle.copyWith(color:kGreenThemeColor, fontWeight: FontWeight.bold),),
                    providersDataListen.gymItemSelected.isEmpty?Container():DateSelectionWidget(selectedTime: sessionTime,),
                    kLargeHeightSpacing,
                    Text("Select Service", textAlign: TextAlign.justify, style: kNormalTextStyle.copyWith(color:kGreenThemeColor,fontSize: 18,  fontWeight: FontWeight.w400),),

                    SizedBox(
                      height: (60 * products.length/1.0) +20,
                      child: ListView.builder(
                          itemCount: products.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            var key = products.keys.elementAt(index);
                            var value = splitString(products[key]);


                            return GestureDetector(
                              onTap: (){
                                double inputQuantity = 1;
                                if (providersData.gymItemSelectedColorOfBoxes[index]==kCustomColor){

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          providerName,
                                          textAlign: TextAlign.center,
                                          style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 22),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        key,
                                                        textAlign: TextAlign.center,
                                                        style: kNormalTextStyle.copyWith(color: kBlack),
                                                      ),
                                                      Text(
                                                        "(${CommonFunctions().formatter.format(value['number'])} Ugx)",
                                                        textAlign: TextAlign.center,
                                                        style: kNormalTextStyle.copyWith(color: kBlack),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              kMediumWidthSpacing,
                                              SizedBox(
                                                width: 60,
                                                child: TextField(
                                                  controller: TextEditingController()..text = "1",
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  onChanged: (value) {
                                                    inputQuantity = double.parse(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: 'Quantity',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              providersData.setGymServiceBoxColor(
                                                index,
                                                providersData.gymItemSelectedColorOfBoxes[index],
                                                ServiceProviderItem(
                                                  amount: value['number'].toDouble(),
                                                  product: key,
                                                  quantity: inputQuantity!,
                                                  days: value['day'].toInt(),
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );




                                }else {
                                  providersData.setGymServiceBoxColor(index,providersData.gymItemSelectedColorOfBoxes[index], ServiceProviderItem(amount: value['number'].toDouble(), product: key, quantity: inputQuantity!, days: value['number'].toInt()), );
                                }

                                //
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    color:

                                    providersDataListen.gymItemSelectedColorOfBoxes[index],
                                    child: ListTile(
                                      // title: Text("x2"),
                                      leading: Text(key),

                                      trailing: Text(CommonFunctions().formatter.format(value['number'])),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: providersData.gymItemSelectedColorOfBoxes[index] == kCustomColor? Container():CircleAvatar(radius: 10, backgroundColor: Colors.orange , child: Text("x${providersDataListen.gymItemSelected[providersDataListen.gymItemSelected.indexWhere((element) => element.product == key)].quantity.toInt()}", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)))
                                ],
                              ),
                            );
                          }
                      ),
                    ),

                    kLargeHeightSpacing,
                    providersDataListen.freeSession == false ?Container():GestureDetector(
                      onTap: (){
                        providersData.setGymServiceBoxColor(
                          10,
                          kCustomColor,
                          ServiceProviderItem(
                            amount: 0.0,
                            product: "Free Session",
                            quantity: 1,
                            days: 1,
                          ),
                        );
                        showDialog(context: context,

                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Material(
                                  color: kBlueDarkColor,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Select a Time for the Session",
                                        style: kNormalTextStyle.copyWith(
                                            color: kPureWhiteColor,fontWeight: FontWeight.bold, fontSize: 20),),
                                      kLargeHeightSpacing,
                                      DateSelectionWidget(selectedTime: sessionTime),
                                      kLargeHeightSpacing,
                                      kLargeHeightSpacing,
                                      kLargeHeightSpacing,
                                      // providersDataListen.onlineAppointmentTimeArray.isEmpty?Container():
                                      Center(

                                        child: MobileMoneyPaymentButton(firstButtonFunction: ()async{

                                          if (providersDataListen.onlineAppointmentTimeArray.isNotEmpty){
                                            var itemsBought = [];
                                            for(var i =0; i<providersData.gymItemSelected.length; i++){
                                              itemsBought.add(providersData.gymItemSelected[i].product);
                                            }
                                            blendedData.setLocation(location);
                                            blendedData.setServiceProviderDetails(phoneNumber, coordinates, id, img, providerName);
                                            final prefs = await SharedPreferences.getInstance();
                                            prefs.setString(kBillValue,(providersDataListen.gymItemPrices * providersDataListen.onlineAppointmentTimeArray.length).toInt().toString() );
                                            prefs.setString(kOrderReason, "${providerName}:\n${itemsBought.join(", ")}" );
                                            prefs.setString(kOrderId, orderId );
                                            print(providersDataListen.gymItemPrices.toString());

                                            CommonFunctions().uploadAppointment(context, providersDataListen.onlineAppointmentTime,prefs.getString(kOrderReason)! , "", blendedData.location, prefs.getString(kPhoneNumberConstant)!, true, providersDataListen.gymItemPrices * providersDataListen.onlineAppointmentTimeArray.length, "Appointment", prefs.getString(kFullNameConstant)!, prefs.getString(kOrderId)!, providersDataListen.gymItemSelected, blendedData.providerId, phoneNumber, blendedData.providerCoordinate, blendedData.providerImage, blendedData.providerName, providersDataListen.onlineAppointmentTimeArray);

                                          }else {
                                            print("object");
                                            Get.snackbar(

                                                "No Date Selected", "Select a date inorder to proceed", colorText: kPureWhiteColor, backgroundColor: kAppPinkColor);
                                          }

                                        }, firstButtonText: "Get Free Session",
                                            buttonTextColor: kPureWhiteColor,
                                            lineIconFirstButton: Iconsax.maximize
                                        ),
                                      ),
                                      kLargeHeightSpacing,
                                      kLargeHeightSpacing,
                                      kLargeHeightSpacing,
                                      kLargeHeightSpacing,
                                      Text("Cancel",
                                        style: kNormalTextStyle.copyWith(
                                            color: kPureWhiteColor),)
                                    ],
                                  ),
                                ),
                              );
                            }
                        );


                      },
                      child:  Card(
                        margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                        color: kAppPinkColor,

                        shadowColor: kGreenThemeColor,
                        elevation: 5.0,
                        child: ListTile(
                          leading: Icon(LineIcons.dumbbell, color: kPureWhiteColor,),
                          title:Text("Get First Session Free", style:kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 18)),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ),
                    kLargeHeightSpacing,
                    providersDataListen.onlineAppointmentTimeArray.isEmpty?Container():
                    Center(
                      child: MobileMoneyPaymentButton(firstButtonFunction: ()async{
                        var itemsBought = [];
                        for(var i =0; i<providersData.gymItemSelected.length; i++){
                          itemsBought.add(providersData.gymItemSelected[i].product);
                        }
                        blendedData.setLocation(location);
                        blendedData.setServiceProviderDetails(phoneNumber, coordinates, id, img, providerName);
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString(kBillValue,(providersDataListen.gymItemPrices * providersDataListen.onlineAppointmentTimeArray.length).toInt().toString() );
                            prefs.setString(kOrderReason, "${providerName}:\n${itemsBought.join(", ")}" );
                            prefs.setString(kOrderId, orderId );
                            print(providersDataListen.gymItemPrices.toString());

                        CommonFunctions().uploadAppointment(context, providersDataListen.onlineAppointmentTime,prefs.getString(kOrderReason)! , "", blendedData.location, prefs.getString(kPhoneNumberConstant)!, true, providersDataListen.gymItemPrices * providersDataListen.onlineAppointmentTimeArray.length, "Appointment", prefs.getString(kFullNameConstant)!, prefs.getString(kOrderId)!, providersDataListen.gymItemSelected, blendedData.providerId, phoneNumber, blendedData.providerCoordinate, blendedData.providerImage, blendedData.providerName, providersDataListen.onlineAppointmentTimeArray);

                        // showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       return AppointmentOptionsDialog();
                        //     });
                      }, firstButtonText: "Buy Ticket",
                      buttonTextColor: kPureWhiteColor,
                          lineIconFirstButton: Iconsax.maximize
                      ),
                    ),

                  ],
                ),
              ),



            ]),
                itemExtent: 850)
          ],
        ),
      );

  });
}

