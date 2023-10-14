
import 'package:barcode_widget/barcode_widget.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/widgets/gym_ordered_content_details.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
var backgroundColour = kGreenThemeColor;

class _BookingTicketState extends State<BookingTicket> {
  @override
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
                              Text('${DateFormat('dd MMM yy').format(aiData.appointmentMadeDate)}',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),),
                              Text('${DateFormat('kk:mm aa').format(aiData.appointmentMadeDate)}',textAlign: TextAlign.start, style: kNormalTextStyleExtraSmall.copyWith(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),),
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

                    // phone button for beautician
                    RoundIconButtonsWidget(onPressed: (){
                     CommonFunctions().callPhoneNumber(aiData.appointmentMadeBeauticianPhoneNumber);
                    }, iconImage: Icon(Icons.phone, size: 18,), title: 'Call ${aiData.appointmentMadeBeautician}', mainColor: kAppPinkColor,),
                    RoundIconButtonsWidget(onPressed: (){
                     CommonFunctions().openMap(aiData.appointmentMadeBeauticianLatitude,aiData.appointmentMadeBeauticianLongitude);
                    }, iconImage: Icon(Icons.map_outlined, size: 18,), title: 'Get Directions', mainColor: kBlack,),
                    // RoundIconButtonsWidget(onPressed: (){
                    //
                    //   showModalBottomSheet(
                    //       context: context,
                    //       builder: (context) {
                    //         return Container(color: kBackgroundGreyColor,
                    //           // child: BeauticianStore(),
                    //         );
                    //       });
                    // }, iconImage: Icon(Icons.shopping_bag_rounded, size: 18,color: kBlack,), title: 'Shop store', mainColor: kYellowThemeColor,),


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
                          GymOrderedContentsWidget(orderIndex: index+1, quantity: aiData.appointmentMadeBeauticianItems[index]['quantity'], productName: aiData.appointmentMadeBeauticianItems[index]['product'], price: aiData.appointmentMadeBeauticianItems[index]['totalPrice']);

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

                    MaterialButton(
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
                    TextButton(onPressed: (){
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Cancelation Policy', textAlign:TextAlign.center,style: kHeadingTextStyle,),
                          content:
                          Container(
                            height: 280,
                            child: Column(
                              children: const [
                                Text('In case you want to cancel your booking, your booking shall be fully refunded to you under the booking terms. However you can only cancel within 24 hours of an appointment and this is taken on a case by case basis. Some providers like for functions and mikolo do not warrant a cancelation refund.', style: kNormalTextStyleDark,textAlign: TextAlign.justify,),
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
