
import 'dart:async';

import 'package:blendit_2022/screens/onboarding_questions/quiz_page1.dart';
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
import '../../widgets/InputFieldWidget.dart';
import '../../widgets/InputFieldWidget2.dart';

class QuizPageName extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPageNameState createState() => _QuizPageNameState();
}

class _QuizPageNameState extends State<QuizPageName> {

  var fullName = 'Kangave';
  var firstName = '';
  var botOpacity = 1;


  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override

  animationTimer() {
    Timer(const Duration(milliseconds: 500), () {
     // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
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

        // appBar: AppBar(
        //   backgroundColor: Colors.deepOrangeAccent,
        //
        // ),
        body:
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children :
                  [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InputFieldWidget2(fontColor: kPureWhiteColor, boxRadius: 10,  leftPadding: 0,  labelText:' Full Names' ,hintText: 'Cathy Nalya', keyboardType: TextInputType.text, onTypingFunction: (value){
                        fullName = value;
                        firstName = fullName.split(" ")[0]; // Gets the first name in the 0 positiion from the full names
                      }, onTapFunction: () {
                        setState(() {
                          botOpacity = 0;
                        });


                      },),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
                        onPressed: () async{
                          final prefs = await SharedPreferences.getInstance();
                          if (fullName == ''){
                            showDialog(context: context, builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: const Text('Enter a Valid Name'),
                                content: Text('No name has been entered in the name field. Please enter a valid name', style: kNormalTextStyle.copyWith(color: kBlack),),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      // _btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'))],
                              );
                            });

                          } else {
                            prefs.setString(kFullNameConstant, fullName);

                            prefs.setString(kFirstNameConstant, firstName);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context)=> QuizPage1())
                            // );
                            Navigator.pushNamed(context, QuizPage1.id);
                          }


                        }, child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                  ]
              ),
              Positioned(
                  top: 60,
                  left: 0,

                  child: Opacity(
                    opacity: botOpacity.toDouble(),
                    child: Card(

                      // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      shadowColor: kGreenThemeColor,
                      color: kCustomColor,
                      elevation: 2.0,
                      child: Container(
                        width: 260,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text( "Welcome to Nutri, Il be your Host. Let me set you up. "
                              "Could you tell me your names?",textAlign: TextAlign.left,
                              style: kNormalTextStyle.copyWith(fontSize: 17, color: kBlack)),
                        ),
                      ),
                    ),
                  )
              ),
              Positioned(
                  top: 110,
                  right:40,
                  child: Opacity(
                      opacity: botOpacity.toDouble(),
                      child: Lottie.asset('images/lisa.json', height: 170, width: 170,)),
              ),

            ],
          ),
        )
    );
  }


}



