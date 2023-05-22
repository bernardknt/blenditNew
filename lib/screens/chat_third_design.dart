

import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/paywall_international.dart';
import 'package:blendit_2022/screens/paywall_uganda.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../models/blendit_data.dart';
import 'delivery_page.dart';
import 'goals.dart';
import 'loading_goals_page.dart';
import 'new_settings.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart' as auth;

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
  var userIdentifier = '';
  var description = '';
  var instructions = [];
  var nutritionPoints = [];
  var name = '';
  var token = '';
  var question = '';
  String initialId = 'feature';
  Random random = Random();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  bool isAfricanCountry(String countryName) {
    List africanCountries = Provider.of<AiProvider>(context, listen: false).countries;

    return africanCountries.contains(countryName);
  }


  final TextEditingController _textFieldController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  Future<void> deleteUnrepliedChats() async {
    final QuerySnapshot unrepliedChats = await FirebaseFirestore.instance
        .collection('chat')
        .where('replied', isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    unrepliedChats.docs.forEach((doc) => batch.delete(doc.reference));
    await batch.commit();
  }


  Future progressStream()async{

    var start = FirebaseFirestore.instance.collection('users').where('token', isEqualTo: token).snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        Provider.of<AiProvider>(context, listen: false).setDailyProgressPoints(doc["token"]);
        print(doc["email"]);


      });
    });

    return start;
  }

  // void createCalendarEvent() async {
  //   // Authenticate with Google using OAuth2 credentials
  //   var credentials = await auth.clientViaUserConsent(
  //     clientCredentials, // Your client credentials obtained from Google Cloud Console
  //     calendar.scopes,
  //     prompt,
  //   );
  //
  //   // Create a new Calendar API client
  //   var calendarApi = calendar.CalendarApi(credentials);
  //
  //   // Define the event details
  //   var event = calendar.Event();
  //   event.summary = 'My Event';
  //   event.start = calendar.EventDateTime()..dateTime = DateTime.now();
  //   event.end = calendar.EventDateTime()
  //     ..dateTime = DateTime.now().add(Duration(hours: 1));
  //
  //   // Insert the event into the user's primary calendar
  //   var calendarId = 'primary'; // Use 'primary' for the primary calendar
  //   await calendarApi.events.insert(event, calendarId);
  // }


  Future<void> _deleteUnrepliedChats() async {
    await deleteUnrepliedChats();
    print('Unreplied chats deleted successfully');
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

  void subscribeToTopic(topicNumber)async{
    var topic = removeFirstCharacter(topicNumber);
    await FirebaseMessaging.instance.subscribeToTopic(topic).then((value) =>
    print('Succefully Subscribed to $topic')
    );
  }
  // THIS IS FOR THE INITIAL TUTORIAL WALK THROUGH AND SHOW
  void tutorialShow ()async{
    final prefs = await SharedPreferences.getInstance();
    tutorialDone =prefs.getBool(kIsTutorial1Done) ?? false;

    if (tutorialDone == false){
      initialId = 'feature1';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FeatureDiscovery.discoverFeatures(context,
            <String>['feature1','feature2','feature3' ]);
           // <String>['feature1','feature2', 'feature3', 'feature4', 'feature5']);
      });
    }else{
      // print("Tutorial $tutorialDone}");
    }
    prefs.setBool(kIsTutorial1Done, true);
  }

// This code Fetches the products from the products list




