
import 'package:blendit_2022/utilities/input_widet_2.dart';
import 'package:blendit_2022/widgets/designed_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';






class EditProfilePage extends StatefulWidget {
  static String id = 'edit_page';
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();


  @override

  String email= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String bloodPressure = '';
  String repeatPassword = '';
  String fullName = 'Kkkkkk';
  String firstName = '';
  String phoneNumber = '';
  String kinNumber = '';
  String idNumber = '';
  String birth = '';
  String allergies = '';
  String birthday = '';
  DateTime birthdayDate = DateTime.now();
  int height = 0;
  double weight = 0;
  double bmi = 0;

  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  late String countryCode;
  String token = '';
  final formKey = GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> uploadUserData() async {

    final auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          // 'firstName': prefs.getString(kFirstNameConstant),
          // 'dateOfBirth': prefs.getString(kUserBirthday),
          'lastName': prefs.getString(kFullNameConstant),
          'weight': prefs.getDouble(kUserWeight),
          'height': prefs.getInt(kUserHeight),
          'sex': prefs.getString(kUserSex),
          'phoneNumber': prefs.getString(kPhoneNumberConstant),
          'email': prefs.getString(kEmailConstant),
        });

   Get.snackbar('Success', 'Profile Updated');
    // Navigator.pushNamed(context, FormsPageCurrent.id);
  }

  void defaultInitialisation() async{
    final prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString(kFullNameConstant)!;
    email = prefs.getString(kEmailConstant)?? "";
    phoneNumber = prefs.getString(kPhoneNumberConstant)!;
    weight = prefs.getDouble(kUserWeight)!;
    height = prefs.getInt(kUserHeight)!;
    birth = prefs.getString(kUserBirthday)??" ";



    setState(() {
      bmi = ((weight)/ ((height/100)*(height/100))).roundToDouble();

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appValuesStream();
    // deliveryStream();
    defaultInitialisation();

    // deliveryStream();
  }






  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: kPureWhiteColor, //change your color here
        ),
        title: const Center(child: Text('Edit Your Information', style: kNormalTextStyleWhiteButtons,)),
        backgroundColor: kGreenThemeColor,
        automaticallyImplyLeading: true,
      ),
      body: Form(
        key: formKey,

        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 0),

          child: SingleChildScrollView(
            child:
            SizedBox(
              height: 600,

              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center(child: Image.asset('images/logo.png',height: 110,)),
                    Opacity(
                        opacity: changeInvalidMessageOpacity,
                        child: Text(invalidMessageDisplay, style: TextStyle(color:Colors.red , fontSize: 12),)),
                    InputFieldWidgetEditInfo(readOnlyVariable: false, controller: fullName, labelText:' Full Names' ,hintText: 'Fred Okiror', keyboardType: TextInputType.text, onTypingFunction: (value){
                      fullName = value;
                      firstName = fullName.split(" ")[0]; // Gets the first name in the 0 positiion from the full names
                    }, onFinishedTypingFunction: () {  },),
                    InputFieldWidgetEditInfo(labelText: ' Mobile Number (+2567xxxxxx)',readOnlyVariable: true,  controller: phoneNumber,hintText: '+25677100100', keyboardType: TextInputType.text,

                      onTypingFunction: (value){
                        // setState(() {
                        if (value.split('')[0] == '7'){
                          invalidMessageDisplay = 'Incomplete Number';
                          if (value.length == 9 && value.split('')[0] == '7'){
                            phoneNumber = value;
                            phoneNumber.split('0');
                            // print(phoneNumber.split(''));
                            changeInvalidMessageOpacity = 0.0;
                          } else if(value.length !=9 || value.split('')[0] != '7'){
                            changeInvalidMessageOpacity = 1.0;
                          }
                        }else {
                          invalidMessageDisplay = 'Number should start with 7';
                          changeInvalidMessageOpacity = 1.0;
                        }
                        // });

                        phoneNumber = value;
                      }, onFinishedTypingFunction: () {  },
                    ),
                    kSmallHeightSpacing,
                    // SizedBox(height: 10.0,),
                    InputFieldWidgetEditInfo(labelText: ' Email', hintText: 'abc@gmail.com',controller: email,readOnlyVariable: false, keyboardType: TextInputType.emailAddress, onTypingFunction: (value){
                      email = value;
                    }, onFinishedTypingFunction: () {  },),
                    // SizedBox(height: 8.0,),
                    //
                    // InputFieldWidget(labelText: ' Next of Kin', hintText: 'John',controller: kin,readOnlyVariable: false, keyboardType: TextInputType.text, onTypingFunction: (value){
                    //   kin = value;
                    // }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' Next of Kin Number', hintText: '', controller: kinNumber,readOnlyVariable: false, keyboardType: TextInputType.number, onTypingFunction: (value){
                    //   kinNumber = value;
                    // }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' Allergies', hintText: "Pineapples, Milk",controller: allergies,readOnlyVariable: false, keyboardType: TextInputType.text, onTypingFunction: (value){
                    //   allergies = value;
                    // }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' ID Number', hintText: 'CM78923YUE090324', controller: idNumber,keyboardType: TextInputType.text, onTypingFunction: (value){
                    //   idNumber = value;
                    // }, onFinishedTypingFunction: () {  },),

                    InputFieldWidgetEditInfo(labelText: ' Weight (kg)',controller: weight.toString(),readOnlyVariable: false, hintText: '85', keyboardType: TextInputType.number, onTypingFunction: (value){
                      weight = double.parse(value) ;
                    }, onFinishedTypingFunction: () {  },),
                    InputFieldWidgetEditInfo(labelText: ' Height (cm)', hintText: '170',controller: height.toString(),readOnlyVariable: false, keyboardType: TextInputType.number, onTypingFunction: (value){
                      height = int.parse(value);
                    }, onFinishedTypingFunction: () {  },),
                    InputFieldWidgetEditInfo(labelText: ' Date of Birth',

                      hintText: '16/May/1989',controller: birth,readOnlyVariable: true, keyboardType: TextInputType.text, onTypingFunction: (value){
                      birth = value;
                    }, onFinishedTypingFunction: () {  },),


                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child:
                        // Text("Hi")
                        DesignedButton(continueFunction: () async{
                          final prefs = await SharedPreferences.getInstance();

                          final isValidForm = formKey.currentState!.validate();



                          // else

                          if (isValidForm){

                            prefs.setString(kUserBirthday, birth);
                            prefs.setString(kFirstNameConstant, fullName.split(" ")[0]);
                            prefs.setString(kPhoneNumberConstant, phoneNumber);
                            prefs.setString(kFullNameConstant, fullName);
                            prefs.setString(kEmailConstant, email);
                            prefs.setInt(kUserHeight, height);
                            prefs.setDouble(kUserWeight, weight);

                            uploadUserData();


                            _btnController.reset();
                            Navigator.pop(context);

                          }
                          else{
                            _btnController.reset();
                          }
                        }, title: 'Update Information',)




                      // RoundedLoadingButton(
                      //   color: kGreenThemeColor,
                      //   child: Text('Continue' , style: kHeadingTextStyleWhite),
                      //   controller: _btnController,
                      //   onPressed: () async {
                      //     final prefs = await SharedPreferences.getInstance();
                      //
                      //     final isValidForm = formKey.currentState!.validate();
                      //
                      //
                      //
                      //     // else
                      //
                      //       if (isValidForm){
                      //         prefs.setString(kNextOfKin, kin);
                      //         prefs.setString(kNextOfKinNumber, kinNumber);
                      //         prefs.setString(kPhoneNumberConstant, phoneNumber);
                      //         prefs.setString(kFullNameConstant, fullName);
                      //         prefs.setString(kAllergies, allergies);
                      //         prefs.setString(kIdNumber, idNumber);
                      //         prefs.setString(kEmailConstant, email);
                      //         prefs.setString(kBloodPressure, bloodPressure);
                      //         prefs.setInt(kUserHeight, height);
                      //         prefs.setDouble(kUserWeight, weight);
                      //
                      //
                      //         _btnController.reset();
                      //         Navigator.pop(context);
                      //         Navigator.push(context,
                      //             MaterialPageRoute(builder: (context)=> FormsPageCurrent())
                      //         );
                      //
                      //       }
                      //       else{
                      //         _btnController.reset();
                      //       }
                      //
                      //
                      //
                      //   },
                      // ),
                    ),
                    Opacity(
                        opacity: errorMessageOpacity,
                        child: Text(errorMessage, style: TextStyle(color: Colors.red),)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
