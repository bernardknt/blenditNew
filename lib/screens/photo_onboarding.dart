import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/designed_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/CommonFunctions.dart';
import '../models/ai_data.dart';
import 'delivery_page.dart';

class PhotoOnboarding extends StatefulWidget {
  @override
  State<PhotoOnboarding> createState() => _PhotoOnboardingState();
}

class _PhotoOnboardingState extends State<PhotoOnboarding> {
  var textColor = kBlack;

  var backgroundColor = kPureWhiteColor;

  bool isLoading = false;

  // Function to start the asynchronous process
  void _startAsyncProcess() async {
    print("THIS HAS STARTED");
    // Set loading state to true
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: Text('Subscribe', style: kNormalTextStyle.copyWith(color: textColor),),
      //   backgroundColor: backgroundColor,
      //   foregroundColor: textColor,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Center(child: Text("Snap 📸 and\n Achieve 💪", style: kHeading2TextStyleBold.copyWith(fontSize: 30),)),
              ),
              // const SizedBox(height: 6.0),
              Container(
                height: 250,
                width: double.infinity,
                color: kPureWhiteColor,
                child: Image.asset("images/whitefood.gif"),
              ),
              kLargeHeightSpacing,

              // ),
              const SizedBox(height: 8.0),
              _buildFeatureList(
                Icons.camera_alt,
                'Get nutritional value of your meal',
              ),
              _buildFeatureList(
                Icons.camera_alt,
                'Snap your fridge and get recipes',
              ),
              _buildFeatureList(
                Icons.camera_alt,
                'Share your Photo thoughts',
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DesignedButton(continueFunction: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool(kFirstTimePhoto, false);

                  Navigator.pop(context);
                  // CommonFunctions().pickImage(ImageSource.camera, 'pic${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context);
                  Get.snackbar('📸 📸 UNLOCKED', 'Start taking photos!',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: kBlueDarkColor,
                      colorText: kPureWhiteColor,
                      icon: Icon(Icons.check_circle, color: kGreenThemeColor,));


                }, title: "Continue"),
              )

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFeatureList(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
      child: Row(

        children: [
          Icon(
            icon,
            color: Colors.green,
          ),
          SizedBox(width: 8.0),
          Flexible(child: Text(text, overflow: TextOverflow.visible, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 17),)),
        ],
      ),
    );
  }
}

