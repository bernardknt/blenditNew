
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/paywall_international.dart';
import 'package:blendit_2022/screens/paywall_uganda.dart';
import 'package:blendit_2022/screens/purchase_restored_page.dart';
import 'package:blendit_2022/screens/welcome_page_new.dart';
import 'package:blendit_2022/widgets/designed_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../widgets/TicketDots.dart';
import 'customer_care.dart';
import 'edit_page.dart';
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

  Future<void> unsubscribeFromTopic(number) async {
    try {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      var topic = removeFirstCharacter(number);
      await firebaseMessaging.unsubscribeFromTopic(topic).then((value) =>print('Succefully UnSubscribed'));
      print('Successfully unsubscribed from topic: $topic');
    } catch (e) {
      print('Failed to unsubscribe from topic: tokens. Error: $e');
      // Handle error here
    }
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

  void checkStringType(String input) {
    // Regular expression pattern to match a phone number
    RegExp phoneNumberPattern = RegExp(r'^\+?\d{1,3}[-.\s]?\(?\d{1,3}\)?[-.\s]?\d{1,3}[-.\s]?\d{1,9}$');

    // Regular expression pattern to match a website link
    RegExp websiteLinkPattern = RegExp(r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');

    // Check if the input matches the phone number pattern
    if (phoneNumberPattern.hasMatch(input)) {
      print('Phone');
    }
    // Check if the input matches the website link pattern
    else if (websiteLinkPattern.hasMatch(input)) {
      print('Link');
    }
    // If the input does not match either pattern, print an error message
    else {
      print('Invalid input');
    }
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  final auth = FirebaseAuth.instance;


  @override

  Widget build(BuildContext context) {
    var aiData = Provider.of<AiProvider>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   backgroundColor: kGreenThemeColor,
      //   title: Text('Settings Page', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      //   centerTitle: true,
      // ),
      floatingActionButton:
      FloatingActionButton(
        backgroundColor: kGreenThemeColor,
        onPressed: () async {

          var prefs = await SharedPreferences.getInstance();

           // launchUrl(Uri.parse('https://bit.ly/3p1N2nH'));
           //
          Navigator.pushNamed(context, CustomerCareChatMessaging.id);


          // if (Provider.of<AiProvider>(context, listen: false).customerCareNumber[0] != "+"){
          //    CommonFunctions().goToLink(Provider.of<AiProvider>(context, listen: false).customerCareNumber);
          // }else {
          //   CommonFunctions().callPhoneNumber(Provider.of<AiProvider>(context, listen: false).customerCareNumber);
          //
          // }






        },
        child: Icon(Icons.support_agent),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,


      backgroundColor: kBackgroundGreyColor,
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // RoundImageRing(radius: 80, outsideRingColor: kPureWhiteColor, networkImageToUse: 'https://mcusercontent.com/f78a91485e657cda2c219f659/images/e80988fd-e61d-2234-2b7e-dced6e5f3a1a.jpg',),
              //

              // kSmallWidthSpacing,
              email == null?Text(phoneNumber, style: kNormalTextStyle) :Text(email, style: kNormalTextStyle.copyWith(fontSize: 10)),
              kSmallHeightSpacing,

              Provider.of<AiProvider>(context, listen: false).subscriptionButton == false ? Container():Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('Membership', style: kNormalTextStyleSmall,),
                  kMediumWidthSpacing,
                  GestureDetector(
                    onTap: ()async{

                        CoolAlert.show(


                            context: context,
                            type:
                            CoolAlertType.success,
                            widget: SingleChildScrollView(
                              child: Column(
                                children: [
                                  aiData.subscriptionType != "Basic" ? Text('This subscription package expires on \n${DateFormat('EE, dd MMM, yyyy').format(aiData.subscriptionDate)} ', style: kNormalTextStyle.copyWith(fontSize: 14
                                  ), textAlign: TextAlign.center,):
                                  Text("You don't have a running Subscription", style: kNormalTextStyle.copyWith(fontSize: 14
                                  ), textAlign: TextAlign.center,),
                                  TicketDots(mainColor: kFontGreyColor, circleColor: kPureWhiteColor,),

                                ],
                              ),
                            ),
                            title: '${aiData.subscriptionType} Subscription',
                            confirmBtnText: aiData.subscriptionType != "Premium"?'Subscribe':"Ok",

                            confirmBtnColor: kAppPinkColor,
                            confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                            lottieAsset: 'images/loyalty.json', showCancelBtn: true, backgroundColor: kPureWhiteColor,


                            onConfirmBtnTap: () async{
                              final prefs = await SharedPreferences.getInstance();
                              if (aiData.subscriptionType!= "Premium"){
                                if (prefs.getString(kUserCountryName) == "Uganda" && Provider.of<AiProvider>(context, listen: false).iosUpload == false) {
                                  Navigator.push(context,
                                    //  MaterialPageRoute(builder: (context) => PaywallUgandaPage())
                                      MaterialPageRoute(builder: (context)=> PaywallInternationalPage())
                                  );
                                }else {
                                  CommonFunctions().fetchOffers().then(
                                          (value) {
                                        // We are sending a List of Offerings to the value subscriptionProducts
                                        Provider.of<AiProvider>(context, listen: false).setSubscriptionProducts(value);
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=> PaywallInternationalPage())
                                        );

                                      }


                              );}
                              } else {

                                setState((){
                                  Navigator.pop(context);
                                });
                              }

                            }
                            );
                    },
                    child: Container(
                      height: 30,
                      width: 100,

                      decoration: BoxDecoration(
                        color: kBlack,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(child: Text(Provider.of<AiProvider>(context, listen: false).subscriptionType,style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),),
                  )
                ],
              ),
              TextButton(onPressed: () async {
                try {
                  showDialog(context: context, builder:
                      ( context) {
                    return const Center(child: CircularProgressIndicator());
                  });
                  CustomerInfo customerInfo = await Purchases.restorePurchases();
                  Navigator.pop(context);

                  if(customerInfo.activeSubscriptions.toString() == "[]"  ){
                    CoolAlert.show(

                      lottieAsset: 'images/goal.json',
                      context: context,
                      type: CoolAlertType.warning,
                      title: "No Subscription Found",
                    );

                  } else {
                    CoolAlert.show(

                        lottieAsset: 'images/goal.json',
                        context: context,
                        type: CoolAlertType.success,
                        title: "Subscription Detected",
                        widget: Text("${customerInfo.activeSubscriptions[0]}"),
                        cancelBtnText: "Cancel",
                        showCancelBtn: true,
                        onCancelBtnTap: (){Navigator.pop(context);},
                        onConfirmBtnTap: (){

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, RestorePurchasePage.id);
                        },
                        confirmBtnColor: kGreenThemeColor,
                        confirmBtnText: 'Activate'

                    );
                  }

                  // ... check restored purchaserInfo to see if entitlement is now active
                } on PlatformException catch (e) {
                  // Error restoring purchases
                }


              }, child: Text("Restore Purchase", style: kNormalTextStyle.copyWith(color: Colors.blue),)),

              kLargeHeightSpacing,
              DesignedButton(continueFunction: (){
                Share.share('Hey, I found this application called Nutri that helps keep you accountable and on track with your Health goals. You need to try it out. Follow the link \nhttps://bit.ly/3I8sa4M', subject: 'You need to try out Nutri');
              }, title: "Recommend Nutri", backgroundColor: kCustomColor,textColor: kBlack,),
              kLargeHeightSpacing,


              Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                    shadowColor: kGreenDarkColorOld,
                    elevation: 5.0,
                    child:
                    Column(
                      children: [
                        // ListTile(
                        //   leading: Icon(Iconsax.people, color: kGreenDarkColorOld,),
                        //   title:Text(sex, style: kNormalTextStyle),
                        //   // trailing: Icon(Icons.keyboard_arrow_right),
                        // ),
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
                        // ListTile(
                        //   leading: Icon(Iconsax.cake, color: kGreenDarkColorOld,),
                        //   title:Text('DOB: $birthday', style:kNormalTextStyle),
                        //   // trailing: Icon(Icons.keyboard_arrow_right),
                        // ),

                      ],
                    ),
                  ),
                  Positioned(

                    child:
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfilePage()));
                      },
                      child: CircleAvatar(
                          backgroundColor: kGreenThemeColor,
                          child: Icon(Icons.edit, color: kPureWhiteColor,)),
                    ),
                    top: 0, right: 10,),
                ],
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
                      leading: Icon(Iconsax.personalcard, color: kGreenDarkColorOld,),
                      title:Text(name, style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),

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


                      },
                      child:  ListTile(
                        leading: Icon(LineIcons.flag, color: kGreenThemeColor,),
                        title:Text(country, style:kNormalTextStyle),
                        // trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),


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
                                await auth.signOut().then((value) {
                                  unsubscribeFromTopic(prefs.getString(kPhoneNumberConstant));
                                  Navigator.pushNamed(context, WelcomePageNew.id);
                                  CommonFunctions().cancelNotification(prefs.getString(kUniqueIdentifier));
                                  
                                } );
                                



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


                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool(kIsLoggedInConstant, false);
                            prefs.setBool(kIsFirstTimeUser, true);

                            await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).delete().then((value) async =>
                            await auth.signOut().then((value){
                              Navigator.pushNamed(context, WelcomePageNew.id);
                              CommonFunctions().cancelNotification(prefs.getString(kUniqueIdentifier));
                              prefs.setStringList(kPointsList,[]);//cancel all notifications

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
                              child: Text('Nutri 2023', style: kHeadingTextStyle,)),
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
