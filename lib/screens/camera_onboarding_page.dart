// import 'package:audioplayers/audioplayers.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/home_controller.dart';
import 'challenge_page.dart';


class BlenderOnboardingPage extends StatefulWidget {
  static String id = 'onboarding_page';


  @override
  _BlenderOnboardingPageState createState() => new _BlenderOnboardingPageState();
}
class _BlenderOnboardingPageState extends State<BlenderOnboardingPage> {
  //Create a list of PageModel to be set on the onBoarding Screens.
  CollectionReference userDetails = FirebaseFirestore.instance.collection('orders');
  final auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void defaultInitialization()async{
    // final player = AudioCache();
    // player.play("transition.wav");

    final prefs =  await SharedPreferences.getInstance();

    name = prefs.getString(kFirstNameConstant)!;
    // _firebaseMessaging.getToken().then((value) => token = value!);
    // prefs.setString(kToken, value!)
  }
  // Future<void> uploadUserData() async {
  //
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   final users = await FirebaseFirestore.instance
  //       .collection('users').doc(auth.currentUser!.uid)
  //       .update(
  //       {
  //     'firstName': prefs.getString(kFirstNameConstant),
  //         'lastName': prefs.getString(kFullNameConstant),
  //         'phoneNumber': prefs.getString(kPhoneNumberConstant),
  //         'subscribed': true,
  //         'token': token
  //   });
  //   prefs.setString(kToken, token);
  //
  // }
  var token = "old token";
  String name = '';
  double fontSize = 28;
  final pageList = [
    PageModel(
      color:
      Colors.black,
        //(0xff17183c),
      heroImagePath: 'images/olympics.gif',
      title:  Text('Welcome to Your Challenge',
          style: kHeading2TextStyleBold.copyWith(color: Colors.white, fontSize: 24),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Text('Each Challenge is designed to help you build your consistency and SMASH your goals.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white)),
      ),
      icon: const Icon(
        LineIcons.dumbbell,
        color: Color(0xFF17183c),
      ),
    ),

    PageModel(
      color: Colors.white,
      heroImagePath: 'images/cooking.gif',
      title:  Text('Preparation is Key',
        style: kHeading2TextStyleBold.copyWith(color: kBlack, fontSize: 24),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Text('Before starting you will receive the Rules, A Shopping list, and the schedule to prepare.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black)),
      ),
      icon: const Icon(
        LineIcons.carrot,
        color: Color(0xFFAF27A2),
      ),
    ),
    // SVG Pages Example
    PageModel(
      color: kGreenThemeColor,
      heroImagePath: 'images/photo.gif',
      title:  Text('Take a Photo',
        style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 24),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Text('Take a photo of your completed activity for accountability. We shall review',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white)),
      ),
      icon: const Icon(
        LineIcons.camera,
        color: kGreenThemeColor,
      ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //Pass pageList and the mainPage route.
      body: FancyOnBoarding(
        doneButtonText: "Start",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: ()async {
          // final prefs = await SharedPreferences.getInstance();
          Navigator.pop(context);
          Navigator.pushNamed(context, ChallengePage.id);
        },
        onSkipButtonPressed: ()async {
          final prefs = await SharedPreferences.getInstance();
          // prefs.setBool(kIsFirstTimeUser, false);
          // uploadUserData();
          Navigator.pop(context);
          Navigator.pushNamed(context, ChallengePage.id);
        },
      ),
    );
  }
}