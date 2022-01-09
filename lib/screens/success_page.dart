import 'dart:async';
import 'dart:math';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/paymentMode_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class SuccessPage extends StatefulWidget {
  static String id = 'success_page';

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {


  @override
  late Timer _timer;
  @override
  var animations = ['images/chopping.json', 'images/watermelon.json', 'images/kiwi.json'];
  void initState() {
    // TODO: implement initState
    super.initState();
    animationTimer();
  }
  final _random = new Random();
  animationTimer() {
    _timer = new Timer(const Duration(milliseconds: 5000), () {
      Provider.of<BlenditData>(context, listen: false).clearBasket();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, PaymentMode.id);

    });
  }

  Widget build(BuildContext context) {
    var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('images/success.json', height: 300, width: 300, fit: BoxFit.cover ),
            SizedBox(height: 10,),
            Center(child: Text('Order Placed!',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 20),)),
            SizedBox(height: 10,),
            Center(child: Text('You have Earned',textAlign: TextAlign.center, style: GoogleFonts.lato( fontSize: 30),)),
            SizedBox(height: 10,),
            Center(child: Text('${points.toString()} points',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),)),
          ],
        ),
      ),
    );
  }
}
