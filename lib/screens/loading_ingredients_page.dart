import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'checkout_page.dart';


class LoadingIngredientsPage extends StatefulWidget {
  static String id = 'loading_ingredients';

  @override
  _LoadingIngredientsPageState createState() => _LoadingIngredientsPageState();
}

class _LoadingIngredientsPageState extends State<LoadingIngredientsPage> {


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
    _timer = new Timer(const Duration(milliseconds: 3500), () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, CheckoutPage.id);

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('images/blenderOn.json', height: 300, width: 300, fit: BoxFit.cover ),
              SizedBox(height: 10,),
              // RichText(text: TextSpan(text: ('Warming Blender'),
              //     //style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
              //     style: GoogleFonts.lato(fontSize: 16.8),
              //     children: [
              //       TextSpan(text: '\n..Setting up Ingredients', style: GoogleFonts.raviPrakash(), )
              //     ]
              // ),),

              Text('Getting ready', style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 20),),
              //SizedBox(height: 10,),
              //Text('Setting Ingredients..', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
            ],
          ),

        ),
      ),
    );
  }
}
