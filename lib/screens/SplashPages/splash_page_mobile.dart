import 'dart:async';
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/models/firebase_functions.dart';
import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/screens/Welcome_Pages/welcome_page_web.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/looping_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blendit_2022/screens/Welcome_Pages/welcome_page_mobile.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';


class SplashPageMobile extends StatefulWidget {
  static String id = 'splash_page_mobile';

  @override
  _SplashPageMobileState createState() => _SplashPageMobileState();
}
class _SplashPageMobileState extends State<SplashPageMobile> {
  late Timer _timer;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();


    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;
    print("YESSSSSSUUUU its logged in $isLoggedIn");
    prefs.setBool(kChallengeRequirements, false);



    Provider.of<AiProvider>(context, listen: false).setTipStatus();

    setState(() {
      userLoggedIn = isLoggedIn ;
      print('The login status is $isLoggedIn');
      if(userLoggedIn == true){
        _timer = Timer(const Duration(milliseconds: 2000), () {
          showDialog(context: context, builder:
              ( context) {
            return const Center(child: CircularProgressIndicator());
          });
          deliveryStream();
          Navigator.pop(context);
          FirebaseServerFunctions().lastLoggedIn(auth.currentUser?.uid);
          Navigator.pop(context);
          // Navigator.pushNamed(context, ControlPage.id);
          Navigator.pushNamed(context, ResponsiveLayout.id);
          // Navigator.push(context,
          //
          //     MaterialPageRoute(builder: (context)=> ResponsiveLayout(mobileBody: ControlPage(), desktopBody: ControlPageWeb()))
          // );


        });

      }

      else{
        _timer = Timer(const Duration(milliseconds: 2000), () {
          Navigator.pop(context);
          // Navigator.pushNamed(context, WelcomePageMobile.id);
          // Navigator.push,
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> ResponsiveLayout(mobileBody: WelcomePageMobile(), desktopBody: WelcomePageWeb()))
          );
        //  ResponsiveLayout(mobileBody: WelcomePageMobile(), desktopBody: WelcomePageWeb());

        });


      }
    });
  }

  Future deliveryStream()async{

    var start = FirebaseFirestore.instance.collection('variables').snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((users) async {
        setState(() {
          Provider.of<AiProvider>(context, listen: false).
          setSubscriptionVariables(users["ugandaOneMonth"],
              users["ugandaOneYear"],
              users["internationalOneMonth"],
              users["internationalOneYear"],
              users["ugFirstAmount"],
              users["intFirstAmount"],
              users["customerCare"],
              users["tips"],
              users['notify'],
              users['tagline'],
              users['subscriptionButton'],
              users['trialTime'],
              users['iosUpload'],
              users['blackCountries'],
              users['prompt'],
              users['control'],
              users['favCountry'],
              users['videos'],
              users["goal"],
              "" );
        });
      });
    });
    CommonFunctions().userSubscription(context);


    return start;
  }

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
      backgroundColor: kPureWhiteColor,
      body:
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              kLargeHeightSpacing,
            Center(
              child:
                Container(
                    height: 100,
                    child: LoopingVideoContainer(videoPath: 'images/logo.webm',))

            ),

              // Text("Achieve your Goals", style: kNormalTextStyle,),
              Spacer(), 
              Image.asset(kSplashImage, fit: BoxFit.fitWidth,),
            ],
          ),
        )

    );
  }
}
