

import 'package:blendit_2022/screens/onboarding_questions/quiz_page0.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/home_controller.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../utilities/icons_constants.dart';
import '../utilities/roundedButtons.dart';
import 'browse_store.dart';
import 'new_logins/signin_phone.dart';



class WelcomePageNew extends StatefulWidget {
  static String id = 'welcome_page_new';
  @override
  _WelcomePageNewState createState() => _WelcomePageNewState();
}
class _WelcomePageNewState extends State<WelcomePageNew> {

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;

    setState(() {
      userLoggedIn = isLoggedIn ;
      if(userLoggedIn == true){
        Navigator.pushNamed(context, ControlPage.id);
      } else {
        prefs.setString(kPhoneNumberConstant, '');
        prefs.setString(kFullNameConstant, '');

      }

    });
  }
  bool userLoggedIn = false;
  var urlImages = ["images/page1.png", "images/page2.png","images/page3.png"];// MHM17 trends];
  var heights = double.maxFinite;
  int newDots = 0;
  var heading = ['Your Personal Nutritionist 24/7', 'Smash Your Goals, Challenge Yourself', 'Goodbye Frustration, Hello Consistency'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Container(color: kBlueDarkColor,


        // decoration: const BoxDecoration(
        // image:
        // DecorationImage(
        //   colorFilter: ColorFilter.mode(kBlueDarkColorOld, BlendMode.lighten),
        // image: AssetImage("images/braids.jpg"), // MHM17 trends
        //
        //   fit: BoxFit.cover,
        // ),
        // ),
        child: Stack(
            children: [

              CarouselSlider.builder(
                itemCount: urlImages.length,
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 8),
                  onPageChanged: (index, reason){
                    setState(()=>
                    newDots = index
                    );
                  },
                  viewportFraction: 2,
                  enableInfiniteScroll: true,

                  autoPlayAnimationDuration: Duration(seconds: 2),
                  height: heights,

                ),
                itemBuilder: (context, index, readIndex){
                  final urlImage = urlImages[index];
                  return BuildImageNew(urlImage, index);
                },
              ),
              Positioned(
                right: 20,
                bottom: 300,
                left: 20,

                child: Text(heading[newDots],textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                    shadows: [
                      Shadow(
                          color: kBlack,
                          offset: Offset.fromDirection(1.0),
                          blurRadius: 2


                      )
                    ]
                ),),
              ),
              Positioned(
                  right: 20,
                  bottom: 200,
                  left: 20,
                  child: Center(
                      child:
                      AnimatedSmoothIndicator(
                          effect: const JumpingDotEffect(
                              activeDotColor: kAppPinkColor,
                              dotHeight: 10,
                              dotWidth: 10,
                              dotColor: Colors.white
                          ),
                          activeIndex: newDots, count: urlImages.length)
                  )
              ),
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [


                    //åSizedBox(height: 10,),
                    Padding(padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),
                            // Text('Your Style Booked in Minutes',textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                            //     shadows: [
                            //       Shadow(
                            //         color: kBlack,
                            //         offset: Offset.fromDirection(1.0),
                            //         blurRadius: 2
                            //
                            //
                            //     )
                            //     ]
                            // ),),

                            kLargeHeightSpacing,
                            roundedButtons(
                              buttonColor: const Color(0xFF019C29),
                              buttonHeight: 45,
                              title: 'Start Here',
                              onPressedFunction: () {
                               //  Navigator.pushNamed(context, SignInPhone.id);
                                Navigator.pushNamed(context, QuizPage0.id);
                              },
                            ),
                            // Row(
                            //     children: [
                            //       Expanded(
                            //         // flex: 3,
                            //         child: TextButton.icon(onPressed: ()async{
                            //
                            //
                            //          // Navigator.pushNamed(context, SignUpPhone.id);
                            //           // Navigator.pushNamed(context, RegisterPage.id);
                            //
                            //
                            //         },
                            //           style: TextButton.styleFrom(
                            //             //elevation: ,
                            //               shadowColor: kBlueDarkColorOld,
                            //               onSurface: kBlueDarkColorOld,
                            //               surfaceTintColor: kBlueDarkColorOld,
                            //               fixedSize: Size(double.maxFinite, 45),
                            //               shape: RoundedRectangleBorder(
                            //                   borderRadius: BorderRadius.circular(10)
                            //               ),
                            //               backgroundColor: kAppPinkColor
                            //           ),icon: kIconStarWhite,
                            //           label: Text('Register', style: const TextStyle(fontWeight: FontWeight.bold,
                            //               color:Colors.white), ), ),
                            //       ),
                            //
                            //       SizedBox(width: 5,),
                            //       Expanded(
                            //         // flex: 3,
                            //         child: TextButton.icon(onPressed: ()async{
                            //          // Navigator.pushNamed(context,SignInPhone.id);
                            //
                            //
                            //         },
                            //           style: TextButton.styleFrom(
                            //             //elevation: ,
                            //               shadowColor: kBlueDarkColorOld,
                            //               onSurface: kBlueDarkColorOld,
                            //               surfaceTintColor: kBlueDarkColorOld,
                            //               fixedSize: Size(double.maxFinite, 45),
                            //               shape: RoundedRectangleBorder(
                            //                   borderRadius: BorderRadius.circular(10)
                            //               ),
                            //               backgroundColor: kBlueDarkColorOld
                            //           ),icon: kIconScissorWhite,
                            //           label: Text('Sign In', style: const TextStyle(fontWeight: FontWeight.bold,
                            //               color: Colors.white), ), ),
                            //       ),
                            //
                            //     ]),
                            // TextButton.icon(
                            //     onPressed: (){
                            //       // showModalBottomSheet(
                            //       //     isScrollControlled: true,
                            //       //
                            //       //     context: context,
                            //       //     builder: (context) {
                            //       //       return Container(color: kBackgroundGreyColor, height: 600,
                            //       //         child: HomePage(),
                            //       //       );
                            //       //     });
                            //       Navigator.pushNamed(context, BrowseStorePage.id);
                            //
                            //     },
                            //     label:const Text("Browse Store", style: kNormalTextStyleWhiteButtons,
                            //     ), icon: Icon(LineIcons.dumbbell, color: Colors.white,)),



                          ],
                        )
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}

Widget BuildImageNew (String urlImage, int index) => Container(
  margin: EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
    // color: Colors.grey,

      image: DecorationImage(
        image:
        // FadeInImage(placeholder: 'images/shimmer.gif', image: urlImage,),
        AssetImage(urlImage),
        fit: BoxFit.cover,

      )
  ),
);