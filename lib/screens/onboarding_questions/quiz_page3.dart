
import 'package:blendit_2022/screens/onboarding_questions/quiz_page4.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../../utilities/font_constants.dart';






class QuizPage3 extends StatefulWidget {


  @override
  _QuizPage3State createState() => _QuizPage3State();
}

class _QuizPage3State extends State<QuizPage3> {
  int height = 170;
  late WeightSliderController _controller;
  double weight = 65.0;

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
        initialWeight: weight, minWeight: 10, interval: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundGreyColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kGreenThemeColor,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setDouble(kUserWeight, weight);

          Navigator.push(context,

              MaterialPageRoute(builder: (context)=> QuizPage4())
          );

        },
        label: const Text("Record Weight", style: kNormalTextStyleWhiteButtons,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: Stack(
            children: [
              Center(
                child:

                Column(
                children: [
                  Container(
                  height: 200.0,
                  alignment: Alignment.center,
                  child: Text(
                    "${weight.toStringAsFixed(1)} kg",
                    style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w500),
                  ),
                ),
                VerticalWeightSlider(
                  isVertical: true,


                  maxWeight: 200,
                  controller: _controller,
                  decoration: const PointerDecoration(
                    width: 130.0,
                    height: 10,
                    largeColor: kGreenThemeColor,
                    mediumColor: kAppPinkColor,
                    //Color(0xFFC5C5C5),
                    smallColor: kBlueDarkColor,
                    //Color(0xFFF0F0F0),
                    gap:30.0,
                  ),
                  onChanged: (double value) {
                    setState(() {
                      weight = value;
                    });
                  },
                  indicator: Container(
                    height: 3.0,
                    width: 200.0,
                    alignment: Alignment.centerLeft,
                    color: Colors.red[300],
                  ),
                ),
                ],), ),


              Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: Text('What is your Weight?',
                    textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kBlack, fontSize: 20)),
              ),
            ]
        ),

      ),
    );
  }
}
