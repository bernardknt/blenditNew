import 'dart:async';
import 'dart:math';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/execution_pages/goal_calendar_page.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page5.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import '../../models/CommonFunctions.dart';
import '../../utilities/font_constants.dart';
import '../../widgets/InputFieldWidget2.dart';
import '../../widgets/gliding_text.dart';
import '../calendar_page.dart';


class WildlyImportantGoal extends StatefulWidget {
  //  static String id = 'success_challenge_new';

  @override
  _WildlyImportantGoalState createState() => _WildlyImportantGoalState();
}

class _WildlyImportantGoalState extends State<WildlyImportantGoal> {



  late Timer _timer;
  var goalSet= "";
  var countryName = '';
  var countrySelected = false;
  var initialCountry = "";
  var countryFlag = '';
  var countryCode = "+256";
  var name = "";
  var random = Random();
  var inspiration = "Welcome to Nutri, Our goal is to help you achieve your nutrition and health goals, Anywhere you go. Let me set you up";
  var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void defaultInitialization() async {
    final prefs = await SharedPreferences.getInstance();

    initialCountry = Provider.of<AiProvider>(context,listen: false).favouriteCountry;
    name = prefs.getString(kFirstNameConstant) ?? "";
    Provider.of<AiProvider>(context, listen: false).setUseName(name);
    inspiration = "$name, What Important Goal would you like to achieve?";
    CommonFunctions().uploadUserTokenWithName(prefs.getString(kToken)!,prefs.getString(kFirstNameConstant), prefs.getString(kFullNameConstant) );



  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    _startTyping();
    animationTimer();
  }
  double opacityValue = 0.0;
  final String _text = 'Hello World';


  void _startTyping() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if(!mounted){
        timer.cancel();
        return;
      }
      setState(() {

      });
    });
  }


  animationTimer() async{
    final prefs = await SharedPreferences.getInstance();
    _timer = Timer(const Duration(milliseconds: 3000), () {
      prefs.setBool(kChallengeActivated, true);
      // Navigator.pop(context);
      opacityValue = 1.0;
      setState(() {

      });

    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent calling setState() after dispose()
    super.dispose();
  }

  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: kPureWhiteColor,
      appBar: AppBar(
        backgroundColor: kPureWhiteColor,
        foregroundColor: kBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container( 

            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

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
                          child:
                          Center(child: GlidingText(
                            text: inspiration,
                            delay: const Duration(seconds: 1),
                          ),

                          )
                      ),
                    ),
                  ),
                ),
                kLargeHeightSpacing,
                Hero(

                    tag: "tag",
                    child: Lottie.asset('images/white.json', height: 300, width: 300, fit: BoxFit.contain )),
                kSmallHeightSpacing,

                Opacity(
                  opacity: opacityValue,
                  child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children :
                      [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:

                          TextField(
                            onChanged: (enteredQuestion){
                              goalSet = enteredQuestion;
                            },
                            decoration: InputDecoration(
                                border:
                                //InputBorder.none,
                                OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.green, width: 2),
                                ),
                                labelText: 'Goal',
                                labelStyle: kNormalTextStyleExtraSmall,
                                hintText: 'I want to lose 10kg',
                                hintStyle: kNormalTextStyle
                            ),

                          ),

                        ),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
                            onPressed: () async{
                              final prefs = await SharedPreferences.getInstance();
                              if (goalSet == ''){
                                showDialog(context: context, builder: (BuildContext context){
                                  return CupertinoAlertDialog(
                                    title: const Text('Goal Empty'),
                                    content: Text('No Goal has been entered. Please enter your goal', style: kNormalTextStyle.copyWith(color: kBlack),),
                                    actions: [CupertinoDialogAction(isDestructiveAction: true,
                                        onPressed: (){
                                          // _btnController.reset();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'))],
                                  );
                                });

                              } else {
                                Provider.of<AiProvider>(context, listen: false).setGoalValue(goalSet); 
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> GoalCalendarPage())
                                );
                                // Navigator.pushNamed(context, QuizPage1.id);
                              }


                            }, child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                      ]
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
