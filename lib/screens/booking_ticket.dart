
import 'package:barcode_widget/barcode_widget.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/widgets/gym_ordered_content_details.dart';
import 'package:blendit_2022/widgets/mm_payment_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/CommonFunctions.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../widgets/TicketDots.dart';
import '../widgets/thick_circles.dart';


class BookingTicket extends StatefulWidget {

  static String id = 'booking_ticket';

  @override
  State<BookingTicket> createState() => _BookingTicketState();
}





class _BookingTicketState extends State<BookingTicket> {

  var backgroundColour = kGreenThemeColor;
  var availableDatesString = "";
  List<DateTime> availableDates = [];

  int findMaxDays(List data) {
    int maxDays = 0;

    for (Map<String, dynamic> item in data) {
      int days = item['days'] as int;
      if (days > maxDays) {
        maxDays = days;
      }
    }
    print("$maxDays days");

    return maxDays;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> openLiveSessionLink(String documentId) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('providers')
          .doc(documentId)
          .get();

      if (document.exists) {
        // String phoneNumber = document.data()[''];
        String phoneNumber = document.get('phone');

        if (phoneNumber != null) {
          CommonFunctions().goToLink(phoneNumber);

        } else {
          throw 'Link not found in the document.';
        }
      } else {
        throw 'Document not found with ID: $documentId';
      }
    } catch (e) {
      print('Error: $e');
      // Handle errors here, such as showing an error message to the user.
    }
  }
  void getAvailableDates (){
    var aiData = Provider.of<AiProvider>(context, listen: false);
    var dates = [];
    List<DateTime> datesArray = [];
    print(aiData.appointmentDaysArray);
    for (var i = 0; i< aiData.appointmentDaysArray.length;i++){
      dates.add(DateFormat('d/MMM/yy').format(aiData.appointmentDaysArray[i].toDate()));
      datesArray.add(aiData.appointmentDaysArray[i].toDate());
    }
    availableDates = datesArray;
    availableDatesString = dates.join(" & ");
  }

  bool isCurrentDateWithinRange(List<DateTime> dateList, int validityPeriod) {
    DateTime currentDate = DateTime.now();

    print("$dateList for $validityPeriod");
    // DateTime futureDate = currentDate.add(Duration(days: validityPeriod));

    for (DateTime date in dateList) {
      DateTime futureDate = date.add(Duration(days: validityPeriod)); // 1 October
      // date.add(Duration(days: validityPeriod)
     // if (date.isAtSameMomentAs(currentDate) || ((date.add(Duration(days: validityPeriod)).isAfter(currentDate)||date.add(Duration(days: validityPeriod)).isAtSameMomentAs(currentDate)) && date.isBefore(futureDate))) {
      if (
     // date.isAtSameMomentAs(currentDate) ||
      isSameDay(date, currentDate)
          ||
          (currentDate.isAfter(date) && currentDate.isBefore(futureDate)
      )
      ) {
        print("TRUE $date || $currentDate");
        //print(date.add(Duration(days: validityPeriod)).isAfter(currentDate)||date.add(Duration(days: validityPeriod)).isAtSameMomentAs(currentDate));

        // Current date falls within the range of 7 days ahead of the given date
        return true;
      }else if (currentDate.isBefore(date)){

        CoolAlert.show(


            context: context,
            type: CoolAlertType.success,

            title: 'This Session is not Yet',
            // confirmBtnText: 'Ok',

            // confirmBtnColor: kGreenThemeColor,
            // confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
            lottieAsset: 'images/waiting.json',
            // showCancelBtn: true,
            backgroundColor: kPureWhiteColor,


            onConfirmBtnTap: () async{
              Navigator.pop(context);
            }


        );
        return false;

      }else {
        CoolAlert.show(


            context: context,
            type: CoolAlertType.success,

            title: 'This Session Ended',
            // confirmBtnText: 'Ok',

            // confirmBtnColor: kGreenThemeColor,
            // confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
            lottieAsset: 'images/waiting.json',
            // showCancelBtn: true,
            backgroundColor: kPureWhiteColor,


            onConfirmBtnTap: () async{
              Navigator.pop(context);
            }


        );
        return false;
      }
    }

    // Current date does not fall within any of the dates in the array
    return false;
  }

  void checkTime(DateTime time, List<DateTime>dateRange, int validityPeriod) {
    print("COME ON COME ON: ${isCurrentDateWithinRange(dateRange, validityPeriod)}");
    var status = isCurrentDateWithinRange(dateRange, validityPeriod);
    List<DateTime> listDates = [DateTime.now()];

    DateTime currentTime = DateTime.now();
    DateTime fifteenMinutesBefore = currentTime.subtract(Duration(minutes: 15));
    DateTime oneHourAfter = currentTime.add(Duration(hours: 1));

    if(isCurrentDateWithinRange(dateRange, validityPeriod)){
      if (time.isBefore(oneHourAfter) && time.isAfter(fifteenMinutesBefore)) {

        openLiveSessionLink(Provider.of<AiProvider>(context, listen: false).appointmentMadeBeauticianId);
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Session Starts at ${DateFormat('kk:mm aa').format(Provider.of<AiProvider>(context).appointmentMadeDate)}', textAlign:TextAlign.center,style: kHeadingTextStyle,),
            content:
            Container(
              height: 100,
              child: Column(
                children: const [
                  Text('This session will be open 15 minutes before the scheduled time', style: kNormalTextStyleDark,textAlign: TextAlign.justify,),
                  CloseButton(
                    color: kAppPinkColor,
                  )
                ],
              ),
            ),

          ),
        );
      }
    }else {
      print("ELSE");
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAvailableDates();
  }
  @override

  Widget build(BuildContext context) {
    var aiData = Provider.of<AiProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kGreenThemeColor,),

      body:SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              kLargeHeightSpacing,
              Center(child: Text("Your Ticket", style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor),)),
              kLargeHeightSpacing,
              SizedBox(
                width: double.maxFinite,
                //height: 60,
                child:
                // The top part of the ticket
                Container(
                  decoration: BoxDecoration(
                      color: kPureWhiteColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20) )
                  ),
                  padding: EdgeInsets.all(12),
                  child:
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Location', style: kNormalTextStyleSmallGrey.copyWith(color: kBlack),),
                          Spacer(),
                          ThickCircle(),
                          Expanded(child:
                          Stack(
                              children: [
                                SizedBox(
                                  height: 24,
                                  child: LayoutBuilder(

                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children:
                                          List.generate((constraints.constrainWidth()/6).floor(), (index) => SizedBox(
                                            width: 3, height: 1,
                                            child:
                                            DecoratedBox(decoration: BoxDecoration(
                                                color: kBlack
                                            ),),
                                          ))
                                      );
                                    },

                                  ),
                                ),
                                Center(child: Icon(Iconsax.weight,color: kBlack)),
                              ]
                          )
                          ),
                          ThickCircle(),
                          Spacer(),
                          Text('Provider', style: kNormalTextStyleSmallGrey.copyWith(color: kBlack))
                        ],
                      ),
                      kLargeHeightSpacing,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 90,


                            child: Text(aiData.appointmentMadeLocation, style: kNormalTextStyleSmallGrey,),

                          ),

                          Column(
                            children: [
                             // Text('${DateFormat('dd MMM yy').format(aiData.appointmentMadeDate)}',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),),
                              Text('$availableDatesString',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),),

                              // Text('${aiData.appointmentDaysArray}',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),),
                              Text('${DateFormat('kk:mm aa').format(aiData.appointmentMadeDate)}',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),),
                              //Text('10:30',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),),
                            ],
                          ),

                          SizedBox(
                            width: 90,
                            child: Text(aiData.appointmentMadeBeautician,textAlign:TextAlign.end,  style: kNormalTextStyleSmallGrey,),
                          ),

                        ],
                      ),
                      // Row(
                      //   children: [
                      //     MaterialButton(
                      //       minWidth: double.minPositive,
                      //       color: kBlueDarkColorOld,
                      //       child: Text("Save to Calendar", style: kNormalTextStyleWhiteButtons.copyWith(fontSize: 12),),
                      //
                      //       onPressed: (){
                      //
                      //       },
                      //     ),
                      //   ],
                      // )


                    ],
                  ),
                ),

              ),

              TicketDots(mainColor: kGreenThemeColor, circleColor: kGreenThemeColor,),
              Container(
                decoration: BoxDecoration(
                  color: kPureWhiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text('Provider Details', style: kHeading2TextStyleBold,),


                    aiData.appointmentComplete == true?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("This Appointment was Completed", style: kNormalTextStyle.copyWith(color: kGreenThemeColor),),
                    ):

                    MobileMoneyPaymentButton(firstButtonFunction: (){
                      checkTime(aiData.appointmentMadeTime, availableDates, findMaxDays(aiData.appointmentMadeBeauticianItems));
                      print(aiData.appointmentMadeBeauticianId);
                    }, firstButtonText: "Attend Session", buttonTextColor: kPureWhiteColor,lineIconFirstButton:FontAwesomeIcons.dumbbell ,),


                    TicketDots(mainColor: kGreenThemeColor, circleColor: kGreenThemeColor,),
                  ],
                ),
              ),
              Container(


                decoration: BoxDecoration(
                  color: kPureWhiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text('Booking Details', style: kHeading2TextStyleBold,),

                    ListView.builder(

                        shrinkWrap: true,
                        itemCount: aiData.appointmentMadeBeauticianItems.length,
                        itemBuilder: (context, index){
                          return
                            //Container();
                          GymOrderedContentsWidget(orderIndex: index+1,
                            quantity: aiData.appointmentMadeBeauticianItems[index]['quantity'],
                            productName: aiData.appointmentMadeBeauticianItems[index]['product'],
                            price: aiData.appointmentMadeBeauticianItems[index]['totalPrice'],
                            days: aiData.appointmentMadeBeauticianItems[index]['days'].toInt(),
                          );

                          // OrderedContentsWidget(productDescription: Provider.of<StyleProvider>(context).appointmentMadeBeauticianItems[index]['description'], productName: Provider.of<StyleProvider>(context).appointmentMadeBeauticianItems[index]['product'],quantity: Provider.of<StyleProvider>(context).appointmentMadeBeauticianItems[index]['quantity'], orderIndex: index + 1, price: Provider.of<StyleProvider>(context).appointmentMadeBeauticianItems[index]['totalPrice'],);
                        }),
                    RoundIconButtonsWidget(onPressed: () async {


                    }, iconImage: Icon(Icons.receipt, size: 22,color: Colors.red,), title: 'Scan Me', mainColor: kPureWhiteColor,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          BarcodeWidget(
                            data: aiData.appointmentMadeAppointmentId,
                            barcode: Barcode.code128(),
                            //Barcode.code128(),
                            drawText: false,
                            color: kBlack,
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                          kSmallHeightSpacing,
                          Text(aiData.appointmentMadeAppointmentId, style: kNormalTextStyleExtraSmall.copyWith(fontSize: 12),)
                        ],
                      ),
                    ),
                    TicketDots(mainColor: kFontGreyColor, circleColor: kPureWhiteColor,),

                    ListTile(
                      minVerticalPadding: 18.5,
                     // leading: Text('*', style: kNormalTextStyle,),
                      title: Text('Amount Paid', style:kHeading2TextStyleBold.copyWith(color: kNewGreenThemeColor,fontSize: 15) ,),
                     //ext('', style:kHeading2TextStyleBold.copyWith(color: kFontGreyColor,fontSize: 15) ,),
                      trailing: Text(CommonFunctions().formatter.format(aiData.appointmentMadeTotalFee), style: kHeading2TextStyleBold.copyWith(color: kNewGreenThemeColor,fontSize: 15) ,),
                    ),





                    TicketDots(mainColor: kGreenThemeColor, circleColor: kGreenThemeColor,),
                  ],
                ),
              ),




              Container(
                decoration: BoxDecoration(
                  color: kPureWhiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [

                    aiData.appointmentComplete == true?Container(): MaterialButton(
                      minWidth: double.minPositive,
                      color: kFontGreyColor,
                      child: Text("Cancel Booking", style: kNormalTextStyleWhiteButtons.copyWith(fontSize: 12),),

                      onPressed: (){
                        if (DateTime.now() == DateTime.now()
                            // Provider.of<StyleProvider>(context, listen:false ).appointmentMadeDate
                        ){
                          print('You cannot Cancel Booking Now');
                        } else {
                          print('Cancel Now');
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context)=> CancelPage())
                          // );

                        }
                      },
                    ),
                    aiData.appointmentComplete == true?Icon(Icons.check_circle, color: kGreenThemeColor,size: 80,):TextButton(onPressed: (){
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Cancelation Policy', textAlign:TextAlign.center,style: kHeadingTextStyle,),
                          content:
                          Container(
                            height: 280,
                            child: Column(
                              children: const [
                                Text('Incase you want to cancel your booking, your booking shall be fully refunded to you under the booking terms. However you can only cancel within 24 hours of an appointment and this is taken on a case by case basis. Some providers like for functions and mikolo do not warrant a cancelation refund.', style: kNormalTextStyleDark,textAlign: TextAlign.justify,),
                                CloseButton(
                                  color: kAppPinkColor,
                                )
                              ],
                            ),
                          ),

                        ),
                      );


                    }, child: Text("Cancelation Terms", style: kNormalTextStyleBoldPink,)),
                    Container(width: double.maxFinite,)
                    // TicketDots(mainColor: kGreenThemeColor, circleColor: kGreenThemeColor,),
                  ],
                ),
              ),
              // Third Compartment

              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: kPureWhiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Image.asset('images/7.png',height: 60,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundIconButtonsWidget extends StatelessWidget {
  const RoundIconButtonsWidget({
    Key? key, required this.iconImage, required this.title, required this.onPressed, required this.mainColor,
  }) : super(key: key);
  final Icon iconImage;
  final String title;
  final Color mainColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: mainColor,
          child: iconImage,
        ),
        title: Text("$title", overflow: TextOverflow.ellipsis, style: kHeading2TextStyleBold.copyWith(color: kBlack,fontSize: 15)),

      ),
    );
  }
}
