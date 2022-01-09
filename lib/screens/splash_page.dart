import 'dart:async';
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/screens/welcome_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashPage extends StatefulWidget {
  static String id = 'splash_page';

  @override
  _SplashPageState createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  late Timer _timer;

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;

    setState(() {
      userLoggedIn = isLoggedIn ;
      print('The login status is $isLoggedIn');
      if(userLoggedIn == true){
        _timer = new Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushNamed(context, ControlPage.id);

        });

      }

      else{
        _timer = new Timer(const Duration(milliseconds: 1000), () {
          Navigator.pushNamed(context, WelcomePage.id);

        });

      }
    });
  }
  bool userLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        color: Colors.black,
        child: Center(child: Image.asset('images/blendgif.gif', height: 200,)),
      ),
    );
  }
}
