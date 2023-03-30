
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/screens/welcome_page.dart';
import 'package:blendit_2022/screens/welcome_page_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import 'login_page.dart';


class NewSettingsPage extends StatefulWidget {
  static String id = 'settings_page_new';

  @override
  _NewSettingsPageState createState() => _NewSettingsPageState();
}

class _NewSettingsPageState extends State<NewSettingsPage> {
  get kGreenDarkColorOld => null;

  void defaultsInitiation () async{

    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFullNameConstant) ?? 'User';
    String newSex = prefs.getString(kUserSex) ?? 'Name';
    String newBirthday = prefs.getString(kUserBirthday) ?? '16-May-1989';
    String newCountry = prefs.getString(kUserCountryName) ?? '16-May-1989';
    String? newPhone = prefs.getString(kPhoneNumberConstant);
    String? newEmail = prefs.getString(kEmailConstant) ??"No email";
    String newSubscribedChurch = 'Haircuts, Massage, Makeup';
    double newWeight = prefs.getDouble(kUserWeight) ?? 80;
    String? newPreferences = prefs.getString(kUserPersonalPreferences);
    int newHeight = prefs.getInt(kUserHeight)?? 180;


    setState(() {
      country = newCountry;
      birthday = newBirthday;
      weight = newWeight;
      name = newName;
      sex = newSex;
      phone = newPhone!;
      email= newEmail!;
      preferences = newPreferences!;
      height = newHeight;
      bmi = ((weight)/ ((height/100)*(height/100))).roundToDouble();
      // phoneNumber = prefs.getString(kCustomerCare)!;


    });
  }
  double textSize = 15;
  String preferences = '';
  String country = '';
  String phone = '';
  String name = '';
  String sex = 'Female';
  String email = '';
  double bmi = 20.0;
  String birthday = '16/May/1989';
  double weight = 40;
  String phoneNumber = '';
  int height = 150;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kGreenThemeColor,
        title: Text('Settings Page', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
        centerTitle: true,
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () async {

          var prefs = await SharedPreferences.getInstance();

           launchUrl(Uri.parse('https://bit.ly/3p1N2nH'));
          //  launchUrl(Uri.parse('${prefs.getString(kWhatsappNumber)}'));
           // launchUrl(Uri.parse('www.google.com'));

         // print('${prefs.getString(kWhatsappNumber)}');


          // launch('${prefs.getString(kWhatsappNumber)}');


        },
        child: Lottie.asset('images/whatsapp.json', ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,


      backgroundColor: kBackgroundGreyColor,
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // RoundImageRing(radius: 80, outsideRingColor: kPureWhiteColor, networkImageToUse: 'https://mcusercontent.com/f78a91485e657cda2c219f659/images/e80988fd-e61d-2234-2b7e-dced6e5f3a1a.jpg',),
              //

              kSmallWidthSpacing,
              Text(name, style: kNormalTextStyleWhiteButtons.copyWith(color: kGreenThemeColor),),

              // Card(
              //   color: kPureWhiteColor,
              //   shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
              //   shadowColor: kGreenThemeColor,
              //   elevation: 5.0,
              //   child: ListTile(
              //     title: Text(name, style: kNormalTextStyleWhiteButtons.copyWith(color: kGreenDarkColorOld)),
              //     leading: const CircleAvatar(
              //       backgroundImage: AssetImage('images/medical.png'),
              //     ),
              //     //  trailing: const Icon(Icons.edit, color: Colors.white,),
              //   ),
              // ),
              kSmallHeightSpacing,
              // const Center(child: Text('Transaction Info', style: kNormalTextStyleSmall,)),
              Card(
                margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kNewGreenThemeColor,
                elevation: 5.0,
                child:
                Column(
                  children: [


                  ],
                ),
              ),
              kSmallHeightSpacing,
              Center(child: Text('Health Info', style: kNormalTextStyleSmall,)),

              Card(
                margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kGreenDarkColorOld,
                elevation: 5.0,
                child:
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Iconsax.people, color: kGreenDarkColorOld,),
                      title:Text(sex, style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Iconsax.ruler, color: kGreenDarkColorOld,),
                      title:Text( '$height cm', style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Iconsax.weight, color:kGreenDarkColorOld,),
                      title:Text('$weight kg', style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Iconsax.health, color: kGreenDarkColorOld,),
                      title:Text('BMI: $bmi', style:kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Iconsax.tag, color: kGreenDarkColorOld,),
                      title:Text('Focus: $preferences', style:kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Iconsax.cake, color: kGreenDarkColorOld,),
                      title:Text('DOB: $birthday', style:kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),

                  ],
                ),
              ),
              Center(child: Text('Personal Info', style: kNormalTextStyleSmall,)),


              Card(
                margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kGreenDarkColorOld,
                elevation: 5.0,
                child:
                Column(
                  children: [

                    ListTile(
                      leading: Icon(Icons.phone, color: kGreenDarkColorOld,),
                      title:Text( phone, style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Icons.email, color:kGreenDarkColorOld,),
                      title:Text(email, style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onTap: (){
                        // showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       return Container(color: kBackgroundGreyColor,
                        //         child: InputPage(),
                        //       );
                        //     });
                        //

                      },
                      child:  ListTile(
                        leading: Icon(LineIcons.flag, color: kGreenThemeColor,),
                        title:Text(country, style:kNormalTextStyle),
                        // trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    // _buildDivider(),
                    // ListTile(
                    //   leading: Icon(Iconsax.scissor, color: kGreenDarkColorOld,),
                    //   title:Text(preferences, style: kNormalTextStyle),
                    //   // trailing: Icon(Icons.keyboard_arrow_right),
                    // ),
                  ],
                ),
              ),


              const SizedBox(height: 10,),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: (){
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              widget: Column(
                                children: [
                                  Text('Are you sure you want to Log Out?', textAlign: TextAlign.center, style: kNormalTextStyle,),

                                ],
                              ),
                              title: 'Log Out?',

                              confirmBtnColor: kFontGreyColor,
                              confirmBtnText: 'Yes',
                              confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                              lottieAsset: 'images/chopping.json', showCancelBtn: true, backgroundColor: kBlack,


                              onConfirmBtnTap: () async{
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool(kIsLoggedInConstant, false);
                                prefs.setBool(kIsFirstTimeUser, true);
                                await auth.signOut().then((value) => Navigator.pushNamed(context, WelcomePageNew.id));



                              }


                          );
                        },
                        child: Text("Log Out", style:kNormalTextStyleBoldPink.copyWith(color: Colors.blue) ,)),
                    kLargeHeightSpacing,

                    kLargeHeightSpacing,

                    TextButton(onPressed: (){

                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          widget: Column(
                            children: const [
                              Text('Are you sure you want Delete this Account? All your data will be lost and this action cannot be undone', textAlign: TextAlign.center, style: kNormalTextStyle,),
                            ],
                          ),
                          title: 'Delete Account!',

                          confirmBtnColor: kFontGreyColor,
                          confirmBtnText: 'Yes',
                          confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                          lottieAsset: 'images/kiwi.json', showCancelBtn: true, backgroundColor: kFaintGrey,


                          onConfirmBtnTap: () async{
                            // FirebaseUser user = await FirebaseAuth.instance.currentUser!();
                            // user.delete();
                            // CommonFunctions().signOut();
                            // // Navigator.pop(context);
                            // // Navigator.pop(context);
                            // // Navigator.pop(context);
                            // Navigator.pushNamed(context, WelcomePage.id)


                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool(kIsLoggedInConstant, false);
                            prefs.setBool(kIsFirstTimeUser, true);

                            await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).delete().then((value) async =>
                            await auth.signOut().then((value){
                              Navigator.pushNamed(context, LoginPage.id);
                              CommonFunctions().cancelNotification(); //cancel all notifications

                            }
                            )
                            );

                            // await auth.signOut().then((value) => Navigator.pushNamed(context, WelcomePage.id));


                          }
                      );



                    }, child: Text("Delete Account", style:kNormalTextStyleBoldPink.copyWith(color: Colors.red, fontSize: 13) ,)),

                    const SizedBox(height: 10,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LineIcons.copyright, color: Colors.black,size: 15,),
                          SizedBox(width: 5,),
                          Opacity (opacity: 0.7,
                              child: Text('Frutsexpress 2023', style: kHeadingTextStyle,)),
                        ],
                      ),
                    )
                  ],
                ),

              ),

            ],

          ),
        ),
      ),
    );
  }


  Container _buildDivider(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[200],

    );
  }
}
