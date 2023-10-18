import 'dart:async';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/widgets/gym_ordered_content_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/firebase_functions.dart';
import '../models/responsive/dimensions.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../utilities/icons_constants.dart';
import '../widgets/TicketDots.dart';
import '../widgets/roundedIcon.dart';
import 'booking_ticket.dart';
import 'mobileMoney.dart';


class AppointmentsPage extends StatefulWidget {
  static String id = 'events_page';

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {


  void defaultsInitiation() async{
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(kEmailConstant)!;
    setState((){
    });


  }
  // OVERRIDE INITIAL STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();

  }


  // Variables
  String title = 'Your';
  String userId = 'bernard';
  var date = [];
  List<GeoPoint>  cordList = [];
  var time = [];
  var formatter = NumberFormat('#,###,000');
  var providerNameList = [];
  var locationList = [];
  var imgList = [];
  var productsList = [];
  var providerNumberList = [];
  var appointmentId = [];
  var appointmentComplete = [];
  var note = [];
  var opacityList = [];
  var tokenList = [];
  var providerIdList = [];
  var bookingFeeList = [];
  var pendingList = [];
  var isProductList = [];
  var totalList = [];
  var token;

  var containerToDisplay = Padding(padding: EdgeInsets.all(10), child: Center(child: Text('You have no Appointments Scheduled', style: kHeadingTextStyle,),),);
  @override

  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width * 0.6;


