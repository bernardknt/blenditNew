
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/input_page.dart';
import 'package:blendit_2022/screens/rating_page.dart';
import 'package:blendit_2022/screens/welcome_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/roundedButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_us.dart';


class SettingsPage extends StatefulWidget {
  static String id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void defaultsInitiation () async{

    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFullNameConstant) ?? 'Minister';
    String newChurch = prefs.getString(kFirstNameConstant) ?? 'Oneministry';
    String? newPhone = prefs.getString(kPhoneNumberConstant);
    String? newEmail = prefs.getString(kEmailConstant);
    String newSubscribedChurch = 'Kampala';




    setState(() {

      name = newName;
      churchName = newChurch;
      phone = newPhone!;
      email= newEmail!;
      subscribedChurch = newSubscribedChurch;
      phoneNumber = prefs.getString(kSupportNumber)!;


    });
  }

  final _dialog = RatingDialog(
    initialRating: 3.0,
    // your app's name?
    title: const Text(
      'Rate Your Order',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: const Text(
      'Tap a star to set your rating.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ),
    // your app's logo?
    image: Image.asset('images/black_logo.png',width: 150, height: 150, ),
    submitButtonText: 'Submit',
    commentHint: 'You can Add an extra Comment',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) async{
      var prefs = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('orders').doc(prefs.getString(kOrderId))
          .update({
        'rating': response.rating,
        'rating_comment': response.comment,
        'hasRated': true
      }
      );
      return 0;
    },
  );
  void showRatingsDialogue(){
    showDialog(
      context: context,
      barrierDismissible: false, // set to false if you want to force a rating
      builder: (context) => RatingPage(),
    );
  }
  double textSize = 15;
  String subscribedChurch = '';
  String phone = '';
  String name = '';
  String churchName = '';
  String email = '';
  String phoneNumber = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kIsLoggedInConstant, false);
    prefs.setBool(kIsFirstBlending, true);
    prefs.setBool(kIsFirstTimeUser, true);

    Navigator.pushNamed(context, WelcomePage.id);
    // prefs.set('kIsLoggedInConstant');
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueDarkColor,
        title: Text('Settings'),
        centerTitle: true,),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: kGreenThemeColor,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kGreenThemeColor,
                elevation: 5.0,
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontFamily: 'Montserrat-Medium', color: Colors.white)),
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('images/fruits.png'),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.white,),
                ),
              ),
              const SizedBox(height: 10,),
              Card(
                margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kGreenThemeColor,
                elevation: 5.0,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.phone, color: kGreenThemeColor,),
                      title:Text( phone, style: TextStyle(fontFamily: 'Montserrat-Medium',fontSize: textSize)),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Icons.email, color:kGreenThemeColor,),
                      title:Text(email, style: TextStyle(fontFamily: 'Montserrat-Medium',fontSize: textSize)),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onTap: (){
                        showRatingsDialogue();
                      },
                      child: ListTile(
                        leading: Icon(LineIcons.flag, color: kGreenThemeColor,),
                        title:Text('Uganda', style: TextStyle(fontFamily: 'Montserrat-Medium',fontSize: textSize)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onLongPress: (){
                        Navigator.pushNamed(context, InputPage.id);
                      },
                      child: ListTile(
                        leading: Icon(LineIcons.flag, color: kGreenThemeColor,),
                        title:Text(subscribedChurch, style: TextStyle(fontFamily: 'Montserrat-Medium',fontSize: textSize)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kGreenThemeColor,
                elevation: 5.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        launch('tel://0${phoneNumber}');
                      },
                      child: ListTile(
                        leading: Icon(Icons.support_agent, color:kGreenThemeColor,),
                        title:Text('Contact Support', style: TextStyle(fontFamily: 'Montserrat-Medium',fontSize: textSize)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onTap: (){
                        // showAboutDialog(context: context,
                        //     applicationVersion: '1.0.0');
                        Navigator.pushNamed(context, AboutUsPage.id);
                      },
                      child: ListTile(
                        leading: Icon(Icons.family_restroom_sharp, color: kGreenThemeColor,),
                        title:Text('About Blendit', style: TextStyle(fontFamily: 'Montserrat-Medium',fontSize: textSize)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 10,),
              Center(
                child: Column(
                  children: [
                    roundedButtons(buttonColor: kGreenJavasThemeColor , title: 'Log Out', onPressedFunction:  (){_signOut();}),
                    SizedBox(height: 10,),
                    Container(

                      alignment: Alignment.center,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LineIcons.copyright, color: Colors.black,size: 15,),
                            SizedBox(width: 5,),
                            Text('Blendit'),
                          ],
                        ),
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
