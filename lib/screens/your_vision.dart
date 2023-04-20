import 'dart:async';
import 'dart:math';
// import 'package:audioplayers/audioplayers.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/font_constants.dart';
import 'home_page.dart';
import 'mobileMoney.dart';
import 'onboarding_questions/quiz_page1.dart';


class YourVision extends StatefulWidget {
  //  static String id = 'success_challenge_new';

  @override
  _YourVisionState createState() => _YourVisionState();
}

class _YourVisionState extends State<YourVision> {



  late Timer _timer;
  var random = Random();
  var name = "Anonymous";
  var firstName = "Anonymous";
  var inspiration = "This year I will conquer every obstacle, push past every limit, and run with unwavering determination until I stand victorious at the finish line of the MTN Marathon.";
  var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];

  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    inspiration = prefs.getString(kUserVision)!;
    name = prefs.getString(kFullNameConstant)!;
    firstName = prefs.getString(kFirstNameConstant)!;

    // setState(() {
    //
    // });



  }
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
    _timer = Timer(const Duration(milliseconds: 12000), () {
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
      appBar: AppBar(
        backgroundColor: kBlueDarkColor,
        elevation: 0,
        title: Text("$firstName's Vision"),
        centerTitle: true,
      ),
      body: Container(

        padding: EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Lottie.asset('images/vision.json', height: 200, width: 200, fit: BoxFit.contain ),
            kSmallHeightSpacing,
            Center(child: Text(_displayText ,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 20, color: kPureWhiteColor),)),

            Opacity(
              opacity: opacityValue,
              child: Column(
                children: [
                  kLargeHeightSpacing,
                  Center(child: Text("~ $name ~" ,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 14, color: kCustomColor),)),

                  kLargeHeightSpacing,
                  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kAppPinkColor)),
                      onPressed: (){
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context)=> QuizPage1())
                        // );
                        // Navigator.pop(context);
                        // Navigator.pushNamed(context, HomePage.id);
                        Share.share('${_displayText}\nhttps://bit.ly/3I8sa4M', subject: 'Checkout my vision for the year');


                      }, child: Text("Share", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                ],
              ),
            ),
            // kSmallHeightSpacing,
            // Lottie.asset('images/challenge.json', height: 50, width: 150,),

            // SizedBox(height: 10,),
            // Center(child: Text('You have Earned',textAlign: TextAlign.center, style: GoogleFonts.lato( fontSize: 30),)),
            //SizedBox(height: 10,),
            // Center(child: Text('${points.toString()} points',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),)),
          ],
        ),
      ),
    );
  }
}
