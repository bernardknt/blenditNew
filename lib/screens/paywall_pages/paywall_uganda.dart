import 'dart:math';

import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/screens/purchase_restored_page.dart';

import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

import '../../controllers/home_controller.dart';
import '../../models/ai_data.dart';

import '../make_payment_page.dart';
import '../nutri_mobile_money.dart';

class PaywallUgandaPage extends StatefulWidget {
  @override
  State<PaywallUgandaPage> createState() => _PaywallUgandaPageState();
}

class _PaywallUgandaPageState extends State<PaywallUgandaPage> {
  var textColor = kPureWhiteColor;

  var backgroundColor = kBlack;
  var customerID = "";
  List <Offering> products = [];
  List offerPrices = [];
  var offerings;
    int generateRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(100) + 1; // Generates a random integer between 0 and 99, and adds 1 to shift the range to 1 to 100
    return randomNumber;
  }

  bool isLoading = false;



  final HttpsCallable callableRevenueCatPayment = FirebaseFunctions.instance.httpsCallable(kRevenueCatPayment);


  void defaultInitialization () async {
    products = Provider.of<AiProvider>(context, listen: false).subscriptionProducts;
    offerPrices = [Provider.of<AiProvider>(context, listen: false).ugMonthly,Provider.of<AiProvider>(context, listen: false).ugYearly,];
    offerings = products.map((offer) => offer.availablePackages)
        .expand((pair) => pair)
        .toList();
    setState(() {
      print(offerings);

    });
  }

  Future transactionStream()async{


    var start = FirebaseFirestore.instance.collection('app_purchases').where('original_app_user_id', isEqualTo: customerID).where('type', isEqualTo: "PRODUCT_CHANGE").snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print("YES PLEASE: $customerID");
        setState(() {
          CoolAlert.show(
              lottieAsset: 'images/thankyou.json',
              context: context,
              type: CoolAlertType.success,
              text: "Your Payment was successfully Received and Updated",
              title: "Payment Made",
              confirmBtnText: 'Ok 👍',
              confirmBtnColor: kGreenThemeColor,
              backgroundColor: kBlueDarkColor,
              onConfirmBtnTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, ControlPage.id);

                setState(() {

                });
              }
          );
        });
      });
    });

    return start;
  }



  void fetchCustomerID() async {
    try {
      var purchaserInfo = await Purchases.getCustomerInfo();
      setState(() {
        customerID = purchaserInfo.originalAppUserId;
      });
    } on Error catch (e) {
      print('Error fetching customer ID: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    fetchCustomerID();



  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Subscribe', style: kNormalTextStyle.copyWith(color: textColor),),
        centerTitle: false,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        actions: [
          TextButton(onPressed: () async {
            try {
              showDialog(context: context, builder:
                  ( context) {
                return const Center(child: CircularProgressIndicator());
              });
              CustomerInfo customerInfo = await Purchases.restorePurchases();
              Navigator.pop(context);

              if(customerInfo.activeSubscriptions.toString() == "[]"  ){
                CoolAlert.show(

                  lottieAsset: 'images/goal.json',
                  context: context,
                  type: CoolAlertType.warning,
                  title: "No Subscription Found",
                );

              } else {
                CoolAlert.show(

                    lottieAsset: 'images/goal.json',
                    context: context,
                    type: CoolAlertType.success,
                    title: "Subscription Detected",
                    widget: Text("${customerInfo.activeSubscriptions[0]}"),
                    cancelBtnText: "Cancel",
                    showCancelBtn: true,
                    onCancelBtnTap: (){Navigator.pop(context);},
                    onConfirmBtnTap: (){

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RestorePurchasePage.id);
                    },
                    confirmBtnColor: kGreenThemeColor,
                    confirmBtnText: 'Activate'

                );
              }





              // ... check restored purchaserInfo to see if entitlement is now active
            } on PlatformException catch (e) {
              // Error restoring purchases
            }


          }, child: Text("Restore Purchase", style: kNormalTextStyle.copyWith(color: Colors.blue),)),

        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Achieve more with Nutri', textAlign: TextAlign.center,
                style:kHeading2TextStyleBold.copyWith(fontSize: 20, color: textColor),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 250,
                color: kBlack,
                child: Image.asset("images/video.gif"),
              ),
              kLargeHeightSpacing,

              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: offerings.length,
                itemBuilder: (context, index){
                  Package package = offerings[index];
                  return _buildPlanCard(context, package.storeProduct.title,
                      offerPrices[index],
                      package.storeProduct.description,
                      package.storeProduct.identifier,
                      package.storeProduct.subscriptionPeriod!,
                      package.storeProduct.priceString,
                  );
                },


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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){

                    CommonFunctions().goToLink("https://bit.ly/42Y0drx");
                  }, child: Text('Terms of Service', style: kNormalTextStyle.copyWith(color: Colors.blue, fontSize: 16),)),
                  TextButton(onPressed: (){

                    CommonFunctions().goToLink("https://bit.ly/3Bs6vUk");
                  }, child: Text('Privacy Policy', style: kNormalTextStyle.copyWith(color: Colors.blue, fontSize: 16),)),
                ],
              )

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
      String productStoreId,
      String duration,
      String revenuecatPrice,
      ) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Card(
            shadowColor: Colors.blue,
            color: kGreenThemeColor,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () async{
                String rcTransactionId = 'revenueCatNutri${uuid.v1().split("-")[0]}';
                Provider.of<AiProvider>(context, listen: false).setRevenueCatValue( customerID,productStoreId, revenuecatPrice, title, duration, rcTransactionId);

                final prefs = await SharedPreferences.getInstance();
                String transactionId = "momo${uuid.v1().split("-")[0]}${generateRandomNumber()}";
                prefs.setString(kBillValue, price);
                prefs.setString(kOrderId, transactionId);
                prefs.setString(kOrderReason, title);
                Navigator.pop(context);
                Navigator.pushNamed(context,NutriMobileMoneyPage.id);


              }
              ,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            title,
                            style: kNormalTextStyle.copyWith(color: textColor, fontSize: 16)
                        ),
                        kMediumWidthSpacing,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                "Ugx ${CommonFunctions().formatter.format(int.parse(price))}",
                                style: kNormalTextStyle.copyWith(color: textColor,fontSize: 18)
                            ),
                            // Text(
                            //   "$duration",
                            //   style: kNormalTextStyle.copyWith(color: textColor,fontSize: 18)
                            // ),
                          ],
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
          ),
          Positioned(
              top: 10,
              right: 10,
              child: Opacity(
                opacity: productStoreId == "nutri_69.99_annual_subscription" ? 1:0,
                child: Container(
                    decoration: BoxDecoration(
                        color: kAppPinkColor, borderRadius: BorderRadius.circular(10)

                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Best Value", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),),
                    )),
              ))
        ],
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

