
import 'dart:io';

import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/new_logins/sign_in_phone.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:blendit_2022/screens/welcome_to_nutri_sign_up.dart';
import 'package:blendit_2022/services/google_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show Platform;


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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
      showDialog(context: context, builder:
          ( context) {
        return const Center(child: CircularProgressIndicator());
      });
      final UserCredential userCredential = await GoogleAuthService().signInWithGoogle();
      Navigator.pop(context) ;
      final User user = userCredential.user!;

      // Check if the user is new or existing and navigate accordingly
      var names = splitName(user.displayName!);
      if (userCredential.additionalUserInfo ?.isNewUser ?? false) {

        // prefs.setString(user.displayName!,kFullNameConstant);
        prefs.setString(kFirstNameConstant,names[0]);
        prefs.setString(kFullNameConstant, names.join(" "));
        // This sets the unique identifier which we use when sending messages and emails
        prefs.setString(kUniqueIdentifier, user.uid!);
        prefs.setString(kPhoneNumberConstant, "");
        prefs.setString(kEmailConstant, user.email!);
        prefs.setBool(kIsLoggedInConstant, true);

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> WelcomeToNutri())
        );
        CommonFunctions().uploadUserToken(token);

        // Navigate to the new user account page

      } else {
        final users = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (users.exists){
          // This condition sees whether the user is an old Blendit user then takes them through the re-authentication process again
          if (users['level'] == "Return") {
            prefs.setString(kFullNameConstant, users['lastName']);
            prefs.setString(kFirstNameConstant, users['firstName']);
            prefs.setString(kUniqueUserPhoneId, users['email']);
            prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
            prefs.setString(kUniqueIdentifier, user.uid);
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> WelcomeToNutri())
            );
            CommonFunctions().uploadUserToken(token);


          }
          // Here is the normal login process
          else {
            prefs.setBool(kNutriAi, true);
            prefs.setString(kUserPersonalPreferences, users['preferences'].join(", "));
            prefs.setString(kFullNameConstant, users['lastName']);
            prefs.setString(kFirstNameConstant, users['firstName']);
            prefs.setString(kUniqueUserPhoneId, users['email']);
            prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
            prefs.setString(kUniqueIdentifier, user.uid);
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
            // prefs.setString(kToken, token);

            // This Function uploads the user token to the server.
            CommonFunctions().uploadUserToken(token);
            //  MaterialPageRoute(builder: (context)=> QuizPageName());

            Navigator.pushNamed(context, ControlPage.id);
          }
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
      showDialog(context: context, builder: (BuildContext context){

        return CupertinoAlertDialog(
          title: const Text('Ooops Something Happened'),
          content: Text('There was an issue $e', style: kNormalTextStyle.copyWith(color: kBlack),),
          actions: [CupertinoDialogAction(isDestructiveAction: true,
              onPressed: (){
                // _btnController.reset();
                Navigator.pop(context);
              },
              child: const Text('Cancel'))],
        );
      });
      print(e);
    }
  }

  void handleAppleSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    AuthorizationResult authIOS = await TheAppleSignIn.performRequests([AppleIdRequest(
        requestedScopes: [Scope.email, Scope.fullName]
    )]);
    switch (authIOS.status) {
      case AuthorizationStatus.authorized:
        try {
          showDialog(context: context, builder:
              ( context) {
            return const Center(child: CircularProgressIndicator());
          });
          AppleIdCredential? appleCredentials = authIOS.credential;
          OAuthProvider oAuthProvider = OAuthProvider("apple.com");
          OAuthCredential oAuthCredential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleCredentials!.identityToken!),
            accessToken: String.fromCharCodes(appleCredentials!.authorizationCode!),
          );
          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
          Navigator.pop(context) ;
          print(userCredential.user);
          // userCredential.additionalUserInfo ?.isNewUser ?? false
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context)=> WelcomeToNutri())
          // );
          // if (userCredential.user != null )

          if(userCredential.additionalUserInfo ?.isNewUser ?? false)
          {
            String ? firstName;
            String ? lastName;
            String ? email;

            // if (appleCredentials.fullName != null) {
              firstName = appleCredentials.fullName!.givenName;
              lastName = appleCredentials.fullName!.familyName;
              email = appleCredentials.email;

            // }

            // var fullNames = userCredential.user?.displayName ?? "None";
            // var email = userCredential.user?.email ?? "None";
            // var names  = splitName( fullNames);


            prefs.setString(kFirstNameConstant, firstName ?? "");
            // prefs.setString(kFirstNameConstant,names[0]);
            prefs.setString(kFullNameConstant, "$firstName $lastName");
            // This sets the unique identifier which we use when sending messages and emails
            prefs.setString(kUniqueIdentifier, userCredential.user!.uid);
            prefs.setString(kPhoneNumberConstant, "");
            prefs.setString(kEmailConstant, appleCredentials.email!);
            prefs.setBool(kIsLoggedInConstant, true);

            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> WelcomeToNutri())
            );

          } else {
            final users = await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).get();
            if (users.exists){


              if (users['level'] == "Return") {
                prefs.setString(kFullNameConstant, users['lastName']);
                prefs.setString(kFirstNameConstant, users['firstName']);
                prefs.setString(kUniqueUserPhoneId, users['email']);
                prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
                prefs.setString(kUniqueIdentifier, userCredential.user!.uid);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> WelcomeToNutri())
                );
                CommonFunctions().uploadUserToken(token);


              }
              else {
                prefs.setBool(kNutriAi, true);
                prefs.setString(kUserPersonalPreferences, users['preferences'].join(", "));
                prefs.setString(kFullNameConstant, users['lastName']);
                prefs.setString(kFirstNameConstant, users['firstName']);
                prefs.setString(kUniqueUserPhoneId, users['email']);
                prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
                prefs.setString(kUniqueIdentifier, userCredential.user!.uid);
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
                // prefs.setString(kToken, token);

                // This Function uploads the user token to the server.
                CommonFunctions().uploadUserToken(token);
                //  MaterialPageRoute(builder: (context)=> QuizPageName());

                Navigator.pushNamed(context, ControlPage.id);

              }


            }
            // Navigate to the home page
            Get.snackbar('Welcome Back', '🙂',
                snackPosition: SnackPosition.TOP,
                backgroundColor: kCustomColor,
                colorText: kBlack,
                icon: Icon(Iconsax.smileys, color: kGreenThemeColor,));
          }

        } catch(e) {

        }

        break;
      case AuthorizationStatus.error:
        break;
      case AuthorizationStatus.cancelled:
        break;
      default: break;

    }
  }

  void defaultInitialization ()async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(kToken)!;
  }

  void initState() {
    // TODO: implement initState

    // _firebaseMessaging.getToken().then((value) => token = value!);
    super.initState();
    defaultInitialization(); 
  }
  var token = "";
  var countryName = '';
  var countryFlag = '';
  var countryCode = "+256";
  var backgroundColor = kGreenThemeColor;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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

                              handleAppleSignIn();


                              // final credential = await SignInWithApple.getAppleIDCredential(
                              //   scopes: [
                              //     AppleIDAuthorizationScopes.email,
                              //     AppleIDAuthorizationScopes.fullName,
                              //   ],
                              // );
                              //
                              //
                              // print("KYKYKYKKYKYKYKYKY ${credential.authorizationCode}");
                              // print("KYKYKYKKYKYKYKYKY ${credential.email}");
                              // print("KYKYKYKKYKYKYKYKY ${credential.givenName}");
                              //
                              // final signInWithAppleEndpoint = Uri(
                              //   scheme: 'https',
                              //   host:
                              //   // 'blend-it-8a622.firebaseapp.com'
                              //   'flutter-sign-in-with-apple-example.glitch.me',
                              //   // 'blend-it-8a622.firebaseapp.com',
                              //   path: '/sign_in_with_apple',
                              //   // '/__/auth/handler',
                              //   queryParameters: <String, String>{
                              //     'code': credential.authorizationCode,
                              //     if (credential.givenName != null)
                              //       'firstName': credential.givenName!,
                              //     if (credential.familyName != null)
                              //       'lastName': credential.familyName!,
                              //     'useBundleId': !kIsWeb && (Platform.isIOS || Platform.isMacOS) ? 'true' : 'false',
                              //     if (credential.state != null) 'state': credential.state!,
                              //   },
                              // );
                              //
                              // final session = await http.Client().post(
                              //   signInWithAppleEndpoint,
                              // );

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
