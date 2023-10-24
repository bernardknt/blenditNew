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

import '../../widgets/appointmentDateOption.dart';
import '../../widgets/carousel_for_photo_widget.dart';



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

class DateSelectionWidget extends StatelessWidget {

  DateSelectionWidget({required this.selectedTime});
  final DateTime selectedTime;
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 180,
        // width: 150,
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,// You can change this number based on how many cards you want.
          itemBuilder: (BuildContext context, int index) {

            // Generate a unique date for each card (you can modify this logic as needed).
            int currentMonth = DateTime.now().month;

           //DateTime currentDate = selectedTime.add(Duration(days: index));
            DateTime currentDate = DateTime( DateTime.now().year, currentMonth ,DateTime.now().day, selectedTime.hour, selectedTime.minute  );
            print(DateFormat('dd/MMM/yyy kk:mm ').format(currentDate));
            print(DateTime.now().month);
            // Get current hour and minute values
            int currentHour = DateTime.now().hour;
            int currentMinute = DateTime.now().minute;

            // Get selected hour and minute values
            int selectedHour = selectedTime.hour;
            int selectedMinute = selectedTime.minute;

            // Check if current hour is less than selected hour
            // or if current hour is equal to selected hour but current minute is less than selected minute
            if (currentHour < selectedHour || (currentHour == selectedHour && currentMinute < selectedMinute)) {
              print("THIS IS TRUE $currentHour < $selectedHour");
              currentDate = currentDate.add(Duration(days: index));
            } else {
              print("THIS RUN");
              currentDate = currentDate.add(Duration(days: index + 1));
            }

            return GestureDetector(

              onTap: (){
                Provider.of<AiProvider>(context, listen: false).setSelectedTimeValues(index, Provider.of<AiProvider>(context, listen: false).boxElevation[index], currentDate);

              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Provider.of<AiProvider>(context).boxElevationSelectedColorOfBoxes[index], width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                shadowColor: kGreenThemeColor,
                elevation: Provider.of<AiProvider>(context).boxElevation[index],
                //boxElevation[index],

                margin: EdgeInsets.all(8.0),
                child:

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${ DateFormat('EEEE').format(currentDate)}', style: kNormalTextStyle.copyWith(fontSize: 20, color: Colors.blueAccent),),
                        kSmallHeightSpacing,
                        SizedBox(
                           width: 90,

                            child: _buildDivider()),
                        Text('${ DateFormat('MMMM').format(currentDate)}', style: kNormalTextStyle,),
                        kSmallHeightSpacing,

                        CircleAvatar(
                            backgroundColor: kBlack,
                            child: Text('${currentDate.day}', style: TextStyle(fontSize: 18.0, color: kGreenThemeColor, fontWeight: FontWeight.bold),)),
                        kSmallHeightSpacing,
                        Text('${ DateFormat('kk:mm a').format(currentDate)}', style: kNormalTextStyle,),
                      ],
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }

  Container _buildDivider(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, ),
      width: double.infinity,
      height: 1.0,
      color: kFontGreyColor,

    );
  }
}