import 'dart:async';
import 'dart:math';
import 'package:blendit_2022/screens/calendar_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/font_constants.dart';
import 'loading_challenge.dart';
import 'mobileMoney.dart';


class SuccessPageNew extends StatefulWidget {
  static String id = 'success_page_new';

  @override
  _SuccessPageNewState createState() => _SuccessPageNewState();
}

class _SuccessPageNewState extends State<SuccessPageNew> {



  late Timer _timer;


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    animationTimer();
  }

  final _random = new Random();
  animationTimer() async {
    final prefs = await SharedPreferences.getInstance();
    _timer = Timer(const Duration(milliseconds: 5000), () {
      if (int.parse(prefs.getString(kBillValue)!) == 0) {

        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> LoadingChallengePage())
        );
      } else {
        Navigator.pop(context);
        Navigator.pushNamed(context, MobileMoneyPage.id);
      }

    });
  }

  Widget build(BuildContext context) {
    // var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('images/challenges.json', height: 150, width: 150, fit: BoxFit.cover ),
            kSmallHeightSpacing,
            Center(child: Text('Creating Your Challenge',textAlign: TextAlign.center, style: kNormalTextStyle)),
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
