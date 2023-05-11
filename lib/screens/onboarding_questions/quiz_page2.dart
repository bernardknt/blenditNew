
import 'dart:async';

import 'package:blendit_2022/screens/onboarding_questions/quiz_page3.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ai_data.dart';
import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';
import '../../widgets/gliding_text.dart';


class QuizPage2 extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPage2State createState() => _QuizPage2State();
}

class _QuizPage2State extends State<QuizPage2> {
  var categoryName = ['Male', 'Female'];
  var categoryId = ['1','2'];

  void defaultInitialisation(){
    DatePicker.showDatePicker(context,
        currentTime: DateTime(1990,06,10,10,00),


        theme: DatePickerTheme(headerColor: kCustomColor, itemHeight: 50, itemStyle: kHeadingTextStyle.copyWith(color: kPureWhiteColor), backgroundColor: kBlueDarkColorOld),

        //showTitleActions: t,

        onConfirm: (time) async {
          // DateTime opening = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).openingTime,0);
          // DateTime closing = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).closingTime,0);
          // DateTime selectedDateTime = DateTime(value.date!.year,value.date!.month,value.date!.day,time.hour, time.minute);
          // var referenceTime = DateTime(2022,1,1,0,0);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString(kUserBirthday, DateFormat('dd/MMM/yyyy ').format(time));

          Provider.of<AiProvider>(context, listen: false).setUserBirthday(time);
          Provider.of<AiProvider>(context, listen: false).resetQuestionButtonColors();

          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> QuizPage3())
          );
          });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTyping();
    // defaultInitialisation();

  }

  void _startTyping() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {

      });
    });
  }

  animationTimer() {
    Timer(const Duration(milliseconds: 500), () {
     // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
      Navigator.pop(context);

      // Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    return Scaffold(
        backgroundColor: kPureWhiteColor,
        // appBar: AppBar(
        //   backgroundColor: Colors.deepOrangeAccent,
        //
        // ),
        body:
        SafeArea(
          child: Column(
              children :
              [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top:20.0, right: 20, left: 20),
                    child:
                    Hero(
                      tag: "message",
                      child: Card(
                        color: kCustomColor,
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(20))),
                        // shadowColor: kGreenThemeColor,
                        // color: kBeigeColor,
                        elevation: 1.0,

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: 260,
                              child: Center(child:

                              GlidingText(
                                text: "When is your Birthday? (Because everyone loves a birthday treat",
                                delay: const Duration(seconds: 0),
                              ),
                              )
                          ),
                        ),
                      ),
                    ),)),
                kLargeHeightSpacing,
                kLargeHeightSpacing,
                kLargeHeightSpacing,
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
                    onPressed: (){
                  defaultInitialisation();

                }, child: Text('My Birthday', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                GestureDetector(
                  onTap: (){
                    defaultInitialisation();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                          tag: "tag",
                          child: Lottie.asset('images/birthday.json', height: 150)),

                    ],),
                )


              ]
          ),
        )
    );
  }


}



