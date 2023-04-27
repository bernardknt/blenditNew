
import 'dart:io';

import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/new_logins/sign_in_phone.dart';
import 'package:intl/intl.dart';
import 'package:blendit_2022/screens/welcome_to_nutri_sign_up.dart';
import 'package:blendit_2022/services/google_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show Platform;


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../controllers/home_controller.dart';
import '../../models/CommonFunctions.dart';
import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';




class SignInOptions extends StatefulWidget {
  static String id = 'signin_phone_option';




  @override
  State<SignInOptions> createState() => _SignInOptionsState();
}

class _SignInOptionsState extends State<SignInOptions> {
  TextEditingController countryController = TextEditingController();

  @override

  String capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1).toLowerCase();
  }

  List<String> splitName(String fullName) {
    final List<String> names = fullName.trim().split(' ');

    if (names.length < 2) {
      throw ArgumentError('Full name must have at least two names separated by a space');
    }

    final String firstName = capitalize(names.first);
    final String lastName = capitalize(names.last);

    return [firstName, lastName];
  }


  Future<void> handleGoogleSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final UserCredential userCredential = await GoogleAuthService().signInWithGoogle();
      final User user = userCredential.user!;

      // Check if the user is new or existing and navigate accordingly
      var names = splitName(user.displayName!);
      if (userCredential.additionalUserInfo ?.isNewUser ?? false) {

        // prefs.setString(user.displayName!,kFullNameConstant);
        prefs.setString(kFirstNameConstant,names[0]);
        prefs.setString(kFullNameConstant, names.join(" "));
        // This sets the unique identifier which we use when sending messages and emails
        prefs.setString(kUniqueIdentifier, user.email!);
        prefs.setString(kPhoneNumberConstant, "");
        prefs.setString(kEmailConstant, user.email!);
        prefs.setBool(kIsLoggedInConstant, true);

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> WelcomeToNutri())
        );

        // Navigate to the new user account page
        // Get.snackbar('USER LOGGED ${user.displayName}!', 'On we go💪',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: kCustomColor,
        //     colorText: kBlack,
        //     icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
        // uploadActiveChallengePosition(challengeId, activeChallengeIndex + 1);
      } else {
        final users = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (users.exists){

          prefs.setBool(kNutriAi, true);
          prefs.setString(kUserPersonalPreferences, users['preferences'].join(", "));
          prefs.setString(kFullNameConstant, users['lastName']);
          prefs.setString(kFirstNameConstant, users['firstName']);
          prefs.setString(kUniqueUserPhoneId, users['email']);
          prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
          prefs.setString(kUniqueIdentifier, users['email']);
          prefs.setString(kUserCountryName, users['country']);
          prefs.setBool(kIsLoggedInConstant, true);
          prefs.setString(kUserSex, users['sex']);
          prefs.setString(kEmailConstant, users['email']);
          prefs.setString(kUserVision, users['vision']);
          prefs.setString(kGoalConstant, users['goal']);
          prefs.setDouble(kUserWeight, users['weight']/1.0);
          prefs.setInt(kUserHeight, users['height']);
          prefs.setBool(kIsGoalSet,users['goalSet'] );
          prefs.setString(kUserBirthday, DateFormat('dd/MMM/yyyy ').format(users['dateOfBirth'].toDate()) );
          prefs.setString(kToken, token);

          // This Function uploads the user token to the server.
          CommonFunctions().uploadUserToken(token);
          //  MaterialPageRoute(builder: (context)=> QuizPageName());

          Navigator.pushNamed(context, ControlPage.id);
        }
        // Navigate to the home page
        Get.snackbar('Welcome Back ${names[0]}', '🙂',
            snackPosition: SnackPosition.TOP,
            backgroundColor: kCustomColor,
            colorText: kBlack,
            icon: Icon(Iconsax.smileys, color: kGreenThemeColor,));
      }
    } catch (e) {
      // Handle sign-in errors
      print(e);
    }
  }

  void initState() {
    // TODO: implement initState
    _firebaseMessaging.getToken().then((value) => token = value!);
    super.initState();
  }
  var token = "";
  var countryName = '';
  var countryFlag = '';
  var countryCode = "+256";
  var backgroundColor = kGreenThemeColor;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var phoneNumber = '';
  final formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: kPureWhiteColor,
        title: Text("",style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),

      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child:     Opacity(
                    opacity: 0.2,
                    child: Container(
                      // padding: EdgeInsets.all(40),
                      color: kGreenThemeColor,
                      child: Column(
                        children: [
                          // Spacer(),
                          Image.asset('images/nutri.png', fit: BoxFit.fitWidth, height: 400,),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie.asset(
                    //   'images/morning.json',
                    //   width: 250,
                    //   height: 200,
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("NUTRI",

                            // style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 40)
                          style: GoogleFonts.sourceSansPro(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: kBlack,
                                    offset: Offset.fromDirection(1.0),
                                    blurRadius: 2


                                )
                              ]
                          ),

                        ),
                        Lottie.asset(
                          'images/morning.json',
                          width: 70,
                          height: 70,
                        ),
                      ],
                    ),
                    Text(Provider.of<AiProvider>(context, listen: false).tagline,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 17)),
                    SizedBox(
                      height: 25,
                    ),
                    kLargeHeightSpacing,
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 43,
                        child:
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPureWhiteColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async{
                              // GoogleAuthService().signInWithGoogle();
                              handleGoogleSignIn();

                            },


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Sign In with Google", style: kNormalTextStyle.copyWith(color: kBlack),),
                                kSmallWidthSpacing,
                                Icon(Iconsax.chrome, color: kBlack,),
                              ],
                            )),

                      ),
                    ),

                    kLargeHeightSpacing,
                    kLargeHeightSpacing,
                    kLargeHeightSpacing,
                    kLargeHeightSpacing,
                    kLargeHeightSpacing,
                    kLargeHeightSpacing,

                    SizedBox(
                      height: 20,
                    ),
                    Text("Or Continue with", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),

                    kLargeHeightSpacing,
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child:
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kCustomColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async{
                              Navigator.pushNamed(context, SignInPhone.id);

                            },


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Continue with Mobile", style: kNormalTextStyle.copyWith(color: kBlack),),
                                kSmallWidthSpacing,
                                Icon(Iconsax.mobile, color: kBlack,),
                              ],
                            )),
                      ),

                    ),
                    kLargeHeightSpacing,
                    Platform.isIOS ?
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child:
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kBlack,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              final credential = await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                              );


                              print("KYKYKYKKYKYKYKYKY ${credential.authorizationCode}");
                              print("KYKYKYKKYKYKYKYKY ${credential.email}");
                              print("KYKYKYKKYKYKYKYKY ${credential.givenName}");

                              final signInWithAppleEndpoint = Uri(
                                scheme: 'https',
                                host:
                                // 'blend-it-8a622.firebaseapp.com'
                                'flutter-sign-in-with-apple-example.glitch.me',
                                // 'blend-it-8a622.firebaseapp.com',
                                path: '/sign_in_with_apple',
                                // '/__/auth/handler',
                                queryParameters: <String, String>{
                                  'code': credential.authorizationCode,
                                  if (credential.givenName != null)
                                    'firstName': credential.givenName!,
                                  if (credential.familyName != null)
                                    'lastName': credential.familyName!,
                                  'useBundleId': !kIsWeb && (Platform.isIOS || Platform.isMacOS) ? 'true' : 'false',
                                  if (credential.state != null) 'state': credential.state!,
                                },
                              );

                              final session = await http.Client().post(
                                signInWithAppleEndpoint,
                              );

                              // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                              // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                            },


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Continue with Apple", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                                kSmallWidthSpacing,
                                Icon(Icons.apple),
                              ],
                            )),
                      ),

                    ): Container(),
            // SignInWithAppleButton(
            //   onPressed: () async {
            //     final credential = await SignInWithApple.getAppleIDCredential(
            //       scopes: [
            //         AppleIDAuthorizationScopes.email,
            //         AppleIDAuthorizationScopes.fullName,
            //       ],
            //     );
            //
            //     print(credential);
            //
            //     // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
            //     // after they have been validated with Apple (see `Integration` section for more information on how to do this)
            //   },
            // )
            //         TextButton.icon(
            //             onPressed: (){
            //               Navigator.pushNamed(context, LoginPage.id);
            //
            //             },
            //             label:Text("Login with Email", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack),
            //             ), icon: kIconScissorWhite
            //
            //         )
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
