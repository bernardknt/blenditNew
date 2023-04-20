import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/ai_data.dart';

class PaywallInternationalPage extends StatefulWidget {
  @override
  State<PaywallInternationalPage> createState() => _PaywallInternationalPageState();
}

class _PaywallInternationalPageState extends State<PaywallInternationalPage> {
  var textColor = kPureWhiteColor;

  var backgroundColor = kBlack;

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
              const SizedBox(height: 16.0),
              Container(
                height: 350,
                color: kBlack,
                child: Image.asset("images/video.gif"),
              ),
              kLargeHeightSpacing,
              isLoading == false? Container(): const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator()),
              _buildPlanCard(
                context,
                'Monthly',
                '\$${Provider.of<AiProvider>(context, listen: false).intMonthly}',
                'Unlock all features for 1 month',
                "nutri_6.99_monthly"
              ),
              const SizedBox(height: 16.0),
              _buildPlanCard(
                context,
                'Annual',
                '\$${Provider.of<AiProvider>(context, listen: false).intYearly}',
                'Save 20% by subscribing annually',
                "nutri_69.99_annual_subscription"
              ),
              const SizedBox(height: 32.0),
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
      String productStoreId
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
          try{

            _startAsyncProcess();
            await Purchases.purchaseProduct(productStoreId);
            // await Future.delayed(Duration(seconds: 2));
            // Set loading state to false after the process is complete
            setState(() {
              isLoading = false;
              print("THIS HAS Ended");
            });
          } catch(e){
            debugPrint("Failed to Purchase product $title");
          }
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
                    price,
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

