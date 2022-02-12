import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BlenderOnboardingPage extends StatefulWidget {
  static String id = 'onboarding_page';


  @override
  _BlenderOnboardingPageState createState() => new _BlenderOnboardingPageState();
}
class _BlenderOnboardingPageState extends State<BlenderOnboardingPage> {
  //Create a list of PageModel to be set on the onBoarding Screens.
  CollectionReference userDetails = FirebaseFirestore.instance.collection('orders');
  final auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void defaultInitialization()async{
    final prefs =  await SharedPreferences.getInstance();
    name = prefs.getString(kFirstNameConstant)!;
  }
  Future<void> uploadUserData() async {

    final prefs =  await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((value) => prefs.setString(kToken, value!));
    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
      'firstName': prefs.getString(kFirstNameConstant),
          'lastName': prefs.getString(kFullNameConstant),
          'phoneNumber': prefs.getString(kPhoneNumberConstant),
          'subscribed': true,
          'token': prefs.getString(kToken)
    });
  }

  String name = '';
  double fontSize = 28;
  final pageList = [
    PageModel(
      color:
      Colors.black,
        //(0xff17183c),
      heroImagePath: 'images/pour.gif',
      title: const Text('100% Your Style',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 28.0,
          )),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text('Hi👋🏽'
            '! You can Now Create your Healthy Smoothies, Juice and Salads just the way you like it',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white)),
      ),
      icon: Icon(
        LineIcons.blender,
        color: const Color(0xFF17183c),
      ),
    ),

    PageModel(
      color: Colors.white,
      heroImagePath: 'images/cooking.gif',
      title: Text('Select Your Ingredients',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
            fontSize: 28.0,
          )),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text('Simply Add Fruits, Vegetables, Meats and everything Healthy and Nice..😋',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black)),
      ),
      icon: Icon(
        LineIcons.carrot,
        color: const Color(0xFFAF27A2),
      ),
    ),
    // SVG Pages Example
    PageModel(
      color: Colors.deepOrange,
      heroImagePath: 'images/relax.gif',
      title: Text('Hit Blend and Relax',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 28.0,
          )),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text('Your delivery is on its way to you. Done!',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white)),
      ),
      icon: Icon(
        LineIcons.motorcycle,
        color: const Color(0xFFFF557C),
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
        doneButtonText: "Enter",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: ()async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool(kIsFirstTimeUser, false);
          uploadUserData();
          Navigator.pop(context);
        },
        onSkipButtonPressed: ()async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool(kIsFirstTimeUser, false);
          uploadUserData();
          Navigator.pop(context);
        },
      ),
    );
  }
}