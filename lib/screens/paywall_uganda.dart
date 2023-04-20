import 'dart:math';

import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/nutri_mobile_money.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaywallUgandaPage extends StatelessWidget {
  var textColor = kPureWhiteColor;
  var backgroundColor = kBlack;

  int generateRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(100) + 1; // Generates a random integer between 0 and 99, and adds 1 to shift the range to 1 to 100
    return randomNumber;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Subscribe', style: kNormalTextStyle.copyWith(color: textColor),),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Unlock the full power of Nutri!',
                style:kHeading2TextStyleBold.copyWith(fontSize: 20, color: textColor),
              ),
              const SizedBox (height: 16.0),
              Container(
                height: 350,
                color: kBlack,
                child: Image.asset("images/video.gif"),
              ),
              kLargeHeightSpacing,
              _buildPlanCard(
                context,
                'Monthly',
                Provider.of<AiProvider>(context, listen: false).ugMonthly,
                'Commit to chasing your goal for 1 month',
                  "${uuid.v1().split("-")[0]}${generateRandomNumber()}"
              ),
              const SizedBox (height: 16.0),
              _buildPlanCard(
                context,
                'Annual',
                  Provider.of<AiProvider>(context, listen: false).ugYearly,
                'Save 20% by subscribing annually',
                  "${uuid.v1().split("-")[0]}${generateRandomNumber()}"
              ),
              const SizedBox (height: 32.0),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      BuildContext context,
      String title,
      String price,
      String subtitle,
      String transactionId,
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
          prefs.setString(kBillValue, price);
          prefs.setString(kOrderId, transactionId);
          prefs.setString(kOrderReason, title);
          // String newAmount = prefs.getString(kBillValue) ?? '0';
          // String newPhoneNumber = removeCountryCode(prefs.getString(kPhoneNumberConstant) ?? '0') ;
          // String? newOrderId = prefs.getString(kOrderId);
          // String? newOrderReason = prefs.getString(kOrderReason);
          Navigator.pop(context);
          Navigator.pushNamed(context,NutriMobileMoneyPage.id);


        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: kNormalTextStyle.copyWith(color: textColor, fontSize: 16)
                  ),
                  kMediumWidthSpacing,
                  Text(
                    "Ugx ${CommonFunctions().formatter.format(int.parse(price))}",
                    style: kNormalTextStyle.copyWith(color: textColor,fontSize: 16)
                  ),

                ],
              ),
              SizedBox(height: 8.0),
              Text(
                subtitle,
                style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 13),
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

