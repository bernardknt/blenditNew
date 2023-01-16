
import 'package:blendit_2022/screens/onboarding_questions/quiz_page5.dart';
import 'package:flutter/material.dart';
import 'package:height_slider/height_slider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';







class QuizPage4 extends StatefulWidget {


  @override
  _QuizPage4State createState() => _QuizPage4State();
}

class _QuizPage4State extends State<QuizPage4> {
  int height = 170;
  String heightString = '170';

  String convertCmToFeet(double cm) {
    double inches = cm / 2.54;
    int feet = inches ~/ 12;
    int remainingInches = inches.floor() % 12;
    return "$feet ft $remainingInches in'";
  }

  void defaultInitializaion(){
    setState(() {
      heightString = convertCmToFeet(height.toDouble());
    });
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitializaion();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kGreenThemeColor,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt(kUserHeight, height);

          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> QuizPage5())
          );


        },
        label: const Text("Record Height", style: kNormalTextStyleWhiteButtons,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: Stack(
          children: [
            Center(
            child: HeightSlider(
              maxHeight: 220,
              minHeight: 130,
              accentColor: kBlack,
              // personImagePath: "images/doc_checking_tab.png",

              numberLineColor: kGreenThemeColor,
              sliderCircleColor: kGreenThemeColor,
              primaryColor: kGreenThemeColor,
              height: height,
              onChange: (val) {
                setState(() {
                  height = val;
                  heightString = convertCmToFeet(height.toDouble());
                });
              },
              unit: 'cm',
              // optional
            ),
          ),
            Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: Text('How tall are you🫣?',
                    textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
            ),
            Positioned(
                left: 20,
                top: 60,
                child: Container(
                  height: 50,
                  width: 90,
                  decoration: BoxDecoration(
                    color: kGreenThemeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Center(
                    child: Text("$heightString",
                        textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
            ),
          ]
        ),

      ),
    );
  }
}
