import 'dart:async';
import 'dart:math';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page5.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
// import 'package:googleapis/connectors/v1.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/CommonFunctions.dart';
import '../utilities/font_constants.dart';
import '../widgets/InputFieldWidget.dart';
import '../widgets/gliding_text.dart';
import 'onboarding_questions/quiz_page1.dart';
import 'package:provider/provider.dart';


class WelcomeToNutri extends StatefulWidget {
  //  static String id = 'success_challenge_new';

  @override
  _WelcomeToNutriState createState() => _WelcomeToNutriState();
}

class _WelcomeToNutriState extends State<WelcomeToNutri> {

  String email= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String password = '';
  String fullName = '';
  String firstName = '';
  String phoneNumber = '';

  late Timer _timer;
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
    inspiration = "Welcome to Blendit $name, My name is Lisa. Let me set you up. Start by adding your Number";
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
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {

      });
    });
  }

  final _random = new Random();
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

  Widget build(BuildContext context) {
    // var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;

    return Scaffold(
      backgroundColor: kPureWhiteColor,
      // appBar: AppBar(),
      body: Container(

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


                      // Text(_displayText ,textAlign: TextAlign.right, style: kNormalTextStyle2.copyWith(fontSize: 17, color: kBlack, fontWeight: FontWeight.normal),
                      //
                      // )
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountryCodePicker(
                        onInit: (value){
                          countryCode = value!.dialCode!;
                          countryName = value!.name!;
                          countryFlag = value!.flagUri!;

                        },
                        onChanged: (value){
                          countryCode = value.dialCode!;
                          countryName = value.name!;
                          countryFlag = value.flagUri!;
                          countrySelected = true;
                          setState(() {

                          });
                          // Navigator.pop(context);

                        },
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: Provider.of<AiProvider>(context,listen: false).favouriteCountry,
                        favorite: const ["US",'+256','+250','+254',],
                        // optional. Shows only country name and flag
                        showCountryOnly: true,

                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                  kMediumWidthSpacing,
                  InputFieldWidget(labelText: ' Mobile Number', hintText: '77100100', keyboardType: TextInputType.number,
                      onTypingFunction: (value){
                    setState(() {
                      if (value.split('')[0] == '7'){
                        invalidMessageDisplay = 'Incomplete Number';
                        if (value.length == 9 && value.split('')[0] == '7'){
                          phoneNumber = value;
                          phoneNumber.split('0');
                          print(value.split('')[0]);
                          print(phoneNumber.split(''));
                          changeInvalidMessageOpacity = 0.0;
                        } else if(value.length !=9 || value.split('')[0] != '7'){
                          changeInvalidMessageOpacity = 1.0;
                        }
                      }else {
                        invalidMessageDisplay = 'Number should start with 7';
                        changeInvalidMessageOpacity = 1.0;
                      }
                    });

                    phoneNumber = value;
                  }
                  ),

                ],
              ),

            ),
            ElevatedButton(
              // radius: 25,
              // backgroundColor: kCustomColor,
                onPressed: () async {
                  if (phoneNumber != ""){
                    final prefs = await SharedPreferences.getInstance();
                    print(countryName);
                    prefs.setInt(kNutriCount, 0);
                    prefs.setString(kPhoneNumberConstant, phoneNumber);
                    prefs.setBool(kIsTutorial1Done, false);
                    prefs.setBool(kIsTutorial2Done, false);
                    prefs.setString(kUserCountryName, countryName);
                    prefs.setString(kUserCountryFlag, countryFlag);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> QuizPage5())
                    );
                    print("PErfecto");
                  }else {
                    print("No phone Number entered");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Ooops! Enter your phone Number',textAlign: TextAlign.center, style: kHeading2TextStyleBold,),
                        content: Text('Enter your phone number to continue',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontSize: 18)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },);
                  }

                },
                child:
                Text("CONTINUE", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)

            )
          ],
        ),
      ),
    );
  }
}
