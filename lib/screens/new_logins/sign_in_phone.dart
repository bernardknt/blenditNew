import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/new_logins/verify_phone.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';
import '../../utilities/icons_constants.dart';
import '../login_page.dart';
import '../onboarding_questions/quiz_page_name.dart';


class SignInPhone extends StatefulWidget {
  static String id = 'signin_phone_verification';




  @override
  State<SignInPhone> createState() => _SignInPhoneState();
}

class _SignInPhoneState extends State<SignInPhone> {
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+256";
    super.initState();
  }
  var countryName = '';
  var countryFlag = '';
  var countryCode = "+256";

  var phoneNumber = '';
  final formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenThemeColor,
        foregroundColor: kPureWhiteColor,
        title: Text("Phone Signin",style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'images/verify.json',
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Enter Your Phone Number",
                  style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We will text you an OTP to get you started",
                  style: kNormalTextStyle.copyWith(color: kFontGreyColor, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),

                Container(
                  height: 53,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CountryCodePicker(
                        onInit: (value){
                          countryCode = value!.dialCode!;
                          countryName = value!.name!;
                          countryFlag = value!.flagUri!;

                        },
                        onChanged: (value){
                          countryCode = value.dialCode!;
                          countryName = value.name!;
                          countryFlag = value.flagUri!;

                        },
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'UG',
                        favorite: const ['+254','+255',"US"],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 25, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child:

                          TextFormField(
                            validator: (value){
                              List letters = List<String>.generate(
                                  value!.length,
                                      (index) => value[index]);
                              print(letters);


                              if (value!=null && value.length > 10){
                                return 'Number is too long';
                              }else if (value == "") {
                                return 'Enter phone number';
                              } else if (letters[0] == '0'){
                                return 'Number cannot start with a 0';
                              } else if (value!= null && value.length < 9){
                                return 'Number short';

                              }
                              else {
                                return null;
                              }
                            },

                            onChanged: (value){
                              phoneNumber = value;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(

                                border: InputBorder.none,
                                hintText: "771234567",
                                hintStyle: kNormalTextStyle.copyWith(color: Colors.grey[500])

                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 43,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kGreenThemeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async{

                        final isValidForm = formKey.currentState!.validate();

                        if(isValidForm){
                          print('WALALALALLA $countryName');
                          var phoneNumberFull = '$countryCode$phoneNumber';
                          final prefs = await SharedPreferences.getInstance();
                          await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: phoneNumberFull,
                              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
                                await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
                              },
                              verificationFailed: (FirebaseAuthException error) {
                                print(error);
                                showDialog(context: context, builder: (BuildContext context){

                                  return CupertinoAlertDialog(
                                    title: const Text('Ooops Something Happened'),
                                    content: Text('There was an issue $error', style: kNormalTextStyle.copyWith(color: kBlack),),
                                    actions: [CupertinoDialogAction(isDestructiveAction: true,
                                        onPressed: (){
                                          // _btnController.reset();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'))],
                                  );
                                });
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {  },
                              codeSent: (String verificationId, int? forceResendingToken) {
                                Provider.of<BlenditData>(context, listen:false).setVerificationId(verificationId);
                              });
                          prefs.setInt(kNutriCount, 0);
                          prefs.setBool(kIsTutorial1Done, false);
                          prefs.setBool(kIsTutorial2Done, false);
                          prefs.setString(kUserCountryName, countryName);
                          prefs.setString(kUserCountryFlag, countryFlag);
                          prefs.setString(kUniqueUserPhoneId, phoneNumberFull);
                          prefs.setString(kPhoneNumberConstant, countryCode + phoneNumber);
                          prefs.setString(kUniqueIdentifier, countryCode + phoneNumber);
                          Navigator.pushNamed(context, VerifyPinPage.id);
                          // Navigator.pushNamed(context, QuizPageName.id);
                          // //MaterialPageRoute(builder: (context)=> QuizPageName());
                        }
                      },


                      child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                ),
                kLargeHeightSpacing,
                TextButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, LoginPage.id);

                    },
                    label:Text("Login with Email", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack),
                    ), icon: kIconScissorWhite

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
