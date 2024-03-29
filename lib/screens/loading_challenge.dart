import 'dart:async';
import 'dart:math';

import 'package:blendit_2022/utilities/constants.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/responsive/responsive_layout.dart';
import '../utilities/font_constants.dart';
import 'mobileMoney.dart';


class LoadingChallengePage extends StatefulWidget {
 //  static String id = 'success_challenge_new';

  @override
  _LoadingChallengePageState createState() => _LoadingChallengePageState();
}

class _LoadingChallengePageState extends State<LoadingChallengePage> {



  late Timer _timer;
  var random = Random();
  var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    animationTimer();
  }

  final _random = new Random();
  animationTimer() async{
    final prefs = await SharedPreferences.getInstance();
    // final player = AudioCache();
    // player.play("transition.wav");
    _timer = Timer(const Duration(milliseconds: 5000), () {
      prefs.setBool(kChallengeActivated, true);


      Navigator.pop(context);
      // Navigator.pushNamed(context, ResponsiveLayout.id);
      setState(() {

      });


    });
  }

  Widget build(BuildContext context) {
    // var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(

        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
           // Lottie.asset('images/challengeLoad.json', height: 200, width: 200, fit: BoxFit.contain ),
            Lottie.asset('images/freeChat.json', height: 200, width: 200, fit: BoxFit.contain ),
            kSmallHeightSpacing,
            Center(child: Text('...Free Session Activated' ,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 18, color: kPureWhiteColor),)),
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
