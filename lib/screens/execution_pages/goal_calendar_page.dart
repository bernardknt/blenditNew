
import 'package:blendit_2022/models/ai_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';
import '../loading_goals_page.dart';

class GoalCalendarPage extends StatefulWidget {
  static String id = 'GoalCalendar';

  const GoalCalendarPage({Key? key}) : super(key: key);

  @override
  State<GoalCalendarPage> createState() => _GoalCalendarPageState();
}

class _GoalCalendarPageState extends State<GoalCalendarPage> {
  final auth = FirebaseAuth.instance;
  final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('updateUserVision');

  Widget build(BuildContext context) {
    var aiDataDisplay = Provider.of<AiProvider>(context);
    var styleData = Provider.of<AiProvider>(context, listen: false);
    // var styleData = Provider.of<StyleProvider>(context,listen:false);
    return Scaffold(
        appBar: AppBar(backgroundColor: kPureWhiteColor ,
          title: const Text('Achieve Goal By Which Date?',style: kHeadingTextStyle,),
          centerTitle: true,
          elevation: 0,
          foregroundColor: kBlack,

        ),

        body: SfCalendar(
          // monthCellBuilder: (BuildContext buildContext, MonthCellDetails details) {
          //   return Container(
          //     color: Colors.black45.withOpacity(0.2),
          //     child: Text(
          //       details.date.day.toString(),
          //     ),
          //   );
          // },
          // allowDragAndDrop: true,
          // showCurrentTimeIndicator: true,
          showDatePickerButton: true,
          minDate: DateTime.now(),
          todayHighlightColor: kBlueDarkColorOld,
          todayTextStyle: kNormalTextStyleWhiteButtons,

          onTap: (value){
            // styleData.setBookingPrice(aiDataDisplay.totalPrice, false);
            DateTime selectedDateTime = DateTime(value.date!.year,value.date!.month,value.date!.day,8, 00);
            DateTime now = DateTime.now();
            if (selectedDateTime.difference(now).inDays < 10){
              print("Select a Goal to achieve in more than 30 Days");
              CoolAlert.show(

                  lottieAsset: 'images/sad.json',
                  context: context,
                  type: CoolAlertType.success,

                  text: 'Your goal should be ambitious and take more than 7 days to complete',
                  title: "Date Less than 7 days!",
                  cancelBtnText: "Cancel",
              );


            } else {
              CoolAlert.show(

                  lottieAsset: 'images/goal.json',
                  context: context,
                  type: CoolAlertType.success,

                  text: '${DateFormat('EEEE dd-MMM yyyy').format(selectedDateTime)}',
                  title: "Set Goal Date As",
                  confirmBtnText: 'Yes',
                  confirmBtnColor: Colors.green,
                  cancelBtnText: "Cancel",
                  showCancelBtn: true,
                  onCancelBtnTap: (){Navigator.pop(context); },
                  backgroundColor: kBackgroundGreyColor,
                  onConfirmBtnTap: () async{
                    dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{
                      'goal': "I want to Gain Weight 30kgs By 20th December 2023",
                      'userId':auth.currentUser!.uid,
                      // orderId
                    }).catchError((error){
                      print('Request failed with status code ${error.response.statusCode}');
                      print('Response body: ${error.response.data}');
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> LoadingGoalsPage())
                            );

                  }
              );
            }
          },
          view: CalendarView.month,
          initialSelectedDate: DateTime.now(),
          cellBorderColor: kBackgroundGreyColor,
          backgroundColor: kBackgroundGreyColor,
          selectionDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color:
            //kCustomColor.withOpacity(0.5),

             Colors.pink.withOpacity(0.5),
            border:
            Border.all(color: kGreyLightThemeColor,
                //const Color.fromARGB(255, 68, 140, 255),
                width: 2),
          ),
          // blackoutDates:
          // aiDataDisplay.convertedCalendarBlackouts,
          // blackoutDates:  [
          //
          //   DateTime.now().add(Duration(days: 3, hours: 14) ),
          //   DateTime.now().add(Duration(days: 6)),
          //   DateTime.now().add(Duration(days: 7)),
          //   DateTime.now().add(Duration(days: 12)),
          // ],
          blackoutDatesTextStyle: kNormalTextStyleDatesUnavailable,
          //
        ));
  }
}

