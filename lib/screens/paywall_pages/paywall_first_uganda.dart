import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
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

class PaywallFirstUgandaPage extends StatelessWidget {
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
                '${Provider.of<AiProvider>(context, listen: false).userName} Enjoy free ${ Provider.of<AiProvider>(context, listen: false).trialTime} Day Trial, then Ugx ${Provider.of<AiProvider>(context,listen: false).ugTrial}/month!', textAlign: TextAlign.center,
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
              // _buildPlanCard(
              //   context,
              //   'Monthly',
              //   '19900',
              //   'Unlock all features for 1 month',
              //   '567890'
              // ),
              SizedBox(height: 30.0),
              _buildPlanCard(
                context,
                'Start Free ${ Provider.of<AiProvider>(context, listen: false).trialTime} Day Trial',
                // '199000',
                // 'Save 20% by subscribing annually',
                // '34567890'
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
      // prefs.setString(kBillValue, price);
          // prefs.setString(kOrderId, transactionId);
          // prefs.setString(kOrderReason, title);
          // String newAmount = prefs.getString(kBillValue) ?? '0';
          // String newPhoneNumber = removeCountryCode(prefs.getString(kPhoneNumberConstant) ?? '0') ;
          // String? newOrderId = prefs.getString(kOrderId);
          // String? newOrderReason = prefs.getString(kOrderReason);
          CommonFunctions().startTrialSubscription(context, Provider.of<AiProvider>(context, listen: false).trialTime );
          CommonFunctions().showNotification("Subscription Activated", "Nice, Time to get to work on achieving your goals");
          // Navigator.pushNamed(context, ControlPage.id);
          Navigator.pushNamed(context, ResponsiveLayout.id);


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
                  // kMediumWidthSpacing,
                  // Text(
                  //   "Ugx ${CommonFunctions().formatter.format(int.parse(price))}",
                  //   style: kNormalTextStyle.copyWith(color: textColor,fontSize: 16)
                  // ),
                  // SizedBox(height: 8.0),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.green.withOpacity(0.3),
                  //         blurRadius: 8.0,
                  //         offset: Offset(0, 4.0),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 24.0,
                  //       vertical: 12.0,
                  //     ),
                  //     child: Text(
                  //       'Subscribe',
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // SizedBox(height: 8.0),
              // Text(
              //   subtitle,
              //   style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 13),
              // ),
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

