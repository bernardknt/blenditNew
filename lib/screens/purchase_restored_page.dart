import 'dart:async';
import 'dart:math';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utilities/font_constants.dart';



class RestorePurchasePage extends StatefulWidget {
  static String id = 'purchase_restore_new';

  @override
  _RestorePurchasePageState createState() => _RestorePurchasePageState();
}

class _RestorePurchasePageState extends State<RestorePurchasePage> {



  late Timer _timer;
  var random = Random();
  var message  = ['Restoring your Purchase...'];


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    animationTimer();
  }

  final _random = new Random();
  animationTimer() {
    _timer = new Timer(const Duration(milliseconds: 10000), () {

      Navigator.pop(context);
      CommonFunctions().showNotification("Purchase Restored", "Your purchase has been restored to this device");
      // Navigator.pushNamed(context, MobileMoneyPage.id);
    });
  }

  Widget build(BuildContext context) {
    // var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Lottie.asset('images/loading.json', height: 200, width: 200, fit: BoxFit.contain ),
            kSmallHeightSpacing,
            Center(child: Text('${message[random.nextInt(message.length)]}' ,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 24),)),
            // kSmallHeightSpacing,
            // Lottie.asset('images/challenge.json', height: 50, width: 150,),

            // SizedBox(height: 10,),
            // Center(child: Text('You have Earned',textAlign: TextAlign.center, style: GoogleFonts.lato( fontSize: 30),)),
            //SizedBox(height: 10,),
            // Center(child: Text('${points.toString()} points',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),)),
          ],
        ),
      ),
    );
  }
}
