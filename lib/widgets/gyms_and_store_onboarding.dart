import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/designed_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GymsAndServiceProviderOnboarding extends StatefulWidget {
  @override
  State<GymsAndServiceProviderOnboarding> createState() => _GymsAndServiceProviderOnboardingState();
}

class _GymsAndServiceProviderOnboardingState extends State<GymsAndServiceProviderOnboarding> {
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
                child: Center(child: Text("Take your Goals to\nthe next Level 💪",textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 24),)),
              ),
              // const SizedBox(height: 6.0),
              Container(
                height: 250,
                width: double.infinity,
                color: kPureWhiteColor,
                child:
                // Image.asset("images/video.gif"),
                Image.asset("images/online.gif"),
              ),
              kLargeHeightSpacing,

              // ),
              const SizedBox(height: 8.0),
              _buildFeatureList(
                Icons.sports_gymnastics,
                'Take sessions with Instructors for every need',
              ),
              _buildFeatureList(
                Iconsax.alarm,
                'Become accountable and stay on track',
              ),
              _buildFeatureList(
                Icons.access_alarm,
                'Everything you need to achieve your goal',
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DesignedButton(continueFunction: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool(kIsFirstStoreVisit, false);

                  Navigator.pop(context);
                  // CommonFunctions().pickImage(ImageSource.camera, 'pic${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context);



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

