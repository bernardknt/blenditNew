


import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/screens/SplashPages/splash_page_mobile.dart';
import 'package:blendit_2022/screens/SplashPages/splash_page_web.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static String id = 'splash_page_new';
  const SplashPage({super.key});



  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobileBody: SplashPageMobile(), desktopBody: SplashPageWeb());
  }
}
