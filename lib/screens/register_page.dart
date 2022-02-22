import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/InputFieldWidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';



class RegisterPage extends StatefulWidget {
  static String id = 'register_page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final HttpsCallable callableSMS = FirebaseFunctions.instance.httpsCallable('sendWelcomeSMS');
  final HttpsCallable callableEmail = FirebaseFunctions.instance.httpsCallable('sendEmail');
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();


  @override
  String email= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String password = '';
  String fullName = '';
  String firstName = '';
  String phoneNumber = '';

  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  late String countryCode;


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Sign Up'),
        backgroundColor: Colors.black,),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0),

        child: SingleChildScrollView(
          child: Container(
            height: 550,

            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child:
                      Center(child: Image.asset('images/fruits.png',)),
                  ),

                //Text('SIGN UP', style: TextStyle(color: Colors.black54, fontSize: 30),),
                SizedBox(height: 10.0,),
                Opacity(
                    opacity: changeInvalidMessageOpacity,
                    child: Text(invalidMessageDisplay, style: TextStyle(color:Colors.red , fontSize: 12),)),
                InputFieldWidget(labelText:' Full Names' ,hintText: 'James Okoth', keyboardType: TextInputType.text, onTypingFunction: (value){
                  fullName = value;
                  firstName = fullName.split(" ")[0]; // Gets the first name in the 0 positiion from the full names
                },),
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (value){
                        countryCode = value.name!;
                        print(countryCode);
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'UG',
                      favorite: ['+256','UG'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                    InputFieldWidget(labelText: 'Mobile Number', hintText: '77100100', keyboardType: TextInputType.number,  onTypingFunction: (value){
                      setState(() {
                        if (value.split('')[0] == '7'){
                          invalidMessageDisplay = 'Incomplete Number';
                          if (value.length == 9 && value.split('')[0] == '7'){
                            phoneNumber = value;
                            phoneNumber.split('0');
                            print(value.split('')[0]);
                            print(phoneNumber.split(''));
                            changeInvalidMessageOpacity = 0.0;
                          } else if(value.length !=9 || value.split('')[0] != '7'){
                            changeInvalidMessageOpacity = 1.0;
                          }
                        }else {
                          invalidMessageDisplay = 'Number should start with 7';
                          changeInvalidMessageOpacity = 1.0;
                        }
                      });

                      phoneNumber = value;
                    }),
                  ],
                ),
                SizedBox(height: 10.0,),
                InputFieldWidget(labelText: ' Email', hintText: 'abc@gmail.com', keyboardType: TextInputType.emailAddress, onTypingFunction: (value){
                  email = value;
                }),
                // SizedBox(height: 8.0,),
                InputFieldWidget(labelText: ' Password',hintText:'Password', keyboardType: TextInputType.visiblePassword,passwordType: true, onTypingFunction: (value){
                  password = value;
                }),
                //SizedBox(height: 8.0,),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child:
                      RoundedLoadingButton(
                        color: Colors.green,
                        child: Text('Register', style: TextStyle(color: Colors.white)),
                        controller: _btnController,
                        onPressed: () async {
                          if (email ==''|| phoneNumber == '' || email =='' || password == '' || fullName == ''){
                            _btnController.error();
                            showDialog(context: context, builder: (BuildContext context){

                              return CupertinoAlertDialog(
                                title: Text('Oops Something is Missing'),
                                content: Text('Make sure you have filled in all the fields'),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      _btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'))],
                              );
                            });
                          }else {
                            print('Else activated');
                            setState(() {
                              //showSpinner = true;
                            });
                            try{
                              final newUser = await _auth.createUserWithEmailAndPassword(email: email,
                                  password: password);
                              if (newUser != null){


                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString(kFullNameConstant, fullName);
                                prefs.setString(kFirstNameConstant, firstName);
                                prefs.setString(kEmailConstant, email);
                                prefs.setString(kPhoneNumberConstant, phoneNumber);
                                prefs.setBool(kIsLoggedInConstant, true);
                                prefs.setBool(kIsFirstTimeUser, true);
                                prefs.setBool(kIsTutorialDone, false);
                                prefs.setBool(kIsFirstBlending, true);

                                Navigator.pushNamed(context, ControlPage.id);


                                // SAVE THE VALUES TO THE USER DEFAULTS AND DATABASE
                              }else{
                                setState(() {
                                  errorMessageOpacity = 1.0;
                                });
                              }

                            }catch(e){
                              _btnController.error();
                              showDialog(context: context, builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: Text('Oops Register Error'),
                                  content: Text('${e}'),
                                  actions: [CupertinoDialogAction(isDestructiveAction: true,
                                      onPressed: (){
                                    _btnController.reset();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'))],
                                );
                              });
                              //print('error message is: $e');
                            }
                            //Implement registration functionality.
                          }

                        },
                      ),
                    ),
                    Opacity(
                        opacity: errorMessageOpacity,
                        child: Text(errorMessage, style: TextStyle(color: Colors.red),))
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
