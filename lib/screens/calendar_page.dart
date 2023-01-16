
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/ai_data.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';


class CalendarPage extends StatefulWidget {
 static String id = 'CalendarPage';

  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override

  Widget build(BuildContext context) {
    //var styleDataDisplay = Provider.of<StyleProvider>(context);
   // var styleData = Provider.of<StyleProvider>(context, listen: false);
    // var styleData = Provider.of<StyleProvider>(context,listen:false);
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(backgroundColor: kPureWhiteColor ,
        title: const Text('Challenge Start Date',style: kHeadingTextStyle,),
        centerTitle: true,


      ),

        body: SfCalendar(

          showDatePickerButton: true,
          minDate: DateTime.now(),
          todayHighlightColor: kBlueDarkColorOld,
          todayTextStyle: kNormalTextStyleWhiteButtons,

          onTap: (value){
            //styleData.setBookingPrice(styleDataDisplay.totalPrice, false);
            DatePicker.showTimePicker(context,
                currentTime: DateTime(2022,12,9,10,00),
                showSecondsColumn: false,
                theme: const DatePickerTheme(itemHeight: 50, itemStyle: kHeadingTextStyle),

                //showTitleActions: t,

                onConfirm: (time){
              // DateTime opening = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).openingTime,0);
              // DateTime closing = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).closingTime,0);
              DateTime selectedDateTime = DateTime(value.date!.year,value.date!.month,value.date!.day,time.hour, time.minute);
              var referenceTime = DateTime(2022,1,1,0,0);
              print(referenceTime.hour);
              if (selectedDateTime.month == DateTime.now().month && selectedDateTime.day == DateTime.now().day && selectedDateTime.hour < DateTime.now().hour){
                Get.snackbar('Time Passed', 'Choose a time that has not passed');


              }  else {
                Provider.of<AiProvider>(context, listen: false).setAppointmentTimeDate(value.date, time);
                Provider.of<AiProvider>(context, listen:false).setWelcomeButtons(2);
                Provider.of<AiProvider>(context, listen: false).setAppointmentTimeDate(selectedDateTime, time);

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, ChallengePage.id);
              }
              CommonFunctions().scheduledNotification(heading: 'Time to Get it done', body: "Get your self ready you challenge is today", year: selectedDateTime.year, month: selectedDateTime.month, day: selectedDateTime.day, hour: time.hour, minutes: time.minute, id: 1);
            });


          },
          view: CalendarView.month,
          initialSelectedDate: DateTime.now(),
          cellBorderColor: kBackgroundGreyColor,
          backgroundColor: kBackgroundGreyColor,
          selectionDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.pink.withOpacity(0.5),
            border:
            Border.all(color: kGreyLightThemeColor,
            //const Color.fromARGB(255, 68, 140, 255),
                width: 2),
          ),
          // blackoutDates:
          // styleDataDisplay.convertedCalendarBlackouts,
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

