import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/screens/nutri_mobile_money.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaywallUgandaPage extends StatelessWidget {
  var textColor = kPureWhiteColor;
  var backgroundColor = kBlack;


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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Unlock the full power of Nutri!',
                style:kHeading2TextStyleBold.copyWith(fontSize: 20, color: textColor),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 350,
                color: kBlack,
                child: Lottie.asset("images/weight.json"),
              ),
              kLargeHeightSpacing,
              _buildPlanCard(
                context,
                'Monthly',
                '19900',
                'Unlock all features for 1 month',
                '567890'
              ),
              SizedBox(height: 16.0),
              _buildPlanCard(
                context,
                'Annual',
                '199000',
                'Save 20% by subscribing annually',
                '34567890'
              ),
              SizedBox(height: 32.0),
              Text(
                'Features',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor
                ),
              ),
              SizedBox(height: 8.0),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Personalized meal plans based on your goals',
              ),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Real-time AI recommendations to optimize your nutrition',
              ),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Access to a registered dietitian for support and guidance',
              ),
              _buildFeatureList(
                Icons.check_circle_sharp,
                'Integration with wearable devices to track your progress',
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

