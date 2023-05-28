
import 'dart:async';

import 'package:blendit_2022/screens/paywall_first_international.dart';
import 'package:blendit_2022/screens/paywall_first_uganda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/home_controller.dart';
import '../../models/CommonFunctions.dart';
import '../../models/ai_data.dart';
import '../../utilities/constants.dart';
import '../../utilities/font_constants.dart';


class QuizPage5 extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPage5State createState() => _QuizPage5State();
}

class _QuizPage5State extends State<QuizPage5> {
  var categoryName = [];
  var categoryId = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var token = "old token";

  void defaultInitialisation() async{
    _firebaseMessaging.getToken().then((value) => token = value!);
    final prefs = await SharedPreferences.getInstance();
    print('WALALALALLA ${prefs.getString(kUserCountryName)}');
  }
  Future<void> uploadUserData() async {
    final auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'country': prefs.getString(kUserCountryName),
          'firstName': prefs.getString(kFirstNameConstant),
          'email': prefs.getString(kEmailConstant) ,
          'lastName': prefs.getString(kFullNameConstant),
          'phoneNumber': prefs.getString(kPhoneNumberConstant),
          'weight': prefs.getDouble(kUserWeight),
          'height': prefs.getInt(kUserHeight),
          'subscribed': true,
          'token': token
        });
    prefs.setString(kToken, token);
    print("PEERRRRRFEEECTLY UPDATED");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialisation();


  }

  @override

  Widget build(BuildContext context) {
     var aiData = Provider.of<AiProvider>(context, listen: false);
     var aiDataDisplay = Provider.of<AiProvider>(context);
    // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: aiDataDisplay.preferencesContinueColor,
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(kIsFirstTimeUser, false);
            prefs.setBool(kSetWeekGoal, false);


            // prefs.setString(kPreferencesConstant, styleDataDisplay.userPreferences.join(', '));
            // prefs.setString(kPreferencesIdConstant, styleDataDisplay.preferencesIdSelected.join(', '));
            uploadUserData();
           // styleData.setUserDetailsAfterOnboard(styleDataDisplay.userSex, styleDataDisplay.userBirthday,styleDataDisplay.userPreferences, styleDataDisplay.preferencesIdSelected);

            // Navigator.pushNamed(context, ControlPage.id);

            if(Provider.of<AiProvider>(context, listen: false).iosUpload == false) {
              if (prefs.getString(kUserCountryName) == "Uganda"){
                Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> PaywallFirstUgandaPage())
                    // MaterialPageRoute(builder: (context)=> PaywallFirstInternationalPage())

                );
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> PaywallFirstInternationalPage())
                );
              }
            } else {
              Navigator.pushNamed(context, ControlPage.id);
            }

            prefs.setString(kUserPersonalPreferences, aiData.preferencesSelected.join(", "));

            CommonFunctions().uploadUserPreferences(aiDataDisplay.preferencesSelected, aiDataDisplay.userSex, aiDataDisplay.userBirthday, aiDataDisplay.preferencesIdSelected);

          },
          label:  Text("Enter Nutri", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack),),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        backgroundColor: kBlueDarkColorOld,
        // appBar: AppBar(
        //   backgroundColor: Colors.deepOrangeAccent,
        //
        // ),
        body:
        SafeArea(
          child: Stack(
              children :
              [
                Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:50.0, right: 10, left: 10),
                      child: Text('Finally! What are your main Goals?',
                          textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor, fontSize: 18)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kBlueDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
                Padding(
                  padding: const EdgeInsets.only(top:130.0, right: 12, left: 12),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('preferences')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {} else {
                          categoryName = [];


                          var items = snapshot.data!.docs;
                          for (var item in items) {
                            categoryName.add(item.get('name'));
                            categoryId.add(item.get('id'));

                          }
                        }
                        return categoryName.length != 0 ?
                        StaggeredGridView.countBuilder(
                              crossAxisCount: 3,
                              itemCount: categoryName.length,
                              crossAxisSpacing:10,
                              // physics: NeverScrollableScrollPhysics,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {

                                    aiDataDisplay.setPreferencesBoxColor(index, aiData.preferencesColorOfBoxes[index], categoryName[index], categoryId[index]);
                                  },
                                  child:
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      // color: Colors.white,

                                      width: 125,
                                      height: 125,
                                      decoration: BoxDecoration(
                                        color: aiDataDisplay.preferencesColorOfBoxes[index],
                                        //borderRadius: BorderRadius.circular(20),
                                        shape: BoxShape.circle ,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      // decoration: BoxDecoration(
                                      //
                                      //     shape: BoxShape.circle ,
                                      //     color: aiDataDisplay.preferencesColorOfBoxes[index]
                                      //   // gradient: LinearGradient(
                                      //   //     begin: Alignment.topCenter,
                                      //   //     end: Alignment.bottomCenter,
                                      //   //     colors: [kButtonGreyColor, kButtonGreyColor] ),
                                      //
                                      // ),
                                      child: Center(child: Text(
                                        categoryName[index], textAlign: TextAlign.center,
                                        style: kHeading3TextStyleBold,)),

                                    ),
                                  ),
                                );
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(1)): Lottie.asset("images/lisa.json");

                        // ListView.builder(
                        //   itemCount: categoryName.length,
                        //   itemBuilder: (context, index) {
                        //     return questionBlocks(categoryName[index]);
                        //   });


                      }),
                ),

              ]
          ),
        )
    );
  }


}



