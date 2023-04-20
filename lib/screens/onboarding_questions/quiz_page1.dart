
import 'dart:async';

import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';


class QuizPage1 extends StatefulWidget {

  static String id = "quiz1Page";


  @override
  _QuizPage1State createState() => _QuizPage1State();
}

class _QuizPage1State extends State<QuizPage1> {
  var categoryName = ['Male', 'Female'];
  var categoryId = ['1','2'];
  var name = 'Kangave';

  void defaultInitialisation()async{
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(kFirstNameConstant)!;
    setState((){});


  }
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialisation();


  }

  @override

  animationTimer() {
    Timer(const Duration(milliseconds: 500), () {

      Provider.of<AiProvider>(context, listen: false).resetQuestionButtonColors();
      // Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=> QuizPage2())
      );

      // Navigator.pop(context);
    });
  }

  Widget build(BuildContext context) {
    // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    return Scaffold(
        backgroundColor: kBlueDarkColorOld,

        body:
        Stack(
            children :
            [
              SafeArea(
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:20.0),
                      child: Text('Hi $name, are you male or female?',
                        textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kBlueDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:150.0),
                child: ListView.builder(
                    itemCount: categoryId.length,
                    itemBuilder: (context, index) {
                      return questionBlocks(categoryName[index],categoryId[index], index);
                    }),

              ),
              Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Lottie.asset('images/workout4.json', height: 170),
                  Lottie.asset('images/workout6.json', height: 120)
                ],),
              )

            ]
        )
    );
  }
  Padding questionBlocks(String sex, String id, index) {
    var randomColors = [Colors.teal, Colors.blueAccent, Colors.black12, Colors.deepPurpleAccent, Colors.white12];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector (
        onTap: () async{
          final prefs = await SharedPreferences.getInstance();

          prefs.setString(kUserSex, sex);
          Provider.of<AiProvider>(context, listen: false).setButtonBoxColors(index, sex);

          animationTimer();



          // );
        },
        child: Container(
          // color: Colors.white,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color:
              //kGreenThemeColor
              Provider.of<AiProvider>(context).buttonColourQuestions[index]
          ),
          child: Center(child: Text(
            sex,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)),
        ),
      ),
    );
  }

}



