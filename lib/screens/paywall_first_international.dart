import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/loading_challenge.dart';
import 'package:blendit_2022/screens/loading_free_trial.dart';
import 'package:blendit_2022/screens/nutri_mobile_money.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaywallFirstInternationalPage extends StatelessWidget {
  var textColor = kPureWhiteColor;
  var backgroundColor = kBlack;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Start Trial', style: kNormalTextStyle.copyWith(color: textColor),),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 250,
                color: kBlack,
                child: Image.asset("images/video.gif"),
              ),
              kLargeHeightSpacing,
              Text(
                '${Provider.of<AiProvider>(context, listen: false).userName} Enjoy free ${ Provider.of<AiProvider>(context, listen: false).trialTime} Day Trial, then USD ${Provider.of<AiProvider>(context,listen: false).intTrial} /month!', textAlign: TextAlign.center,
                style:kHeading2TextStyleBold.copyWith(fontSize: 20, color: textColor),
              ),
              kLargeHeightSpacing,
              Text(
                'Features',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor
                ),
              ),
              const SizedBox(height: 8.0),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Personalized accountability partner to achieve your goals',
              ),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'See changes in 4 weeks of consistent use',
              ),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Take a photo of any meal and know if its good for you.',
              ),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Challenges to test and help you achieve more.',
              ),

              SizedBox(height: 30.0),
              _buildPlanCard(
                context,
                'Start Free ${ Provider.of<AiProvider>(context, listen: false).trialTime} Day Trial',

              ),
              // SizedBox(height: 32.0),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      BuildContext context,
      String title,
      // String price,
      // String subtitle,
      // String transactionId,
      // String subtitle,
      ) {

    return Card(
      shadowColor: kGreenThemeColor,
      color: Colors.blue,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () async{
          final prefs = await SharedPreferences.getInstance();
          CommonFunctions().startTrialSubscription(context, Provider.of<AiProvider>(context, listen: false).trialTime);
          CommonFunctions().showNotification("Subscription Activated", "Nice, Time to get to work on achieving your goals");
          Navigator.pushNamed(context, ControlPage.id);


          Navigator.push(context,

              MaterialPageRoute(builder: (context)=> LoadingFreeTrialPage())
          );
          // Navigator.pushNamed(context,NutriMobileMoneyPage.id);


        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title, textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: textColor, fontSize: 16)
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.green,
        ),
        SizedBox(width: 8.0),
        Flexible(child: Text(text, overflow: TextOverflow.visible, style: kNormalTextStyle.copyWith(color: kBackgroundGreyColor),)),
      ],
    );
  }
}