    return Scaffold(
        backgroundColor: kPureWhiteColor,
        floatingActionButton:
        FloatingActionButton(
          onPressed: () async {

            var prefs = await SharedPreferences.getInstance();


            launch('${prefs.getString(kWhatsappNumber)}');


          },
          child: Lottie.asset('images/whatsapp.json', ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        body: SizedBox(
          width: MediaQuery.of(context).size.width >mobileWidth? screenDisplayWidth : MediaQuery.of(context).size.width,
          child:
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('sender_id', isEqualTo: userId).where('type', isEqualTo: "Appointment")
                  .where('cancelled', isEqualTo: false)
                  .orderBy('deliveryTime', descending: true).orderBy('order_time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {


                } else {
                  date = [];
                  cordList = [];
                  locationList = [];
                  imgList = [];
                  productsList = [];
                  appointmentId = [];
                  opacityList = [];
                  tokenList = [];
                  bookingFeeList = [];
                  providerNameList = [];
                  providerIdList = [];
                  opacityList = [];
                  providerNumberList = [];
                  totalList = [];

                  var appointments = snapshot.data!.docs;
                  for (var appointment in appointments) {
                    DateTime appointmentDateTime = appointment.get('deliveryTime').toDate();
                    if(appointmentDateTime.year >= DateTime.now().year && appointmentDateTime.month >= DateTime.now().month && appointmentDateTime.day >= DateTime.now().day){
                      if(appointment.get('paymentStatus')!= 'complete'){
                        locationList.add(appointment.get('location'));
                        totalList.add(appointment.get('total_price'));
                        imgList.add(appointment.get('image'));
                        productsList.add(appointment.get('items'));
                        note.add(appointment.get('chef_note'));
                        providerNumberList.add(appointment.get('phoneNumber'));
                        cordList.add(appointment.get('cord'));
                        appointmentId.add(appointment.get('orderNumber'));
                        bookingFeeList.add(appointment.get('total_price'));
                        providerNameList.add(appointment.get('providerName'));
                        providerIdList.add(appointment.get('serviceProvider'));
                        date.add(appointment.get('deliveryTime').toDate());
                        time.add(appointment.get('deliveryTime').toDate());
                        if (appointment.get('complete') == false){
                          appointmentComplete.add(false);
                        }else{
                          appointmentComplete.add(true);
                        }
                        if (appointment.get('paymentStatus') == 'pending'){
                          opacityList.add(0.0);
                          pendingList.add(1.0);
                          if(appointment.get('status') == 'Product'){
                            isProductList.add(true);
                          }else {
                            isProductList.add(false);
                          }
                        }else{
                          opacityList.add(1.0);
                          pendingList.add(0.0);
                        }
                      }
                    }
                  }

                }
                return appointmentId.isEmpty ?
                Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your appointments look lonely', style: kNormalTextStyle.copyWith(color: kBlack),),
                    Lottie.asset('images/pourJuice.json', height: 100)

                  ],
                ),) :
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(

                      itemCount: imgList.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: ()async{
                            final prefs = await SharedPreferences.getInstance();

                            // prefs.setDouble(kBeauticianLocationLatitude, cordList[index].latitude);
                            // prefs.setDouble(kBeauticianLocationLongitude, cordList[index].longitude);
                            //
                            // Provider.of<BeauticianData>(context, listen: false).clearBasket();
                            print(bookingFeeList);
                            print(productsList[index][0]['quantity']);

                            if (pendingList[index] == 1.0){
                              print(isProductList);

                              isProductList[index] == true ?
                              CoolAlert.show(


                                  context: context,
                                  type:
                                  CoolAlertType.success,
                                  widget: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text('Complete this Product Purchase with ${providerNameList[index]} by paying ${formatter.format(totalList[index])}', style: kNormalTextStyle.copyWith(fontSize: 14
                                        ), textAlign: TextAlign.center,),
                                        TicketDots(mainColor: kFontGreyColor, circleColor: kPureWhiteColor,),
                                        Text('Appointment Details', style: kNormalTextStyleSmallGrey,),

                                        ListView.builder(


                                            shrinkWrap: true,
                                            itemCount: productsList[index].length,
                                            itemBuilder: (context, i){
                                              return Container();
                                                // OrderedContentsWidget(
                                                //   defaultFontSize: 12.0,
                                                //
                                                //   orderIndex: i + 1,
                                                //   quantity: productsList[index][i]['quantity'],
                                                //   productDescription:productsList[index][i]['product'] ,
                                                //   productName: productsList[index][i]['description'],
                                                //   price: productsList[index][i]['totalPrice']);
                                            }),
                                        TicketDots(mainColor: kFontGreyColor, circleColor: kPureWhiteColor,),

                                        // Text('${productsList[index][0]['product']} - ${productsList[index][0]['description']}', style: kNormalTextStyleSmallGrey,)
                                      ],
                                    ),
                                  ),
                                  title: 'Buy Products',
                                  confirmBtnText: 'Pay',

                                  confirmBtnColor: kAppPinkColor,
                                  confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                                  lottieAsset: 'images/products.json', showCancelBtn: true, backgroundColor: kPureWhiteColor,


                                  onConfirmBtnTap: () async{
                                    // Provider.of<StyleProvider>(context, listen:false).setBookingPrice(totalList[index], true);
                                    // final prefs = await SharedPreferences.getInstance();
                                    //
                                    // setState((){
                                    //
                                    //   prefs.setString(kOrderId, appointmentId[index]);
                                    //
                                    //
                                    //   Navigator.pop(context);
                                    //   Navigator.pushNamed(context, MobileMoneyPage.id);
                                    //
                                    // });
                                  }


                              ) :

                              CoolAlert.show(


                                  context: context,
                                  type: CoolAlertType.success,
                                  widget: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text('Complete this appointment with ${providerNameList[index]} by paying Ugx ${formatter.format(totalList[index])}', style: kNormalTextStyle.copyWith(fontSize: 14
                                        ), textAlign: TextAlign.center,),
                                        TicketDots(mainColor: kFontGreyColor, circleColor: kPureWhiteColor,),
                                        Text('Appointment Details', style: kNormalTextStyleSmallGrey,),

                                        ListView.builder(


                                            shrinkWrap: true,
                                            itemCount: productsList[index].length,
                                            itemBuilder: (context, i){
                                              return GymOrderedContentsWidget(
                                                  orderIndex: i + 1,
                                                  quantity: productsList[index][i]['quantity'],
                                                  productName: productsList[index][i]['product'],
                                                  price: productsList[index][i]['totalPrice']);
                                            }),
                                        TicketDots(mainColor: kFontGreyColor, circleColor: kPureWhiteColor,),

                                        // Text('${productsList[index][0]['product']} - ${productsList[index][0]['description']}', style: kNormalTextStyleSmallGrey,)
                                      ],
                                    ),
                                  ),
                                  title: 'Complete Booking',
                                  confirmBtnText: 'Book',

                                  confirmBtnColor: kGreenThemeColor,
                                  confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                                  lottieAsset: 'images/waiting.json', showCancelBtn: true, backgroundColor: kPureWhiteColor,


                                  onConfirmBtnTap: () async{
                                    final prefs = await SharedPreferences.getInstance();

                                    setState((){

                                      prefs.setString(kOrderId, appointmentId[index]);
                                      prefs.setString(kOrderReason,note[index]);


                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, MobileMoneyPage.id);

                                    });
                                  }


                              );

                            } else {

                              Provider.of<AiProvider>(context, listen: false).setAppointmentMade(date[index], time[index], locationList[index], providerNameList[index], providerNumberList[index], cordList[index].latitude, cordList[index].longitude,
                                  productsList[index],
                                  appointmentId[index], providerIdList[index], totalList[index]);


                              showModalBottomSheet(
                                  elevation: 100.0,
                                  isScrollControlled: true,

                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: double.maxFinite,
                                      color: kBackgroundGreyColor,
                                      child:
                                      // Container()

                                       Scaffold(
                                           appBar: AppBar(
                                             elevation: 0,
                                             backgroundColor: kGreenThemeColor,
                                             automaticallyImplyLeading: false,
                                           ),
                                           body: BookingTicket()),
                                    );
                                  });
                              //showDialogFunc(context, imgList[index], productsList[index], locationList[index], date[index], appointmentId[index]);
                            }
                          },
                          child:
                          Stack(
                              children: [
                                Card(
                                  child: Row(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        Column(
                                          children: [
                                            RoundImageRing(networkImageToUse: imgList[index], outsideRingColor: kBeigeThemeColor, radius: 150,),

                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(providerNameList[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: kHeadingTextStyle,),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  kIconCalendar,
                                                  kSmallWidthSpacing,
                                                  Text(DateFormat('dd, MMMM, yyyy').format(date[index]),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kNormalTextStyle),
                                                ],
                                              ),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  kIconClock,
                                                  kSmallWidthSpacing,
                                                  Text(DateFormat('hh:mm aaa').format(time[index]),
                                                    style: kNormalTextStyle
                                                    ,),
                                                ],
                                              ),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  kIconLocation,
                                                  kSmallWidthSpacing,
                                                  Text("${locationList[index]}",overflow: TextOverflow.visible, style: kNormalTextStyle,),
                                                ],
                                              ),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  Icon(Iconsax.weight),
                                                  kSmallWidthSpacing,
                                                  Expanded(
                                                    child: Text(productsList[index][0]['product'],
                                                      style: kNormalTextStyle, overflow: TextOverflow.fade
                                                      ,),
                                                  ),
                                                ],
                                              ),
                                              kSmallHeightSpacing,
                                            ],
                                          ),),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(

                                    right: 10,
                                    top: 10,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        if (opacityList[index] == 0 ){
                                          CoolAlert.show(
                                              lottieAsset: 'images/sad.json',
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Are you sure you want to delete this Appointment",
                                              title: "Delete Appointment",
                                              confirmBtnText: 'Yes',
                                              confirmBtnColor: kFontGreyColor,
                                              cancelBtnText: 'Cancel',
                                              showCancelBtn: true,
                                              backgroundColor: kBlack,
                                              onConfirmBtnTap: (){
                                                FirebaseServerFunctions().removeAppointment(appointmentId[index],'orders','cancelled', true);
                                                Navigator.pop(context);
                                              }
                                          );
                                        }
                                      },

                                      child: Opacity(
                                          opacity: pendingList[index],
                                          child: kIconCancel),
                                    )),
                                Positioned(
                                  right: 10,
                                  bottom: 10,


                                  child: Opacity(
                                    opacity: pendingList[index],
                                    child: Container(


                                      decoration: const BoxDecoration(
                                          color: kBlueDarkColorOld,
                                          borderRadius: BorderRadius.all(Radius.circular(6))
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child:

                                        Text('Incomplete Booking', style: kNormalTextStyleWhitePendingLabel,),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,


                                  child: Opacity(
                                    opacity: opacityList[index],
                                    child: Container(


                                      decoration: BoxDecoration(
                                          color: appointmentComplete[index]== false?kAppPinkColor:kGreenThemeColor,
                                          borderRadius: BorderRadius.all(Radius.circular(6))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: appointmentComplete[index]== false?
                                        Text('BOOKED', style: kNormalTextStyleWhitePendingLabel,):
                                        Text('Completed', style: kNormalTextStyleWhitePendingLabel,),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        );
                      }),
                );

                // containerToDisplay;


              }
          ),
        )
    );
  }
}



