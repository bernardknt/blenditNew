import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/home_controller.dart';
import '../../models/CommonFunctions.dart';
import '../../utilities/font_constants.dart';
import '../onboarding_questions/quiz_page_name.dart';



class VerifyPinPage extends StatefulWidget {
  static String id = 'VerificationPin';

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var code = '';
  var resendPin = false;
  var token = "phoneToken";
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();


  void subscribeToTopic(topicNumber)async{
    var topic = removeFirstCharacter(topicNumber);
    await FirebaseMessaging.instance.subscribeToTopic(topic).then((value) =>
        print('Succefully Subscribed')
    );
  }


  String removeFirstCharacter(String str) {
    if (str.length > 1) {
      String result = str.substring(1);
      return result;
    } else {
      print('Error: String is too short to remove first character.');
      return "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((value) => token = value!);

  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'images/loadingsms.json',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Enter Pin",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                onChanged: (value){
                  code = value;
                  print(value);

                },

                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child:
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: kGreenThemeColor,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10))),
                RoundedLoadingButton(
                    color: Colors.green,
                    // child:
                    onPressed: () async{
                      _btnController.start();
                      final prefs = await SharedPreferences.getInstance();
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Provider.of<BlenditData>(context, listen: false).phoneVerificationId, smsCode: code);
                        var user = await auth.signInWithCredential(credential);

                        if (user.additionalUserInfo ?.isNewUser ?? false){
                          print("HUuuuuUUUUUMUUUU user doesbt exist");
                          // prefs.setBool(kNutriAi, true);
                          // if (prefs.getString(kFullNameConstant) == '') {
                          prefs.setString(kUniqueIdentifier, auth.currentUser!.uid);
                          prefs.setStringList(kPointsList,[]);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> QuizPageName())
                          );

                          _btnController.reset();

                        }
                        else {


                          print("YESSSSSSUUUUU user exists");
                          final users = await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get();

                          prefs.setBool(kNutriAi, true);
                          prefs.setString(kUserPersonalPreferences, users['preferences'].join(", "));
                          prefs.setString(kFullNameConstant, users['lastName']);
                          prefs.setString(kFirstNameConstant, users['firstName']);
                          prefs.setString(kUniqueUserPhoneId, users['email']);
                          prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
                          prefs.setString(kUniqueIdentifier, auth.currentUser!.uid);
                          prefs.setString(kUserCountryName, users['country']);
                          prefs.setBool(kIsLoggedInConstant, true);
                          prefs.setString(kUserSex, users['sex']);
                          prefs.setString(kEmailConstant, users['email']);
                          prefs.setString(kUserVision, users['vision']);
                          prefs.setString(kGoalConstant, users['goal']);
                          prefs.setDouble(kUserWeight, users['weight']/1.0);
                          prefs.setInt(kUserHeight, users['height']);
                          prefs.setBool(kIsGoalSet,users['goalSet'] );
                          prefs.setStringList(kPointsList,users['chatPoints'].cast<String>());
                          prefs.setString(kUserBirthday, DateFormat('dd/MMM/yyyy ').format(users['dateOfBirth'].toDate()) );
                          prefs.setString(kToken, token);

                          // This Function uploads the user token to the server.
                          CommonFunctions().uploadUserToken(token);
                          //  MaterialPageRoute(builder: (context)=> QuizPageName());
                          //  subscribeToTopic(users['phoneNumber']);
                          Navigator.pushNamed(context, ControlPage.id);

                        }

                        prefs.setBool(kIsLoggedInConstant, true);
                        prefs.setBool(kIsFirstTimeUser, true);
                      }
                      catch (e)
                      {
                        print("WALALALALALLALA $e");
                        _btnController.reset();
                        print(Provider.of<BlenditData>(context, listen: false).phoneVerificationId);
                        showDialog(context: context, builder: (BuildContext context){

                          return CupertinoAlertDialog(
                            title: const Text('Oops Something went Wrong'),
                            content:
                            Text('Error message: $e'),
                            // Text('Error message: $e'),
                            actions: [CupertinoDialogAction(isDestructiveAction: true,
                                onPressed: (){
                                  // _btnController.reset();
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'))],
                          );
                        });
                      }


                      },
                    controller: _btnController,
                    child: Text("Verify Phone Number",style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)
                ),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: kNormalTextStyle.copyWith(color: kBlack),
                      ))
                ],
              ),
              resendPin!= false ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);

                      },

                        child: Text("Resend Pin", style: kNormalTextStyle.copyWith(color: kBlack),)),
                    const Icon(Icons.settings_backup_restore_rounded, color: kAppPinkColor,)
                  ],
                ),
              ):
              CircularCountDownTimer(isReverse: true, width: 70, height: 50, duration: 30,
                fillColor: kAppPinkColor, ringColor: kBlueDarkColorOld,onStart:(){
                  // Navigator.pushNamed(context, ControlPage.id);


                },onComplete: (){
                resendPin = true;
                setState(() {

                });

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
