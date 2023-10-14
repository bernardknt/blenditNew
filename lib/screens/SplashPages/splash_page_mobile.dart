import 'dart:async';
import 'dart:io';
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
import 'package:new_version/new_version.dart';
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

          deliveryStream();

          FirebaseServerFunctions().lastLoggedIn(auth.currentUser?.uid);
          _checkAppVersion();
          // Navigator.pop(context);
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

  _checkAppVersion() async {
    final newVersion = NewVersion(
      iOSId: "com.frutsexpress.blendit2022",
      androidId: "com.example.blendit_2022",
    );
    final status = await newVersion.getVersionStatus();
    var latest = status!.localVersion;
    print("WULULULULU: ${status.canUpdate}");
    if (status.canUpdate!) {

      // Show bottom sheet for update
      showModalBottomSheet(
        // isScrollControlled: true,
        context: context,

        builder: (context) => BottomSheet(
          onClosing: () {},
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New Version Available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "We have been hard at work to bring you an amazing new version of our app!\nGet version: ${status.storeVersion} From ${status.localVersion}",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kGreenThemeColor)),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      newVersion.launchAppStore("https://apps.apple.com/us/app/open-e/id6443682456");
                    } else if (Platform.isIOS) {
                      newVersion.launchAppStore("https://play.google.com/store/apps/details?id=com.kingdomfinanciers.stylestore.stylestore");
                    } else {
                      print("Unknown OS");
                    }
                    newVersion.launchAppStore("https://apps.apple.com/us/app/open-e/id6443682456");
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Text("Update", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    // defaultsInitiation();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // defaultsInitiation(); // Continue with the normal flow if no update is needed
    }
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
