
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../widgets/mm_payment_button_widget.dart';



class MakePaymentPage extends StatefulWidget {
  static String id = 'make_payment_page';

  @override
  _MakePaymentPageState createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {




  @override

  void initState() {
    // TODO: implement initState

    super.initState();

  }


  Widget build(BuildContext context) {
    // var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset('images/payment.json', height: 150, width: 150, fit: BoxFit.cover ),
              kSmallHeightSpacing,
              Center(child: Text("Payment in Progress..",textAlign: TextAlign.center, style: kNormalTextStyle)),
              kSmallHeightSpacing,
              Lottie.asset('images/loading.json', height: 50, width: 150,),
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              MobileMoneyPaymentButton(buttonColor: kGreenThemeColor, firstButtonFunction: (){Navigator.pushNamed(context, ControlPage.id); }, firstButtonText: 'Go Home',buttonTextColor: kPureWhiteColor, lineIconFirstButton: Icons.check_circle_outline,)

              // SizedBox(height: 10,),
              // Center(child: Text('You have Earned',textAlign: TextAlign.center, style: GoogleFonts.lato( fontSize: 30),)),
              //SizedBox(height: 10,),
              // Center(child: Text('${points.toString()} points',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),)),
            ],
          ),
        ),
      ),
    );
  }
}
