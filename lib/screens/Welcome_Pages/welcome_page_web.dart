

import 'package:blendit_2022/screens/execution_pages/execution_page.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page0.dart';
import 'package:blendit_2022/screens/register_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/home_controller.dart';
import '../../models/CommonFunctions.dart';
import '../../models/responsive/responsive_layout.dart';
import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';
import '../../utilities/icons_constants.dart';
import '../../utilities/roundedButtons.dart';
import '../../widgets/photo_widget.dart';
import '../browse_store.dart';
import '../new_logins/sign_in_options.dart';



class WelcomePageWeb extends StatefulWidget {
  static String id = 'welcome_page_web';
  @override
  _WelcomePageWebState createState() => _WelcomePageWebState();
}
class _WelcomePageWebState extends State<WelcomePageWeb> {

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;
    _firebaseMessaging.getToken().then((value) =>
        prefs.setString(kToken, value!)
    );

    setState(() {
      userLoggedIn = isLoggedIn ;
      if(userLoggedIn == true){
        Navigator.pushNamed(context, ResponsiveLayout.id);
        // Navigator.push(context,
        //
        //     MaterialPageRoute(builder: (context)=> ResponsiveLayout(mobileBody: ControlPage(), desktopBody: HomePageWeb()))
        // );
      } else {
        prefs.setString(kPhoneNumberConstant, '');
        prefs.setString(kFullNameConstant, '');

      }



    });
  }
  bool userLoggedIn = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var urlImages = ["images/9.jpg","images/funky.png", "images/7.png"];// MHM17 trends];
  var heights = double.maxFinite;
  var token = "";

  int newDots = 0;
  var heading = ['A Special Blender that Works Like Magic', 'AI Powered Nutrition: For You', 'Take Photos Worth a Thousand Nutrients'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColor,
      floatingActionButton: FloatingActionButton.extended(

        backgroundColor: kAppPinkColor,
        onPressed: (){
          Navigator.pushNamed(context, SignInOptions.id);
        },
        // icon: const Icon(LineIcons.blender),
        label: Text('Start Here', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      body:
      SingleChildScrollView(
        child:
        Column(
          children: [
            Container(color:kPureWhiteColor,
              height:450,

              child: Stack(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: CarouselSlider.builder(
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
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 100,
                      left: 20,

                      child: Text(heading[newDots],textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                          shadows: [
                            Shadow(
                                color: kBlack,
                                offset: Offset.fromDirection(1.0),
                                blurRadius: 2


                            )
                          ]
                      ),
                      ),
                    ),
                    Positioned(
                        right: 20,
                        bottom: 50,
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
                        right: 20,
                        bottom: 100,
                        left: 20,
                        child: Center(
                            child:
                            Container()
                        )
                    ),
                    Positioned(
                        top: 10,
                        right: 20,
                        child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey.withOpacity(0.2), // Container background color
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // RoundedButton(text: 'Start here', color: Colors.green),
                          // kMediumWidthSpacing,

                          TextButton(

                              onPressed: (){Navigator.pushNamed(context, RegisterPage.id);}, child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kAppPinkColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Create an Account", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                              ))),
                          // kMediumWidthSpacing,
                          TextButton(

                              onPressed: (){Navigator.pushNamed(context, SignInOptions.id);}, child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kBlueDarkColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("  Login  ", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                              )))

                        ],
                      ),
                    ))


                  ]),
            ),
            kLargeHeightSpacing,
            kLargeHeightSpacing,
            Text("How it Works",style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 40, fontWeight: FontWeight.bold),),
            kLargeHeightSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LargeWidget(footer:"Need a natural solution for how you are feeling?", height: 200,width:200,onTapFunction: (){}, iconToUse: "sick.json",widgetColor: kAppPinkColor.withOpacity(0.3),fontSize: 18,iconColor: kPureWhiteColor,),
                kMediumWidthSpacing,
                Icon(Icons.arrow_forward, color: kPureWhiteColor,),
                kMediumWidthSpacing,
                LargeWidget(footer:"The blender will generate for you the right ingredients",height: 200,width:200,onTapFunction: (){}, iconToUse: "bilungo.json",widgetColor: kCustomColor.withOpacity(0.3),fontSize: 18,iconColor:kPureWhiteColor,),
                kMediumWidthSpacing,
                Icon(Icons.arrow_forward, color: kPureWhiteColor,),
                kMediumWidthSpacing,
                LargeWidget(footer:"Instantly order, see the recipe or watch and make it at home",height: 200,width:200,onTapFunction: (){}, iconToUse: "deliver.json",widgetColor: kPureWhiteColor.withOpacity(0.3),fontSize: 18,iconColor: kPureWhiteColor,),
              ],
            ),
            kLargeHeightSpacing,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedContainer(),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function function;

  RoundedButton({required this.text, required this.color, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){function;},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class RoundedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                color: kPureWhiteColor,
              ),
              child: Center(
                child:
                   Lottie.asset("images/stir.json")
                // Icon(
                //   Icons.coffee,
                //   size: 64,
                //   color: Colors.white,
                // ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                color: kGreenThemeColor,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Your Perfect Blend, Powered by AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: kPureWhiteColor
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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