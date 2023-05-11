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

import '../controllers/home_controller.dart';
import '../models/ai_data.dart';
import 'delivery_page.dart';
import 'make_payment_page.dart';

class PaywallInternationalPage extends StatefulWidget {
  @override
  State<PaywallInternationalPage> createState() => _PaywallInternationalPageState();
}

class _PaywallInternationalPageState extends State<PaywallInternationalPage> {
  var textColor = kPureWhiteColor;

  var backgroundColor = kBlack;
  var customerID = "";
  List <Offering> products = [];
  var offerings;

  bool isLoading = false;

  // Function to start the asynchronous process
  void _startAsyncProcess() async {
    print("THIS HAS STARTED");
    // Set loading state to true
    setState(() {
      isLoading = true;
    });
  }

  final HttpsCallable callableRevenueCatPayment = FirebaseFunctions.instance.httpsCallable(kRevenueCatPayment);
  int parseAmount(String amountString) {
    // Remove the dollar sign from the string
    String amountWithoutDollar = amountString.replaceAll('\$', '');

    // Parse the remaining string as a double
    double amount = double.tryParse(amountWithoutDollar) ?? 0.0;

    // Return the integer value of the amount
    return amount.toInt();
  }

  void defaultInitialization () async {
    products = Provider.of<AiProvider>(context, listen: false).subscriptionProducts;
    offerings = products.map((offer) => offer.availablePackages)
        .expand((pair) => pair)
        .toList();
    setState(() {
      print(offerings);

    });
  }

  Future transactionStream()async{
    print("WULULULULULU: $customerID");

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
                'Achieve more with Nutri', textAlign: TextAlign.center,
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
                // products[0],
                  "Monthly",
                '\$${Provider.of<AiProvider>(context, listen: false).intMonthly}',
                'Unlock all features for 1 month',
                "nutri_6.99_monthly",
                30,
                0
              ),
              const SizedBox(height: 16.0),
              _buildPlanCard(
                context,
                'Annual',
                '\$${Provider.of<AiProvider>(context, listen: false).intYearly}',
                'Save 20% by subscribing annually',
                "nutri_69.99_annual_subscription",
                365,
                1
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
      String productStoreId,
      int duration,
      double opacity,
      ) {

    return Stack(
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
              print(customerID);
              String transactionId = 'revenueCatNutri${uuid.v1().split("-")[0]}';
              final prefs = await SharedPreferences.getInstance();
              try{

                // _startAsyncProcess();
                showDialog(context: context, builder:
                    ( context) {
                  return const Center(child: CircularProgressIndicator());
                });
                 await Purchases.purchaseProduct(productStoreId);
                 var userInfo = await Purchases.getCustomerInfo();
                 // userInfo.
                Provider.of<AiProvider>(context, listen: false).setShowPaymentDialogue(true);
                Navigator.pushNamed(context, MakePaymentPage.id);
                transactionStream();
                // Navigator.pop(context);
                // Navigator.pop(context);
                await callableRevenueCatPayment.call(<String, dynamic>{
                  'id': productStoreId,
                  'amount': parseAmount(price),
                  'product': title,
                  'transId': transactionId,
                  'duration': duration,
                  'token': prefs.getString(kToken),
                  'uid' : prefs.getString(kUniqueIdentifier),
                  'name': prefs.getString(kFullNameConstant),
                  'revenueCatId': customerID,
                  // orderId
                }).then((value) => null);





                print("SUCCEESSSS");

                await Future.delayed(Duration(seconds: 2));
                // Set loading state to false after the process is complete
                setState(() {
                  isLoading = false;
                  print("THIS has Ended");
                });
              } catch(e){
                debugPrint("Failed to Purchase product $title, error: $e");
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
              opacity: opacity,
              child: Container(
                decoration: BoxDecoration(
                  color: kAppPinkColor, borderRadius: BorderRadius.circular(10)

                ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Best Value", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 13),),
                  )),
            ))
      ],
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