// CALLABLE FUNCTIONS FOR THE NODEJS SERVER (FIREBASE)
  final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('updateUserVision');
  CollectionReference trends = FirebaseFirestore.instance.collection('photoUpLoads');

  Future<void> removeBlankSpaces() async {
    // Get a reference to the "conditions" collection
    final CollectionReference conditionsCollection = FirebaseFirestore.instance.collection('chat');

    // Get all the documents in the collection
    final QuerySnapshot querySnapshot = await conditionsCollection.get();
    // Loop through each document and update the fields
    for (final QueryDocumentSnapshot document in querySnapshot.docs) {
      // Update the "photoTwo" field to false
      // if (document[''])
      await document.reference.update({
        'breathingRate': false,
      });
    }
  }

  // This Function separates the response received into a JSON object and text allowing us to use the JSON to manipulate more date
  void separateJsonAndText(String input, String id) async{
    int startIndex = input.indexOf('{');
    int endIndex = input.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1) {
      String textFull = input.substring(0, startIndex);
      String textJson = input.substring(startIndex, endIndex + 1);
      instructions.add(textJson);
      responseList.add(textFull);


    } else {
      // print('No JSON found in the input string.');

      if (input.contains('Nutriup')) {
        String modifiedText = input.replaceAll('Nutriup', '❤️');
        responseList.add(modifiedText);
        print(responseList.indexOf(modifiedText));


      }else {
        responseList.add(input);
        instructions.add(null);
      }


    }
  }



  void searchForPhrase(String text, String docId) async{
    final chatRef = FirebaseFirestore.instance.collection('chat').doc(docId);
    var possibleResponses = ['Wow, you know what $name, am not sure how to respond to that', 'It depends', 'Let me think about that for a moment $name' ];
    final random = Random();
    final randomIndex = random.nextInt(possibleResponses.length);
    final randomWord = possibleResponses[randomIndex];
    if (text.toLowerCase().contains("ai language model") || text.toLowerCase().contains("language model") || text.toLowerCase().contains("computer") ) {
      print("Error detected: $text");
      // randomly generate a value from the array possibleResponses
      await chatRef.update({'response': randomWord});
    }
  }


  Future<void> uploadData() async {
    var finalQuestion = lastQuestion;
    final prefs = await SharedPreferences.getInstance();
    int? previousNutriCount = prefs.getInt(kNutriCount);
    var messageCount = prefs.getInt(kMessageCount);

    return chat.doc(serviceId)
        .set({
      'replied': false,
      'status' : true,
      'time':  DateTime.now(),
      'message': message,
      'response': '',
      'userId': prefs.getString(kUniqueIdentifier),
      'weight': prefs.getDouble(kUserWeight),
      'height': prefs.getInt(kUserHeight),
      'name': prefs.getString(kFullNameConstant),
      'token': prefs.getString(kToken),
      'id':serviceId,
      'history': lastInformationList,
      'length': aiResponseLength,
      'lastQuestion': Provider.of<BlenditData>(context, listen: false).lastQuestion,
      'manual': false,
      'photo': false,
      'country': prefs.getString(kUserCountryName),
      'birthday': prefs.getString(kUserBirthday),
      'preferences': prefs.getString(kUserPersonalPreferences),
      "image": "",
      'agent': false,
      'visible': true,
      'replyTime': DateTime.now(),
      "agentName": "",
      "admins":  Provider.of<AiProvider>(context, listen: false).adminsOnDuty
    })
        .then((value){
      Provider.of<BlenditData>(context, listen: false).changeLastQuestion(finalQuestion);
      prefs.setInt(kNutriCount, (previousNutriCount! + 1));
      users.doc(auth.currentUser!.uid).update({

        "articleCount": messageCount,

      });

    } )
        .catchError((error) => print(error));
  }

  double progressValue = 0.0;

  void increaseProgress() {
    setState(() {
      progressValue += 0.1;
      if (progressValue > 1.0) {
        progressValue = 1.0;
      }
    });
  }


  bool updateMe = true;
  bool isAfrican = true;


  void increaseValueAndUploadToFirestore() async {
    final prefs = await SharedPreferences.getInstance();
    var messageCount = prefs.getInt(kMessageCount) ?? 0;
    print("KOKOKOKOKO $messageCount");

    if (messageCount < 10) {
      prefs.setInt(kMessageCount,messageCount+1);

    } else if (prefs.getInt(kMessageCount)! == 10){
    }else{
      prefs.setInt(kMessageCount,messageCount+1);
    }
  }

  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    userIdentifier =  prefs.getString(kUniqueIdentifier)?? "";
    name = prefs.getString(kFirstNameConstant)!;
    token = prefs.getString(kToken)!;
    isAfrican = isAfricanCountry(prefs.getString(kUserCountryName)!);


    CommonFunctions().userStream(context);
    setState(() {
      updateMe =  Provider.of<BlenditData>(context, listen: false).updateApp;
    });

  }

  void getLastInformation() async{
    final prefs = await SharedPreferences.getInstance();
    if (messageList.length < 4){

      // List lastMessageValues = messageList.sublist(messageList.length - (messageList.length - 1));
      // List lastResponseValues = responseList.sublist(responseList.length  - (messageList.length - 1));
       lastInformationList.clear();
      // lastInformationList.add({"role": "system", "content": "Imagine you are a real nutritionist from ${prefs.getString(kUserCountryName)}, always happy, called Lisa answering "+name+" from "+ prefs.getString(kUserCountryName)! +", "+prefs.getDouble(kUserWeight).toString()!+" kilograms and "+prefs.getInt(kUserHeight).toString()+"cm tall. Be precise and brief in your answers"});
      for (int i = 0; i < messageList.length; i++) {
        var userInfo = {"role": "user" , "content": messageList[i]};
        var assistantInfo = {"role": "assistant", "content": responseList[i]};
        lastInformationList.add(userInfo);
        lastInformationList.add(assistantInfo);
      }
    }else {
      // List lastMessageValues = messageList.sublist(messageList.length - 3);
      // List lastResponseValues = responseList.sublist(responseList.length  - 3);
      lastInformationList.clear();
      // lastInformationList.add({"role": "system", "content": "Imagine you are a real nutritionist from ${prefs.getString(kUserCountryName)}, always happy, called Lisa answering "+name+" from "+ prefs.getString(kUserCountryName)! +", "+prefs.getDouble(kUserWeight).toString()!+" kilograms and "+prefs.getInt(kUserHeight).toString()+"cm tall. Be precise and brief in your answers"});
      for (int i = 0; i < 3; i++) {
        var userInfo = {"role": "user" , "content": messageList[i]};
        var assistantInfo = {"role": "assistant", "content": responseList[i]};
        lastInformationList.add(userInfo);
        lastInformationList.add(assistantInfo);
      }
    }

    print(lastInformationList);

    setState(() {

    });
    uploadData();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    progressStream();
    tutorialShow();
    final newVersion = NewVersion(
      iOSId: 'com.frutsexpress.blendit2022',
      androidId: 'com.frutsexpress.blendit_2022',
    );
    // advancedStatusCheck(newVersion);

  }

  void searchForWordNutriup(String text) {
    if (text.toLowerCase().contains('nutriup')) {
      print('Detected');
    }
  }

  updatePersonalInformationWithGoal()async {
    final auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'goal': prefs.getString(kGoalConstant),

        });
    print("PEERRRRRFEEECTLY UPDATED");
  }

  var messageList = [];
  var messageStatusList = [];
  var lastInformationList = [];
  var chatBubbleVisibility = true;
  var nutriVisibility = true;
  var aiResponseLength = 200;
  var responseList = [];
  var manualList = [];
  var photoList = [];
  var photoImage = [];
  var manualListText = [];
  // var visibleList = [];
  var idList = [];
  var dateList = [];
  var statusList = [];
  var paidStatusListColor = [];
  var message = '';
  // String serviceId = '';
  String serviceId = 'pic${uuid.v1().split("-")[0]}';
  var lastQuestion = '';
  List<double> opacityList = [];
  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {


  Positioned LowerTextForm() {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:

        Row(
          children: [
            Expanded(
              flex:7,
              child: Stack(
                children: [

                  TextField(
                    controller: _textFieldController,  // _textFieldController is a TextEditingController object
                    maxLines: null,
                    // maxLength: 200,
                    clipBehavior: Clip.antiAlias,
                    // keyboardType: TextInputType.multiline,
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

                        if (message != '') {
                          increaseValueAndUploadToFirestore();
                          lastQuestion = message;
                          serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                          print(message.length);
                          if (message.length > 20) {
                            print(" HUHUHUHUH $message : ${message.length}");
                            aiResponseLength = 200;
                          } else {
                            print(" HUHUHUHUH $message : ${message.length}");
                            print("$message : ${message.length}");
                            aiResponseLength = 200;

                          }
                          // Provider.of<BlenditData>(context, listen: false).changeLastQuestion(lastQuestion);
                          uploadData();
                          _textFieldController.clear();
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
                        DateTime subscriptionDate = Provider.of<AiProvider>(context, listen: false).subscriptionDate;
                        DateTime today = DateTime.now();



                        if (subscriptionDate.isAfter(today)){

                          if (message != '') {

                            increaseValueAndUploadToFirestore();
                            lastQuestion = message;
                            serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                            print(message.length);
                            if (message.length > 20) {
                              print(" Long Response $message : ${message.length}");
                              // print(messageValues);
                              aiResponseLength = 200;
                            } else {
                              print(" Short Response $message : ${message.length}");
                              print("$message : ${message.length}");
                              // print(messageValues);

                              aiResponseLength = 100;
                            }
                            // Provider.of<BlenditData>(context, listen: false).changeLastQuestion(lastQuestion);
                            // _focusNode.unfocus();
                            getLastInformation();
                            _textFieldController.clear();
                          }
                        } else {

                          if (prefs.getString(kUserCountryName) == "Uganda" && Provider.of<AiProvider>(context, listen: false).iosUpload == false){
                            Navigator.push(context,
                               // MaterialPageRoute(builder: (context)=> PaywallUgandaPage())
                                MaterialPageRoute(builder: (context)=> PaywallInternationalPage())
                            );
                          } else {
                            // This
                            CommonFunctions().fetchOffers().then(
                                    (value) {
                                      // We are sending a List of Offerings to the value subscriptionProducts
                                      Provider.of<AiProvider>(context, listen: false).setSubscriptionProducts(value);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=> PaywallInternationalPage())
                                      );

                                    }
                            );

                          }
                        }
                      }, icon:  DescribedFeatureOverlay(
                        openDuration: const Duration(seconds: 1),
                        overflowMode: OverflowMode.extendBackground,
                        enablePulsingAnimation: true,
                        barrierDismissible: false,
                        pulseDuration: const Duration(seconds: 1),
                        title: const Text('Have a Question? Ask Lisa'),
                        description: Text('Whether you want a recipe to your favourite salad or the nutritional value of what you are having for lunch. Talk to Nutri Lisa', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                        contentLocation: ContentLocation.above,
                        backgroundColor: Colors.black,
                        targetColor: Colors.green,
                        featureId: 'feature2',
                        tapTarget: const Icon(Icons.send, color: kPureWhiteColor,),
                        child: const Icon(Icons.send, color: kGreenThemeColor,)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () async{
                      final prefs = await SharedPreferences.getInstance();
                      DateTime subscriptionDate = Provider.of<AiProvider>(context, listen: false).subscriptionDate;
                      DateTime today = DateTime.now();

                      if (subscriptionDate.isAfter(today)){
                        CommonFunctions().pickImage(ImageSource.camera,   serviceId = 'pic${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context);

                      } else {
                        if (prefs.getString(kUserCountryName) == "Uganda" && Provider.of<AiProvider>(context, listen: false).iosUpload == false){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> PaywallUgandaPage())
                          );
                        } else {
                          CommonFunctions().fetchOffers().then(
                                  (value) {
                                // We are sending a List of Offerings to the value subscriptionProducts
                                Provider.of<AiProvider>(context, listen: false).setSubscriptionProducts(value);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> PaywallInternationalPage())
                                );

                              }
                          );

                        }
                      }
                    },


                    child: DescribedFeatureOverlay(
                      openDuration: const Duration(seconds: 1),
                      overflowMode: OverflowMode.extendBackground,
                      enablePulsingAnimation: true,
                      barrierDismissible: false,
                      pulseDuration: const Duration(seconds: 1),
                      title: const Text('Take a Photo of your food or Fridge', style: TextStyle(color: kBlack),),
                      description: Text('Snap your kitchen ingredients, Meals, Grocery and ask for a meal recipe, or get the benefits. You are limited only by your imagination', style: kNormalTextStyle.copyWith(color: kBlack),),
                      contentLocation: ContentLocation.above,
                      backgroundColor: kCustomColor,
                      targetColor: kBlueDarkColor,
                      featureId: 'feature3',
                      tapTarget:
                      const Icon(Icons.linked_camera_outlined, color: kPureWhiteColor,),
                      child: CircleAvatar(
                        backgroundColor: kBlueDarkColor,
                          child:
                          Lottie.asset("images/snap.json", height: 20))
                          //Icon(Icons.linked_camera_outlined, color: kPureWhiteColor,)),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  var aiData =  Provider.of<AiProvider>(context, listen: false);

  return GestureDetector(
    onTap: () {

      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Scaffold(
        backgroundColor: kGreyLightThemeColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kGreyLightThemeColor,

          title: Row(
            children: [
              Container(
                  height: 35,
                  child: InkWell(
                    onDoubleTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      // subscribeToTopic(prefs.getString(kPhoneNumberConstant));
                      // setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>
                                // WelcomeToNutri()
                               PaywallInternationalPage()
                            // PhotoOnboarding()
                            )
                        );
                    },
                    child: ClipOval(

                        child:
                        isAfrican == true ? Image.asset('images/bot.png', fit: BoxFit.contain,):
                        Image.asset('images/nutritionist.jpg', fit: BoxFit.contain,)
                    ),
                  )),
              kSmallWidthSpacing,


              Text('Nutri Lisa', style: kNormalTextStyle.copyWith(color: kBlack),),
            ],
          ),
          centerTitle: true,
          actions: [
            // Container(
            //   height: 60,
            //   child: GestureDetector(
            //     onTap: () async{
            //       final prefs = await SharedPreferences.getInstance();
            //
            //       if (prefs.getBool(kIsGoalSet) == false ||prefs.getBool(kIsGoalSet) == null ) {
            //         print(prefs.getBool(kIsGoalSet));
            //         CoolAlert.show(
            //
            //             lottieAsset: 'images/goal.json',
            //             context: context,
            //             type: CoolAlertType.success,
            //             widget: SingleChildScrollView(
            //
            //                 child:
            //                 Column(
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: TextField(
            //                         onChanged: (enteredQuestion){
            //                           question = enteredQuestion;
            //                           // instructions = customerName;
            //                           // setState(() {
            //                           // });
            //                         },
            //                         decoration: InputDecoration(
            //                             border:
            //                             //InputBorder.none,
            //                             OutlineInputBorder(
            //                               borderRadius: BorderRadius.circular(10),
            //                               borderSide: BorderSide(color: Colors.green, width: 2),
            //                             ),
            //                             labelText: 'Goal',
            //                             labelStyle: kNormalTextStyleExtraSmall,
            //                             hintText: 'This year I want to lose 10kg',
            //                             hintStyle: kNormalTextStyle
            //                         ),
            //
            //                       ),
            //                     ),
            //                   ],
            //                 )
            //             ),
            //             text: 'What is your main goal for this year?',
            //             title: "${prefs.getString(kFirstNameConstant)}!",
            //             confirmBtnText: 'Set Goal',
            //             confirmBtnColor: Colors.green,
            //             backgroundColor: kBackgroundGreyColor,
            //             onConfirmBtnTap: () async{
            //               if (question != ""){
            //                 final prefs = await SharedPreferences.getInstance();
            //                 prefs.setString(kGoalConstant, question);
            //                 prefs.setBool(kIsGoalSet, true);
            //                 Navigator.pop(context);
            //                 prefs.setString(kUserId, auth.currentUser!.uid);
            //                 // updatePersonalInformationWithGoal();
            //                 dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{
            //                   'goal': question,
            //                   'userId':auth.currentUser!.uid,
            //                   // orderId
            //                 });
            //                 // Navigator.pushNamed(context, SuccessPageNew.id);
            //                 Navigator.push(context,
            //                     MaterialPageRoute(builder: (context)=> LoadingGoalsPage())
            //                 );
            //               } else {
            //
            //               }
            //
            //
            //
            //               setState(() {
            //
            //               });
            //             }
            //         );
            //
            //
            //
            //       }else{
            //         // Navigator.pushNamed(context, HomePage.id);
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context)=> GoalsPage())
            //         );
            //       }
            //
            //     },
            //
            //     child: SimpleCircularProgressBar(
            //       size: 20,
            //       progressStrokeWidth: 4,
            //       backStrokeWidth: 10,
            //       valueNotifier: ValueNotifier(Provider.of<AiProvider>(context, listen: false).progressPoints * 1.0),
            //     ),
            //   ),
            // ),






            // Container(
            //   width: 80,
            //   height: 20,
            //
            //   child: Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: LinearProgressIndicator(
            //       value: progressValue,
            //     ),
            //   ),
            // ),
            // IconButton(
            //   icon: Icon(Icons.info, color:kGreenThemeColor,),
            //   onPressed: () {
            //
            //   },
            // ),

            // HERE IS WHERE THE CODE FOR YOUR GOAL STARTS
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: GestureDetector(
            //     onTap: () async{
            //       final prefs = await SharedPreferences.getInstance();
            //
            //       if (prefs.getBool(kIsGoalSet) == false ||prefs.getBool(kIsGoalSet) == null ) {
            //         print(prefs.getBool(kIsGoalSet));
            //         CoolAlert.show(
            //
            //             lottieAsset: 'images/goal.json',
            //             context: context,
            //             type: CoolAlertType.success,
            //             widget: SingleChildScrollView(
            //
            //                 child:
            //                 Column(
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: TextField(
            //                         onChanged: (enteredQuestion){
            //                           question = enteredQuestion;
            //                           // instructions = customerName;
            //                           // setState(() {
            //                           // });
            //                         },
            //                         decoration: InputDecoration(
            //                             border:
            //                             //InputBorder.none,
            //                             OutlineInputBorder(
            //                               borderRadius: BorderRadius.circular(10),
            //                               borderSide: BorderSide(color: Colors.green, width: 2),
            //                             ),
            //                             labelText: 'Goal',
            //                             labelStyle: kNormalTextStyleExtraSmall,
            //                             hintText: 'This year I want to lose 10kg',
            //                             hintStyle: kNormalTextStyle
            //                         ),
            //
            //                       ),
            //                     ),
            //                   ],
            //                 )
            //             ),
            //             text: 'What is your main goal for this year?',
            //             title: "${prefs.getString(kFirstNameConstant)}!",
            //             confirmBtnText: 'Set Goal',
            //             confirmBtnColor: Colors.green,
            //             backgroundColor: kBackgroundGreyColor,
            //             onConfirmBtnTap: () async{
            //               if (question != ""){
            //                 final prefs = await SharedPreferences.getInstance();
            //                 prefs.setString(kGoalConstant, question);
            //                 prefs.setBool(kIsGoalSet, true);
            //                 Navigator.pop(context);
            //                 prefs.setString(kUserId, auth.currentUser!.uid);
            //                 // updatePersonalInformationWithGoal();
            //                 dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{
            //                   'goal': question,
            //                   'userId':auth.currentUser!.uid,
            //                   // orderId
            //                 });
            //                 // Navigator.pushNamed(context, SuccessPageNew.id);
            //                 Navigator.push(context,
            //                     MaterialPageRoute(builder: (context)=> LoadingGoalsPage())
            //                 );
            //               } else {
            //
            //               }
            //
            //
            //
            //               setState(() {
            //
            //               });
            //             }
            //         );
            //
            //
            //
            //       }else{
            //         // Navigator.pushNamed(context, HomePage.id);
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context)=> GoalsPage())
            //         );
            //       }
            //
            //     },
            //     child: Container(
            //         // height: 10,
            //       width: 100,
            //       decoration: BoxDecoration(
            //         color: kGreenThemeColor,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Center(child: Text("Your Goal", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
            //       // color: kAirPink,
            //         ),
            //   ),
            // ),
            // kSmallWidthSpacing,
            IconButton(
              icon: Icon(Icons.menu , color: kBlack,),
              onPressed: () {
                Navigator.pushNamed(context, NewSettingsPage.id);
              },
            ),
            kSmallWidthSpacing,
          ],
        ),
      //   floatingActionButton: FloatingActionButton(onPressed: ()async {
      //     // final prefs = await SharedPreferences.getInstance();
      //     //
      //     // prefs.setBool(kSetWeekGoal, false);
      //     // upLoadOrder();
      //
      //
      //
      //     // _deleteUnrepliedChats();
      //    // subscribeToTopic(prefs.getString(kPhoneNumberConstant));
      //    //  Navigator.push(context,
      //    //      MaterialPageRoute(builder: (context)=>
      //    //          QuizPage5()
      //    //      )
      //    //  );
      //     // print(messageValues.first);
      //
      //     // CommonFunctions().scheduledNotification(heading: "Nice", body: "Test", year: 2023, month: 1, day: 24, hour: 23, minutes: 56, id: 10);
      //   },
      //
      // ),
      //

        body:

        WillPopScope(
          onWillPop: () async {
            return false; // return a `Future` with false value so this route cant be popped or closed.
          },
          child: Stack(

              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .where('userId', isEqualTo: userIdentifier)
                          .where('visible', isEqualTo: true)
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
                          photoList = [];
                          photoImage = [];
                          instructions = [];
                          // visibleList = [];

                          responseList = [];
                          idList = [];
                          dateList = [];
                          statusList = [];
                          paidStatusListColor = [];
                          opacityList = [];
                          // messageValues = [];



                          var orders = snapshot.data?.docs;
                          for( var doc in orders!){
                            messageList.add(doc['message']);
                            // visibleList.add(doc['visible']);
                            manualList.add(doc['manual']);
                            photoList.add(doc['photo']);
                            photoImage.add(doc['image']);
                            // responseList.add(doc['response']);
                            idList.add(doc['id']);
                            messageStatusList.add(doc['status']);
                            dateList.add(doc['time'].toDate());
                            searchForPhrase(doc['response'], doc['id']);
                            separateJsonAndText(doc['response'], doc['id']);

                            // messageValues.add({"role": "user", "content": doc['message']});
                            // messageValues.add({"role": "assistant", "content": doc['response']});

                            // print(messageValues);

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

                                  Expanded(child: Stack(
                                    children: [
                                      DescribedFeatureOverlay(
                                          openDuration: Duration(seconds: 1),
                                          overflowMode: OverflowMode.extendBackground,
                                          enablePulsingAnimation: true,
                                          barrierDismissible: false,
                                          pulseDuration: Duration(seconds: 1),
                                          title: Text('Your personal Nutritionist 24/7', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 20),),
                                          description: Text('Hi, I am here as your personal nutritionist and accountability partner. The more we interact the better I will get to know you and help you', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
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
                                                child: Text( 'Hi $name, am glad to see you.',textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 14, color: kPureWhiteColor)),
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
                                                    kSmallHeightSpacing,
                                                    photoList[index]== false ? Container():
                                                    Container(
                                                      height: 130,
                                                      width: 150,
                                                      margin: const EdgeInsets.only(
                                                          top: 10,
                                                          right: 0,
                                                          left: 0,
                                                          bottom: 3),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(25),
                                                          // color: backgroundColor,
                                                          image: DecorationImage(
                                                            image:
                                                            // NetworkImage(image[index]),
                                                            CachedNetworkImageProvider(photoImage[index]),
                                                            //NetworkImage(images[index]),
                                                            // fit: BoxFit.cover,
                                                          )
                                                        //colours[index],
                                                      ),

                                                    ),





                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        kSmallHeightSpacing,
                                        // Lottie.asset('images/assistant.json',
                                        responseList[index] == ''?
                                        Align(
                                            alignment:  Alignment.centerLeft,
                                            child: Lottie.asset('images/incoming.json', width: 90))
                                            :Align(alignment: Alignment.centerLeft, child: Row( children: [
                                              Container(
                                                  height: 25,
                                                  child: ClipOval(

                                                      child:  isAfrican == true ? Image.asset('images/bot.png', fit: BoxFit.contain,):
                                                      Image.asset('images/nutritionist.jpg', fit: BoxFit.contain,)
                                                  )
                                              ),
                                              Stack(
                                                children: [
                                                  GestureDetector(
                                                    onLongPress: (){
                                                      Share.share('${responseList[index]}\nhttps://bit.ly/3I8sa4M', subject: 'Check this out from Nutri');
                                                     },
                                                    child: Card(
                                                        color: manualList[index] == false ? kCustomColor: kCustomColor,
                                                        shadowColor: kPureWhiteColor,

                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),


                                                        child: Padding(
                                                          padding: const EdgeInsets.all(18.0),
                                                          child: Container(
                                                              width: 260,
                                                              child: Column(
                                                                crossAxisAlignment:CrossAxisAlignment.start ,

                                                                children: [

                                                                  Text( '${DateFormat('EE, dd - HH:mm').format(dateList[index])}',textAlign: TextAlign.left,
                                                                      style: kNormalTextStyle.copyWith(fontSize: 10, color: manualList[index] == false ? kBlueDarkColorOld: kBlueDarkColor,)
                                                                  ),
                                                                  // Linkify enables links to be clickable in the text
                                                                  Linkify(
                                                                      onOpen: (link) {
                                                                        CommonFunctions().goToLink(link.url);
                                                                      },
                                                                       style: kNormalTextStyle2.copyWith(color: manualList[index] == false ? kBlack: kBlueDarkColor,
                                                                           fontSize: 15, fontWeight: FontWeight.w400),
                                                                      linkStyle: TextStyle(color: Colors.blue),
                                                                      text: responseList[index]),

                                                                ],
                                                              )
                                                          ),
                                                        )),
                                                  ),
                                                  Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: paidStatusListColor[index],
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: GestureDetector(
                                                          onTap: (){

                                                            Share.share('${responseList[index]}\nhttps://bit.ly/3I8sa4M', subject: 'Check this out from Nutri');

                                                          },

                                                          child: Icon(LineIcons.alternateShare, size: 15,color: kPureWhiteColor,)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              instructions[index]!= null? Lottie.asset("images/cook.json", height: 30, width: 30): Container()

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

                    child:

                    GestureDetector(
                        onTap: (){
                          setState(() {
                            chatBubbleVisibility = !chatBubbleVisibility;
                          });
                        },


                        child:
                        nutriVisibility == true? Container():
                        Lottie.asset('images/lisa.json', height: 100, width: 100,))
                ),
                Positioned(
                  bottom: 240,
                    right: 70,

                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Provider.of<AiProvider>(context, listen: false).setTipStatus();
                          // chatBubbleVisibility = !chatBubbleVisibility;
                        });

                      },
                        child:  Provider.of<AiProvider>(context, listen: false).tipStatus != true? Container(): Card(

                          // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          shadowColor: kGreenThemeColor,
                           color: kBlueDarkColorOld,
                          elevation: 2.0,
                          child: Container(
                            width: 260,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text("Tip of the Day 💡", style: kHeading2TextStyle.copyWith(color: kPureWhiteColor),),
                                  kLargeHeightSpacing,
                                  Text( aiData.nutriTips[random.nextInt(aiData.nutriTips.length)],textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontSize: 14, color: kPureWhiteColor)),
                                ],
                              ),
                            ),
                          ),
                        ),

                    )
                ),

              ]),
        )
    ),
  );
  }


}



