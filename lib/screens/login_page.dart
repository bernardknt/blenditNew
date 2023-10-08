
import 'dart:io';

import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constants.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final auth = FirebaseAuth.instance;
  late String email ;
  late String password;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var token = "phoneToken";
  bool showSpinner = false;

  Future<void> uploadUserToken() async {


    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'token': token
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Platform.isIOS){
      print("");


    }

    _firebaseMessaging.getToken().then((value) => token = value!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In'),
        backgroundColor: const Color(0xFF000000),),
      //backgroundColor: Colors.orange,
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Container(
              height: 280,
              //color: Colors.red,
              child: Stack(
                children: [
                  Positioned(child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90), bottomRight: Radius.circular(90)),
                      image: DecorationImage
                        (
                          image:AssetImage('images/funky.png'),
                          fit: BoxFit.fill),
                    ),
                  ))
                ],
              ),
            ),
              //åSizedBox(height: 10,),
              Padding(padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: Column(
                    children: [Text("Welcome, Let's Sign you in",textAlign: TextAlign.center, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black54
                    ),),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x60AF27A2),
                                blurRadius: 20,
                                offset: Offset(0,20),
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.green
                                  ))
                              ),
                              child: TextField(
                                onChanged: (value){
                                  email = value;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:  'Email Address',
                                    hintStyle: TextStyle(color: Colors.grey)
                                ) ,
                              )
                              ,),
                            // SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(10),

                              child: TextField(
                                obscureText: true,
                                onChanged: (value){
                                  password = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:  'Password',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ) ,
                              )
                              ,),
                          ],
                        ) ,
                      ),
                      TextButton(onPressed: (){
                        if(email != ''){
                          auth.sendPasswordResetEmail(email: email);
                          showDialog(context: context, builder: (BuildContext context){
                            return CupertinoAlertDialog(
                              title: Text('Reset Email Sent'),
                              content: Text('Check email $email for the reset link'),
                              actions: [CupertinoDialogAction(isDestructiveAction: true,
                                  onPressed: (){
                                    _btnController.reset();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'))],
                            );
                          });
                        }else{
                          showDialog(context: context, builder: (BuildContext context){
                            return CupertinoAlertDialog(
                              title: Text('Type Email'),
                              content: Text('Please type your email Address and Click on the forgot password!'),
                              actions: [CupertinoDialogAction(isDestructiveAction: true,
                                  onPressed: (){
                                    //_btnController.reset();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'))],
                            );
                          });
                        }

                      }, child: Text('Forgot Password')),
                      RoundedLoadingButton(
                        color: Colors.black,
                        child: Text('Login', style: TextStyle(color: Colors.white)),
                        controller: _btnController,
                        onPressed: () async {

                          try{
                            final user = await auth.signInWithEmailAndPassword(email: email, password: password);
                            // auth.currentUser!.uid;
                            print(auth.currentUser!.uid);
                            final users = await FirebaseFirestore.instance
                                .collection('users').doc(auth.currentUser!.uid)
                                .get();
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString(kFullNameConstant, users['lastName']);
                            prefs.setString(kFirstNameConstant, users['firstName']);
                            prefs.setString(kEmailConstant, email);
                            prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
                            prefs.setBool(kIsLoggedInConstant, true);
                            prefs.setString(kToken, token);
                            uploadUserToken(); // This ensures that the phone currently logged in is the one that gets the phone notifications

                            // Navigator.pushNamed(context, ControlPage.id);
                            Navigator.pushNamed(context, ResponsiveLayout.id);

                          }catch(e) {
                            _btnController.error();
                            showDialog(context: context, builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: Text('Oops Login Failed'),
                                content: Text('The credentials you have entered are incorrect'),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      _btnController.reset();
                                      Navigator.pop(context);
                                    },

                                    child: Text('Cancel'))],
                              );
                            });
                          }

                          },
                      ),
                    ],
                  )
              ),
            ],
          ),
      ),
    );
  }
}
