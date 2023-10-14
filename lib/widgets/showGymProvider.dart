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
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

import 'appointmentDateOption.dart';
import 'carousel_for_photo_widget.dart';



showGymProvider(context,
    img, providerName, location, Map products, about, phoneNumber, coordinates, locationImages, id
    ){
  var formatter = NumberFormat('#,###,000');

  bool planActive = false;

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
    var providersDataListen = Provider.of<AiProvider>(context);
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
                              Text('${formatter.format(providersDataListen.gymItemPrices)} Ugx', style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),
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

                    TicketDots(mainColor: kBlueDarkColor, circleColor: kPureWhiteColor,backgroundColor: kPureWhiteColor,),

                    Row(
                      children: [
                        Expanded(
                          flex:3,
                          child:
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context,

                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Card(
                                                  color: kBiegeThemeColor,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(providerName,textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 25),),
                                                        Text(about,textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 22),),
                                                      ],
                                                    ),
                                                  )),
                                              kLargeHeightSpacing,
                                              kLargeHeightSpacing,
                                              kLargeHeightSpacing,
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
                                      ),
                                    );
                                  }
                              );
                              // Get.snackbar('This is a Days Challenge', about,
                              //     snackPosition: SnackPosition.TOP,
                              //     backgroundColor: kCustomColor,
                              //     colorText: kBlack,
                              //     icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
                            },
                            child: Row(
                              children: [
                                Icon(Iconsax.clock, color: kPureWhiteColor,),
                                kSmallWidthSpacing,
                                Text('About', textAlign: TextAlign.center,style: kNormalTextStyle.copyWith(color:kBlack, ),

                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child:
                          GestureDetector(
                            onTap: (){
                              var available = "";
                              // Navigator.pop(context);
                              // CommonFunctions().openMap(prefs.getDouble(kBeauticianLocationLatitude)!, prefs.getDouble(kBeauticianLocationLongitude)!);



                              Get.snackbar('Location of $providerName', location,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: kCustomColor,
                                  colorText: kBlack,
                                  icon: Icon(Icons.check_circle, color: kBlack,));
                            },
                            child: Icon(Iconsax.location, color: kBlack,),
                          ),
                        ),
                        Expanded(
                          flex:3,
                          child:
                          GestureDetector(
                              onTap: (){
                                showDialog(context: context,

                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Material(
                                          color: kBlack,
                                          child:

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CarouselPhotosWidget(urlImages: locationImages, height: 300,),
                                              kLargeHeightSpacing,
                                              kLargeHeightSpacing,
                                              kLargeHeightSpacing,
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
                              //  CarouselPhotosWidget(urlImages: styleDataDisplay.beauticianClients);
                              },

                              child: Icon(Iconsax.gallery, color: kBlack,)),
                        ),

                      ],
                    ),
                    TicketDots(mainColor: kBlueDarkColor, circleColor: kPureWhiteColor,backgroundColor: kPureWhiteColor,),
                    kLargeHeightSpacing,
                    Text("Select Service", textAlign: TextAlign.justify,
                      style: kNormalTextStyle.copyWith(color:kBlack),
                    ),
                    SizedBox(
                      height: (60 * products.length/1.0) +20,
                      child: ListView.builder(
                          itemCount: products.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            var key = products.keys.elementAt(index);
                            var value = products[key];


                            return GestureDetector(
                              onTap: (){
                                double inputQuantity = 1;
                                if (providersData.gymItemSelectedColorOfBoxes[index]==kButtonGreyColor){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(providerName, textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 22),),
                                        content:Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(key, textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack),),
                                                  Text("(${CommonFunctions().formatter.format(value)} Ugx)", textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack),),
                                                ],
                                              ),
                                            ),
                                            kMediumWidthSpacing,
                                            SizedBox(

                                              width: 60,
                                              child: TextField(
                                                controller:  TextEditingController()..text = "1",
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
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              providersData.setGymServiceBoxColor(index,providersData.gymItemSelectedColorOfBoxes[index], ServiceProviderItem(amount: value.toDouble(), product: key, quantity: inputQuantity!) );
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }else {
                                  providersData.setGymServiceBoxColor(index,providersData.gymItemSelectedColorOfBoxes[index], ServiceProviderItem(amount: value.toDouble(), product: key, quantity: inputQuantity!) );
                                }

                                //
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    color: providersDataListen.gymItemSelectedColorOfBoxes[index],
                                    child: ListTile(
                                      // title: Text("x2"),
                                      leading: Text(key),

                                      trailing: Text(CommonFunctions().formatter.format(value)),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: providersData.gymItemSelectedColorOfBoxes[index] == kButtonGreyColor? Container():CircleAvatar(radius: 10, backgroundColor: Colors.orange , child: Text("x${providersDataListen.gymItemSelected[providersDataListen.gymItemSelected.indexWhere((element) => element.product == key)].quantity.toInt()}", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)))
                                ],
                              ),
                            );
                          }
                      ),
                    ),

                    kLargeHeightSpacing,
                    kLargeHeightSpacing,
                    providersDataListen.gymItemSelected.isEmpty?Container():
                    Center(
                      child: MobileMoneyPaymentButton(firstButtonFunction: ()async{
                        var itemsBought = [];
                        for(var i =0; i<providersData.gymItemSelected.length; i++){
                          itemsBought.add(providersData.gymItemSelected[i].product);
                        }
                        blendedData.setLocation(location);
                        blendedData.setServiceProviderDetails(phoneNumber, coordinates, id, img, providerName);
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString(kBillValue, providersDataListen.gymItemPrices.toInt().toString() );
                            prefs.setString(kOrderReason, "${providerName}:\n${itemsBought.join(", ")}" );
                            prefs.setString(kOrderId, orderId );
                            print(providersDataListen.gymItemPrices.toString());

                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return AppointmentOptionsDialog();
                            });
                      }, firstButtonText: "Book Service",
                      buttonTextColor: kPureWhiteColor,
                          lineIconFirstButton: Iconsax.maximize
                      ),
                    ),
                    // SliderButton(
                    //
                    //
                    //
                    //   action: () async{
                    //
                    //     showModalBottomSheet(
                    //         context: context,
                    //         builder: (context) {
                    //           return AppointmentOptionsDialog();
                    //         });
                    //     // final prefs = await SharedPreferences.getInstance();
                    //     // prefs.setString(kBillValue, providersDataListen.gymItemPrices.toInt().toString() );
                    //     // prefs.setString(kOrderReason, providerName );
                    //     // prefs.setString(kOrderId, orderId );
                    //     // print(providersDataListen.gymItemPrices.toString());
                    //     // Navigator.pop(context);
                    //     // Navigator.pushNamed(context, SuccessPageNew.id);
                    //   },
                    //   ///Put label over here
                    //   label: Text(
                    //     "Slide to Book Service",
                    //     style: kHeading2TextStyleBold.copyWith(color: Colors.white),),
                    //   icon: Lottie.asset('images/workout5.json', width: 70, height: 70, fit: BoxFit.cover),
                    //
                    //   //Put BoxShadow here
                    //   boxShadow: BoxShadow(
                    //     color: Colors.black,
                    //     blurRadius: 2,
                    //   ),
                    //
                    //
                    //   width: double.maxFinite,
                    //   radius: 50,
                    //   buttonColor: kPureWhiteColor ,
                    //   backgroundColor: kBlack,
                    //   highlightedColor: Colors.black,
                    //   baseColor: kGreenThemeColor,
                    // ),
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

