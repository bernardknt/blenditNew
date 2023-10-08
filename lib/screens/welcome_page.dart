import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/screens/browse_store.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
import 'package:blendit_2022/screens/new_logins/sign_in_options.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/roundedButtons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  static String id = 'welcome_page';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void defaultsInitiation() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;

    setState(() {
      userLoggedIn = isLoggedIn;
      if (userLoggedIn == true) {
        // Navigator.pushNamed(context, ControlPage.id);
        Navigator.pushNamed(context, ResponsiveLayout.id);
      } else {
        prefs.setBool(kIsLoggedInConstant, false);
      }
    });
  }

  bool userLoggedIn = false;

  @override
  void initState() {
    super.initState();
    defaultsInitiation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(200, 200),
                  bottomRight: Radius.elliptical(100, -200)),
              child: Image.asset('images/childblendit.png'),
            ),

            //åSizedBox(height: 10,),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset('images/logofull.png', height: 45),
                    Container(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        '100 Ingredients in Your Pocket',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ),
                    // roundedButtons(
                    //   buttonColor: const Color(0xFFB65500),
                    //   buttonHeight: 35,
                    //   title: 'Register',
                    //   onPressedFunction: () {
                    //     //getLocation();
                    //     Navigator.pushNamed(context, RegisterPage.id);
                    //   },
                    // ),
                    roundedButtons(
                      buttonColor: const Color(0xFF019C29),
                      buttonHeight: 45,
                      title: 'Start Here',
                      onPressedFunction: () {
                        Navigator.pushNamed(context, SignInOptions.id);
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, BrowseStorePage.id);
                        },
                        child: const Text(
                          'Browse Store',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
