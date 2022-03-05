
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/screens/browse_store.dart';
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/register_page.dart';
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

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;

    setState(() {
      userLoggedIn = isLoggedIn ;
      if(userLoggedIn == true){

        Navigator.pushNamed(context, ControlPage.id);
      }else {
        prefs.setBool(kIsLoggedInConstant, false);
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
      backgroundColor: Colors.black,
      //backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Container(
              //color: Colors.red,
              child:
              ClipRRect(

                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 200),
                    bottomRight: Radius.elliptical(100, -200)),
                child: Image.asset('images/blendit.png'),)
              ,
            ),

              //åSizedBox(height: 10,),
              Padding(padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Image.asset('images/blenditcolor.png', height: 45),


                      Container(
                        padding: EdgeInsets.all(30),
                          child: Text('100 Ingredients in Your Pocket', style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white),
                          ),),

                      roundedButtons(buttonColor: Color(0xFFf19c93),
                        buttonHeight: 35,
                        title: 'Register',
                        onPressedFunction: () {
                          //getLocation();
                         Navigator.pushNamed(context, RegisterPage.id);
                        },
                      ),
                      roundedButtons(buttonColor: Color(0xFF91b2b3),
                        buttonHeight: 35,
                        title: 'Login',
                        onPressedFunction: () {
                          Navigator.pushNamed(context,LoginPage.id);
                        },
                      ),
                      SizedBox(height: 30,), 
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, BrowseStorePage.id);
                          },
                          child: Text('Browse Store', style: TextStyle(color: Colors.white),))
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

