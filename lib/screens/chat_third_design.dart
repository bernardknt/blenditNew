
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/blendit_data.dart';
import '../widgets/TicketDots.dart';
import '../widgets/nutri_payment.dart';
import 'delivery_page.dart';
import 'new_settings.dart';







class ChatThirdDesignedPage extends StatefulWidget {
  static String id = 'three_orders_page';

  @override
  _ChatThirdDesignedPageState createState() => _ChatThirdDesignedPageState();
}

class _ChatThirdDesignedPageState extends State<ChatThirdDesignedPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  bool tutorialDone = true;
  late int quantity = 1;
  var formatter = NumberFormat('#,###,000');
  var phone = '';
  var name = '';
  String initialId = 'feature';
  Random random = new Random();

  var about = ['Nutri is an Artificial Intelligence powered assistant that learns your personal nutritional attributes as you interact with it.',
      ' For best results please enter your information as accurately as possible.',
      'feel free to ask questions you may have about your health and nutrition.',
    'Some thing has came to me! ask: Do you need a recipe for your salad..?',
    'Here is a great question: Can you make for me a detox plan for 2 days starting monday for weight gain?',
    'You are only limited by your imagination.',
      ' Ask any question like: Can I have matooke for super?', 'Here is a great question to ask: I want to lose weight, what should I do?','Give me a recipe for a healthy breakfast',
      ' Some answers may not be as accurate but usually helpful to keep you on track to achieve your goals', "Hi there"];
  TextEditingController _textFieldController = TextEditingController();

  // THIS IS FOR THE INITIAL TUTORIAL WALK THROUGH AND SHOW
  void tutorialShow ()async{
    final prefs = await SharedPreferences.getInstance();
    tutorialDone = false;
        //prefs.getBool(kIsTutorialDone) ?? false;
    if (tutorialDone == false){
      initialId = 'feature1';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FeatureDiscovery.discoverFeatures(context,
            <String>['feature1','feature2' ]);
           // <String>['feature1','feature2', 'feature3', 'feature4', 'feature5']);
      });
    }else{
      print("Tutorial $tutorialDone}");
    }
    prefs.setBool(kIsTutorial1Done, true);
  }


  bool updateMe = true;

  // THIS IS USED TO CHECK THE CURRENT APP VERSION AND ENCOURAGE THE USER TO UPDATE
  // advancedStatusCheck(NewVersion newVersion) async {
  //   final status = await newVersion.getVersionStatus();
  //
  //   if (status?.canUpdate == true && updateMe == true) {
  //
  //     newVersion.showUpdateDialog(
  //       dismissAction: (){
  //         Navigator.pop(context);
  //         Provider.of<BlenditData>(context, listen: false).setAppUpdateStatus();
  //       },
  //
  //       updateButtonText: 'Update Now',
  //       context: context,
  //       versionStatus: status!,
  //       dialogTitle: 'App Update 🎉',
  //       dialogText: 'We are excited to announce that Some awesome new features have been released. Upgrade from version ${status.localVersion} to ${status.storeVersion} to get the best experience',
  //
  //     );
  //   }
  // }

  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    phone =  prefs.getString(kPhoneNumberConstant)!;
    name = prefs.getString(kFirstNameConstant)!;
    setState(() {
      updateMe =  Provider.of<BlenditData>(context, listen: false).updateApp;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    tutorialShow();
    final newVersion = NewVersion(
      iOSId: 'com.frutsexpress.blendit2022',
      androidId: 'com.frutsexpress.blendit_2022',
    );
    // advancedStatusCheck(newVersion);

  }

  var messageList = [];
  var messageStatusList = [];
  var chatBubbleVisibility = true;
  var nutriVisibility = true;
  var aiResponseLength = 200;
  var responseList = [];
  var manualList = [];
  var idList = [];
  var dateList = [];
  var statusList = [];
  var paidStatusListColor = [];
  var message = '';
  var lastQuestion = '';
  List<double> opacityList = [];
  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';



  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;
  String serviceId = '';
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');

  Future<void> uploadData() async {
    var finalQuestion = lastQuestion;
    final prefs = await SharedPreferences.getInstance();
    int? previousNutriCount = prefs.getInt(kNutriCount);



    return chat.doc(serviceId)
        .set({
      'replied': false,
      'status' : true,
      'time':  DateTime.now(),
      'message': message,
      'response': '',
      'userId': prefs.getString(kPhoneNumberConstant),
      'weight': prefs.getDouble(kUserWeight),
      'height': prefs.getInt(kUserHeight),
      'name': prefs.getString(kFullNameConstant),
      'token': prefs.getString(kToken),
      'id':serviceId,
      'length': aiResponseLength,
      'lastQuestion': Provider.of<BlenditData>(context, listen: false).lastQuestion,
      'manual': false,
      'country': prefs.getString(kUserCountryName),
    })
        .then((value){
          Provider.of<BlenditData>(context, listen: false).changeLastQuestion(finalQuestion);
          prefs.setInt(kNutriCount, (previousNutriCount! + 1));
        } )
        .catchError((error) => print(error));
  }
  Positioned LowerTextForm() {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            TextField(
              controller: _textFieldController,  // _textFieldController is a TextEditingController object
              maxLines: 1,
              maxLength: 100,
              clipBehavior: Clip.antiAlias,
              // minLines: 2,
              // expands: true,

              decoration: InputDecoration(
                hintText: "...lets talk",
                fillColor: kPureWhiteColor,
                filled: true,

                iconColor: kPureWhiteColor,
                border:
                //InputBorder.none,
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                // shadowColor: Colors.green,
                // shadowRadius: 5,
                // shadowOffset: Offset(0, 2),
              ),

              // Clear the text field when the user submits the text
              onSubmitted: (value) async {

                message = value;
                final prefs = await SharedPreferences.getInstance();
                if (prefs.getBool(kNutriAi) == true){
                  if (message != '') {
                    lastQuestion = message;
                    serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                    if (message.length > 20) {
                      print("$message : ${message.length}");
                      aiResponseLength = 200;
                    } else {
                      print("$message : ${message.length}");
                      aiResponseLength = 30;
                    }
                    // Provider.of<BlenditData>(context, listen: false).changeLastQuestion(lastQuestion);
                    uploadData();
                    _textFieldController.clear();
                  }
                }else{

                  showModalBottomSheet(
                      context: context,
                      // isScrollControlled: true,
                      builder: (context) {
                        return NutriPayment();
                      });

                }

              },
              onChanged: (value) {

                message = value;
                // Store the text input in a variable
                // _inputText = value;
              },
            ),
            Positioned(
              right: 2,
              // bottom: 2,
              top: 5,
              child: IconButton(

                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  print("MUUUUULOOOOOKOOOONYIIIIIII ${prefs.getBool(kNutriAi)}");

                  if (prefs.getBool(kNutriAi) == true){
                    if(message != ''){

                      lastQuestion = message;

                      // Provider.of<BlenditData>(context, listen: false).changeLastQuestion(lastQuestion);
                      serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                      uploadData();
                      _textFieldController.clear();
                      //}



                    }
                  } else {



                  }



                }, icon:  DescribedFeatureOverlay(
                  openDuration: Duration(seconds: 1),
                  overflowMode: OverflowMode.extendBackground,
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  pulseDuration: Duration(seconds: 1),
                  title: Text('Have a Question? Ask Lisa'),
                  description: Text('Whether you want a recipe to your favourite salad or the nutritional value of what you are having for lunch. Talk to Nutri Lisa', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                  contentLocation: ContentLocation.above,
                  backgroundColor: Colors.black,
                  targetColor: Colors.green,
                  featureId: 'feature2',
                  tapTarget: const Icon(Icons.send, color: kPureWhiteColor,),



                  child: Icon(Icons.send, color: kGreenThemeColor,)),
              ),
            ),
          ],
        ),
      ),
    );
  }



  return Scaffold(
      backgroundColor: kGreyLightThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kGreyLightThemeColor,

        title: Row(
          children: [
            Container(
                height: 35,
                child: InkWell(
                  onTap: () {
                    setState(() {

                      nutriVisibility = !nutriVisibility;
                      chatBubbleVisibility = nutriVisibility;
                    });
                  },
                  child: ClipOval(

                      child: Image.asset('images/bot.png', fit: BoxFit.contain,)),
                )),
            kSmallWidthSpacing,


            Text('Nutri Lisa', style: kNormalTextStyle.copyWith(color: kBlack),),
          ],
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.info, color:kGreenThemeColor,),
          //   onPressed: () {
          //
          //   },
          // ),
          // kSmallWidthSpacing,
          IconButton(
            icon: Icon(LineIcons.cog, color: kGreenThemeColor,),
            onPressed: () {
              Navigator.pushNamed(context, NewSettingsPage.id);
            },
          ),
          kSmallWidthSpacing,
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //
      //   CommonFunctions().scheduledNotification(heading: "Nice", body: "Test", year: 2023, month: 1, day: 24, hour: 23, minutes: 56, id: 10);
      // },
      //
      // ),


      body:

      Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot> (
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .where('userId', isEqualTo: phone)
                      .orderBy('time',descending: true)
                      .snapshots(),
                  builder: (context, snapshot)
                  {
                    if(!snapshot.hasData){
                      return Container();
                    }
                    else{
                      messageList = [];
                      messageStatusList = [];
                      manualList = [];

                      responseList = [];
                      idList = [];
                      dateList = [];
                      statusList = [];
                      paidStatusListColor = [];
                      opacityList = [];



                      var orders = snapshot.data?.docs;
                      for( var doc in orders!){


                        messageList.add(doc['message']);
                        manualList.add(doc['manual']);

                        responseList.add(doc['response']);
                        idList.add(doc['id']);
                        messageStatusList.add(doc['status']);
                        dateList.add(doc['time'].toDate());


                        if (doc['replied'] == true){
                          statusList.add(Icon(LineIcons.doubleCheck, size: 15,color: kGreenThemeColor,));
                          paidStatusListColor.add(Colors.blue);
                          opacityList.add(0.0);

                        } else {
                          statusList.add(Icon(LineIcons.check, size: 15,color: kFaintGrey,));
                          paidStatusListColor.add(Colors.grey);
                          opacityList.add(1.0);
                        }
                        // print(responseList.last);


                      }
                      // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
                      return  messageList.length == 0? Padding(padding: const EdgeInsets.all(20),
                        child:
                        Container(
                          // height: 150,
                          width: double.infinity,
                          child: Column(
                            children: [
                              // Spacer(),

                              // Text(
                              // 'No Chat Yet', textAlign: TextAlign.center,
                              // style: kHeading2TextStyleBold,),
                              //Expanded(child: Lottie.asset('images/robot.json', height: 300, width: 300,)),
                              Expanded(child: Stack(
                                children: [
                                  DescribedFeatureOverlay(
                                      openDuration: Duration(seconds: 1),
                                      overflowMode: OverflowMode.extendBackground,
                                      enablePulsingAnimation: true,
                                      barrierDismissible: false,
                                      pulseDuration: Duration(seconds: 1),
                                      title: Text('Your personal Nutritionist 24/7', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 20),),
                                      description: Text('Nutri is an Artificial Intelligence powered assistant that learns your personal nutritional attributes as you interact with her.', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                                      contentLocation: ContentLocation.above,
                                      backgroundColor: kGreenThemeColor,
                                      targetColor: kBlueDarkColor,
                                      featureId: 'feature1',
                                      tapTarget: Lottie.asset('images/lisa.json', height: 100, width: 100,),



                                      child: Lottie.asset('images/lisa.json', height: 300, width: 300,)),
                                  Positioned(
                                      top: 0,
                                      left: 0,

                                      child: Card(

                                        // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                        shadowColor: kGreenThemeColor,
                                        color: kBlueDarkColorOld,
                                        elevation: 2.0,
                                        child: Container(
                                          width: 260,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text( 'Hi there, $name?, I am Lisa',textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 14, color: kPureWhiteColor)),
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              )),

                              // Spacer()
                            ],
                          ),),) :
                      Padding(
                             padding: const EdgeInsets.only(bottom: 110.0),
                            child:  ListView.builder(
                            itemCount: messageList.length,
                            reverse: true,
                            itemBuilder: (context, index){
                              return
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          manualList[index] == true? Container():
                                      Card(

                                        // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                        shadowColor: kGreenThemeColor,
                                        // color: kBeigeColor,
                                        elevation: 2.0,
                                        child: Container(
                                          width: 260,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [

                                                    Text( '${DateFormat('EE, dd - HH:mm').format(dateList[index])}',textAlign: TextAlign.left,
                                                        style: kNormalTextStyle.copyWith(fontSize: 10, color: kFaintGrey)
                                                    ),
                                                    kSmallWidthSpacing,
                                                    statusList[index]
                                                  ],
                                                ),
                                                Text( "${messageList[index]}",textAlign: TextAlign.left,
                                                    style: kNormalTextStyle2.copyWith(fontSize: 15, color: kBlueDarkColor)
                                                ),





                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    kSmallHeightSpacing,
                                    responseList[index] == ''? Center(child: Lottie.asset('images/assistant.json', width: 50)) :Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 25,
                                              child: ClipOval(

                                                  child: Image.asset('images/bot.png', fit: BoxFit.contain,))),
                                          Stack(
                                            children: [
                                              Card(
                                                  color: manualList[index] == false ? kCustomColor: kBlueDarkColor,
                                                  shadowColor: kPureWhiteColor,

                                                  elevation: 4,
                                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),


                                                  child: Padding(
                                                    padding: const EdgeInsets.all(18.0),
                                                    child: Container(
                                                        width: 260,
                                                        child: Text('${responseList[index]}',textAlign: TextAlign.left,
                                                         style: kNormalTextStyle2.copyWith(color: manualList[index] == false ? kBlack: kPureWhiteColor,
                                                             fontSize: 15, fontWeight: FontWeight.w400),
                                                          )
                                                    ),
                                                  )),
                                              Positioned(
                                                top: 20,
                                                right: 20,
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: paidStatusListColor[index],
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: GestureDetector(
                                                      onTap: (){

                                                        Share.share('${responseList[index]}', subject: 'Check this out from Nutri');

                                                      },

                                                      child: Icon(LineIcons.alternateShare, size: 15,color: kPureWhiteColor,)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );}
                        ),
                      );
                    }

                  }

              ),
            ),
            LowerTextForm(),
            Positioned(
              bottom: 160,
                right: 10,

                child: GestureDetector(
                    onTap: (){
                      setState(() {
                        chatBubbleVisibility = !chatBubbleVisibility;
                      });
                    },


                    child:
                    nutriVisibility == true? Container():
                    Lottie.asset('images/lisa.json', height: 100, width: 100,))),
            Positioned(
              bottom: 240,
                right: 70,

                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      chatBubbleVisibility = !chatBubbleVisibility;
                    });

                  },
                    child: chatBubbleVisibility == true? Container(): Card(

                      // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      shadowColor: kGreenThemeColor,
                       color: kBlueDarkColorOld,
                      elevation: 2.0,
                      child: Container(
                        width: 260,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text( about[random.nextInt(about.length)],textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 14, color: kPureWhiteColor)),
                        ),
                      ),
                    ),

                )
            ),

          ])
  );
  }


}



