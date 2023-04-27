import 'dart:async';
import 'dart:math';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/font_constants.dart';
import 'onboarding_questions/quiz_page1.dart';


class WelcomeToNutri extends StatefulWidget {
  //  static String id = 'success_challenge_new';

  @override
  _WelcomeToNutriState createState() => _WelcomeToNutriState();
}

class _WelcomeToNutriState extends State<WelcomeToNutri> {



  late Timer _timer;
  var countryName = '';
  var countrySelected = false;
  var countryFlag = '';
  var countryCode = "+256";
  var name = "";
  var random = Random();
  var inspiration = "Welcome to Nutri, Our goal is to help you achieve your nutrition and health goals, Anywhere you go. Let me set you up";
  var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void defaultInitialization() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(kFirstNameConstant) ?? "";
    inspiration = "Welcome to Nutri $name, My name is Lisa. Let me set you up. Start by selecting your country";


  }
  //
  // Future<Object?> getUserAge(String uid) async {
  //
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   prefs.setString(kUserVision, userDoc["vision"]);
  //   final userData = userDoc.data();
  //
  //   return userData;
  // }
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    _startTyping();
    animationTimer();
  }
  String _displayText = '';
  int _characterIndex = 0;
  double opacityValue = 0.0;
  final String _text = 'Hello World';

  // void locationDeterminant() async {
  //   final position = await Geolocator.getCurrentPosition();
  //   final placemarks = await Geolocator.placemarkFromCoordinates(position.latitude, position.longitude);
  //
  //   final country = position.latitude;
  //   print('Your country: $country');
  // }

  void _startTyping() {
    Timer.periodic(Duration(milliseconds: 70), (timer) {
      setState(() {
        if (_characterIndex < inspiration.length) {
          _displayText += inspiration[_characterIndex];
          _characterIndex++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  final _random = new Random();
  animationTimer() async{
    final prefs = await SharedPreferences.getInstance();
    // final player = AudioCache();
    // player.play("transition.wav");
    _timer = Timer(const Duration(milliseconds: 7000), () {
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
      backgroundColor: kBlueDarkColorOld,
      body: Container(

        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: Text(_displayText ,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 15, color: kPureWhiteColor),)),
            ),
            kLargeHeightSpacing,
            Lottie.asset('images/lisa.json', height: 300, width: 300, fit: BoxFit.contain ),
            kSmallHeightSpacing,

            Opacity(
              opacity: opacityValue,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kCustomColor)),
                      onPressed: ()async {
                        final prefs = await SharedPreferences.getInstance();
                        countrySelected = true;
                        setState(() {

                        });
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context)=> QuizPage1())
                        // );
                        // getUserAge(prefs.getString(kUserId)!);
                        // users.doc(auth.currentUser!.uid).update({
                        //   // "aiActive": false,
                        //   "articleCount": messageCount,
                        // });
                        // Navigator.pop(context);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context)=> GoalsPage())
                        // );

                      }, child:
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
                            initialSelection: 'Uganda',
                            favorite: const ['+254','+255',"US"],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),

                  //Text("I am Ready", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
            ),
                  kMediumWidthSpacing,
                  GestureDetector(
                    onTap: () async{
                      final prefs = await SharedPreferences.getInstance();
                      print(countryName);
                      prefs.setInt(kNutriCount, 0);
                      prefs.setBool(kIsTutorial1Done, false);
                      prefs.setBool(kIsTutorial2Done, false);
                      prefs.setString(kUserCountryName, countryName);
                      prefs.setString(kUserCountryFlag, countryFlag);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> QuizPage1())
                      );


                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: kCustomColor,
                      child:
                      countrySelected == false ? Icon(Icons.thumb_up) :  Center(
                        child: Stack(

                          children: [


                            Lottie.asset('images/pulse.json', height: 100, width: 100, fit: BoxFit.contain ),
                            Positioned(
                                left: 2,
                                right: 2,
                                top: 10,
                                child: Icon(Icons.thumb_up, color: kBlueDarkColor,)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            // kSmallHeightSpacing,
            // Lottie.asset('images/challenge.json', height: 50, width: 150,),

            // SizedBox(height: 10,),
            // Center(child: Text('You have Earned',textAlign: TextAlign.center, style: GoogleFonts.lato( fontSize: 30),)),
            //SizedBox(height: 10,),
            // Center(child: Text('${points.toString()} points',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),)),
            )
          ],
        ),
      ),
    );
  }
}
