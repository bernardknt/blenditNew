
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
import '../../widgets/gliding_text.dart';


class QuizPage1 extends StatefulWidget {

  static String id = "quiz1Page";


  @override
  _QuizPage1State createState() => _QuizPage1State();
}

class _QuizPage1State extends State<QuizPage1> {
  var categoryName = ['Male', 'Female'];
  var categoryId = ['1','2'];
  var name = 'Kangave';
  String _displayText = '';
  int _characterIndex = 0;
  double opacityValue = 0.0;
  var inspiration = "";

  void defaultInitialisation()async{
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(kFirstNameConstant)!;
    inspiration = "Welcome to Nutri $name, My name is Lisa. Let me set you up. Start by selecting your country";

    setState((){
      _startTyping();
    });


  }
  void _startTyping() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {

      });
    });
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
        backgroundColor: kPureWhiteColor,

        body:
        SafeArea(
          child: Stack(
              children :
              [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 25),
                  child: Column(
                    children: [

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
                                  text: "$name, are you male or female?",
                                  delay: const Duration(seconds: 0),
                                ),
                                )
                            ),
                          ),
                        ),
                      ),
                      kLargeHeightSpacing,
                      Hero(
                          tag: "tag",
                          child: Lottie.asset('images/white.json', height: 150, width: 150, fit: BoxFit.contain )),

                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:280.0),
                  child: ListView.builder(
                      itemCount: categoryId.length,
                      itemBuilder: (context, index) {
                        return questionBlocks(categoryName[index],categoryId[index], index);
                      }),

                ),


              ]
          ),
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kPureWhiteColor),)),
        ),
      ),
    );
  }

}



