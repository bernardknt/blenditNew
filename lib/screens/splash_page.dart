import 'dart:async';
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blendit_2022/screens/welcome_page_new.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class SplashPage extends StatefulWidget {
  static String id = 'splash_page';

  @override
  _SplashPageState createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;
    prefs.setBool(kChallengeRequirements, false);


    Provider.of<AiProvider>(context, listen: false).setTipStatus();

    setState(() {
      userLoggedIn = isLoggedIn ;
      print('The login status is $isLoggedIn');
      if(userLoggedIn == true){
        _timer = Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushNamed(context, ControlPage.id);
          deliveryStream();

        });

      }

      else{
        _timer = Timer(const Duration(milliseconds: 1000), () {
          Navigator.pushNamed(context, WelcomePageNew.id);

        });

      }
    });
  }

  Future deliveryStream()async{

    var start = FirebaseFirestore.instance.collection('variables').snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((users) async {
        setState(() {
          Provider.of<AiProvider>(context, listen: false).
          setSubscriptionVariables(users["ugandaOneMonth"], users["ugandaOneYear"],users["internationalOneMonth"], users["internationalOneYear"], users["ugFirstAmount"], users["intFirstAmount"], users["customerCare"], users["tips"], users['notify'], users['tagline'] );
        });
      });
    });

    return start;
  }
  // Future deliveryStream() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final users = await FirebaseFirestore.instance
  //       .collection('variables').doc("7hkqndmv9b0arEWy4vc9")
  //       .get();
  //
  //   Provider.of<AiProvider>(context, listen: false).setSubscriptionVariables(users["ugandaOneMonth"], users["ugandaOneYear"],users["internationalOneMonth"], users["internationalOneYear"], users["ugFirstAmount"], users["intFirstAmount"], users["customerCare"], users["tips"], users['notify'] );
  //
  // }

  bool userLoggedIn = false;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // padding: EdgeInsets.all(40),
            color: kGreenThemeColor,
            child: Column(
              children: [
                Spacer(),
                Image.asset('images/nutri.png', fit: BoxFit.fitWidth,),
              ],
            ),
          ),
          // Positioned(
          //   top:150,
          //   left: 50,
          //   right: 50,
          //     child: Center(child: Text('Transformation\nTogether',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 25),))),
        ],
      ),
    );
  }
}
