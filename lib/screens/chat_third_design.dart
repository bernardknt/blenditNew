

import 'dart:async';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/paywall_international.dart';
import 'package:blendit_2022/screens/paywall_uganda.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../controllers/settings_tab_controller.dart';
import '../models/blendit_data.dart';
import '../models/firebase_functions.dart';
import 'delivery_page.dart';
import 'goals.dart';


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
  double circularValue = 0;
  var name = '';
  var token = '';
  var question = '';
  String initialId = 'feature';
  Random random = Random();
  bool updateMe = true;
  bool isAfrican = true;

  bool isAfricanCountry(String countryName) {
    List africanCountries = Provider.of<AiProvider>(context, listen: false).countries;

    return africanCountries.contains(countryName);
  }
  final TextEditingController _textFieldController = TextEditingController();



  String removeFirstCharacter(String str) {
    if (str.length > 1) {
      String result = str.substring(1);
      return result;
    } else {
      print('Error: String is too short to remove first character.');
      return "";
    }
  }

  void updateArticleCountValues() async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('chat');

    QuerySnapshot querySnapshot = await usersCollection.get();

    // Get current date
    DateTime now = DateTime.now();
    String dateString = '0?' + now.toIso8601String();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      // Update the articleCountValues field in each document
      await documentSnapshot.reference.update({'winning': false,'pointApplication': false});
    }
  }

  void createDocument() async {
    final userId = 'OYPETtqEedch29E51tikMPbZUKD2';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
        "email": "adm3006@gmail.com",
        "firstName": "",
        "lastName": "",
        "loyalty": 1500,
        "loyaltyBefore": 0,
       " challengesActive": [],
        "challenge": false,
        "goal": "",
        "goalSet": false,
       "subscriptionEndDate": DateTime.now(),
        "subscriptionStartDate": DateTime.now(),
        "vision": "",
        "articleCount": 0,
        "articleCountValues": [],
       "aiActive": true,
        "height": 180,
        "weight": 70,
        "sex": "Female",
        "dateOfBirth": DateTime.now(),
        "preferencesId": [],
        "preferences": [],
        "phoneNumber": "",
        "country": "Uganda",
        "countryCode": "",
        "level": "Beginner",
        "token": "userTokenGoesHere",
        "creed": "",
        "trial": "Premium",
        "weekGoal": false,
        "chatPoints": [],
        "progress": [],
        "docId": userId,
        "winning":false,
        "pointApplication": false,
        "tag" :""


          });

      print('Document created successfully!');
    } catch (e) {
      print('Error creating document: $e');
    }
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

// CALLABLE FUNCTIONS FOR THE NODEJS SERVER (FIREBASE)
  final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('updateUserVision');
  CollectionReference trends = FirebaseFirestore.instance.collection('photoUpLoads');



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
        String modifiedText = input.replaceAll('Nutriup', '✨');
        responseList.add(modifiedText);
        checkForNewMessage(id);
      }else {
        responseList.add(input);
        instructions.add(null);
      }
    }
  }



  // This function takes in the the id of the chat messages and sees if they have the power up

  void checkForNewMessage( String id) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
   List <String>list = prefs.getStringList(kPointsList)!;


    if (list.contains(id)) {
      print("Yes");
    }
    else {

      list.add(id);
      prefs.setStringList(kPointsList, list);
      Timer(const Duration(milliseconds: 1000), () {
        Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pushNamed(context, ControlPage.id);
        FirebaseServerFunctions().increasePointsCount(prefs.getString(kUniqueIdentifier)!, context, id);
        // Provider.of<AiProvider>(context, listen: false).setDailyProgressPoints(10.0);



      });
      showCupertinoModalPopup(context: context, builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Lottie.asset('images/rocket.json',
            height: 200),
      ));
    }

  }

  // Function to check the prompt to use for a particular country
  bool checkArrayForString(List<String> array, String searchString) {
    return array.contains(searchString);
  }

  bool checkMapKeysContainString(map, String searchString) {

    var myMap = map;
    print(map);
    print(myMap.keys.toList());

    return checkArrayForString(myMap.keys.toList(), searchString);
      // myMap.keys.any((key) => key.contains(searchString));
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
      "admins":  Provider.of<AiProvider>(context, listen: false).adminsOnDuty,
      "prompt": prompt
    })
        .then((value){
      Provider.of<BlenditData>(context, listen: false).changeLastQuestion(finalQuestion);

    } )
        .catchError((error) => print(error));
  }



  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    userIdentifier =  prefs.getString(kUniqueIdentifier)?? "";
    name = prefs.getString(kFirstNameConstant)!;
    token = prefs.getString(kToken)!;
    isAfrican = isAfricanCountry(prefs.getString(kUserCountryName)!);
    circularValue = Provider.of<AiProvider>(context, listen: false).dailyProgressPoint;


    CommonFunctions().userStream(context);
    setState(() {
      updateMe =  Provider.of<BlenditData>(context, listen: false).updateApp;
    });

  }

  void getLastInformation() async{

    if (messageList.length < 4){
       lastInformationList.clear();
      for (int i = 0; i < messageList.length; i++) {
        var userInfo = {"role": "user" , "content": messageList[i]};
        var assistantInfo = {"role": "assistant", "content": responseList[i]};
        lastInformationList.add(userInfo);
        lastInformationList.add(assistantInfo);
      }
    }else {
      lastInformationList.clear();
      for (int i = 0; i < 3; i++) {
        var userInfo = {"role": "user" , "content": messageList[i]};
        var assistantInfo = {"role": "assistant", "content": responseList[i]};
        lastInformationList.add(userInfo);
        lastInformationList.add(assistantInfo);
      }
    }
    setState(() {

    });
    uploadData();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
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
  var pointsList = [];
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
  var prompt = '';
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
                          // increaseValueAndUploadToFirestore();
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
                    child:
                    IconButton(

                      onPressed: () async {


                        final prefs = await SharedPreferences.getInstance();
                        DateTime subscriptionDate = Provider.of<AiProvider>(context, listen: false).subscriptionDate;
                        DateTime today = DateTime.now();
                        String country = prefs.getString(kUserCountryName)!;



                        if (subscriptionDate.isAfter(today)){

                          if (message != '') {

                            // increaseValueAndUploadToFirestore();
                            lastQuestion = message;
                            serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                            prompt = "";
                            print(Provider.of<AiProvider>(context, listen: false).prompt);

                               if(checkMapKeysContainString(Provider.of<AiProvider>(context, listen: false).prompt, country )) {
                                 prompt = Provider.of<AiProvider>(context, listen: false).prompt[country];
                                 print("TATATATATATA: $prompt");
                               } else {
                                 prompt = "";
                                 print("TATATATATATA: $prompt");
                               }
                            // print(Provider.of<AiProvider>(context, listen: false).prompt);

                            if (message.length > 20) {
                              print(" Long Response $message : ${message.length}");
                              // print(messageValues);
                              aiResponseLength = 300;
                            } else {
                              print(" Short Response $message : ${message.length}");
                              print("$message : ${message.length}");

                              aiResponseLength = 200;
                            }
                            getLastInformation();
                            _textFieldController.clear();
                          }
                        } else {

                          if (prefs.getString(kUserCountryName) == "Uganda" && Provider.of<AiProvider>(context, listen: false).iosUpload == false){
                           print("MAMAMAMAMAMMIA this run");

                           CommonFunctions().fetchOffers().then((value) {
                             // We are sending a List of Offerings to the value subscriptionProducts
                             Provider.of<AiProvider>(context, listen: false).setSubscriptionProducts(value);
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (context)=> PaywallUgandaPage()));

                           });
                          } else {
                            // This
                            print("tatatatatattamia this run");
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

                          CommonFunctions().fetchOffers().then((value) {
                            // We are sending a List of Offerings to the value subscriptionProducts
                            Provider.of<AiProvider>(context, listen: false).setSubscriptionProducts(value);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> PaywallUgandaPage()));

                          });



                        } else {
                          CommonFunctions().fetchOffers().then((value) {
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
                      child: Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: CircleAvatar(
                          backgroundColor: kBlueDarkColor,
                            child:
                            Lottie.asset("images/snap.json", height: 20)),
                      )
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
        appBar:
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kGreyLightThemeColor,

          title: Row(
            children: [
              Container(
                  height: 35,
                  child: InkWell(
                    // onLongPress: (){
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context)=>
                    //          WelcomeToNutri()
                    //         // QualityBot()
                    //         // PhotoOnboarding()
                    //       )
                    //   );
                    //
                    // },
                    // onDoubleTap: () async {
                    //   final prefs = await SharedPreferences.getInstance();
                    //
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context)=>
                    //             PaywallUgandaPage()
                    //
                    //         )
                    //     );
                    // },
                    child: ClipOval(

                        child:
                        isAfrican == true ? Image.asset('images/bot.png', fit: BoxFit.contain,):
                        Image.asset('images/nutritionist.jpg', fit: BoxFit.contain,)
                    ),
                  )),
              kSmallWidthSpacing,


              Text('Lisa', style: kNormalTextStyle.copyWith(color: kBlack),),
            ],
          ),
          centerTitle: true,
          actions: [

            // StreamBuilder<QuerySnapshot> (
            //     stream: FirebaseFirestore.instance
            //         .collection('users')
            //         .where('docId', isEqualTo: userIdentifier)
            //         .snapshots(),
            //     builder: (context, snapshot)
            //     {
            //       if(!snapshot.hasData){
            //         return Container();
            //       }
            //       else{
            //         pointsList = [];
            //
            //         var orders = snapshot.data?.docs;
            //         for( var doc in orders!) {
            //           pointsList.add(doc['articleCount']??0);
            //         }
            //         // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
            //         return  SizedBox(
            //           height: 60,
            //           child: GestureDetector(
            //             onTap: () async{
            //               if (pointsList[0]<= 100) {
            //                 // Get.snackbar(
            //                 //     'Lets get those points',
            //                 //     'Take a photo doing something towards your goal, or tell Nutri about your progress to increase your points💪',
            //                 //     snackPosition: SnackPosition.TOP,
            //                 //     backgroundColor: kCustomColor,
            //                 //     colorText: kBlack,
            //                 //     icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
            //                   Navigator.push(context,
            //                       MaterialPageRoute(builder: (context)=> GoalsPage())
            //                   );
            //               } else {
            //                 Get.snackbar(
            //                     'Well Done',
            //                     "You have achieved Today's Goal 💪",
            //                     snackPosition: SnackPosition.TOP,
            //                     backgroundColor: kBlack,
            //                     colorText: kPureWhiteColor,
            //                     icon: Icon(Icons.check_circle, color: kCustomColor,));
            //               }
            //
            //
            //
            //               // final prefs = await SharedPreferences.getInstance();
            //               //
            //               // if (prefs.getBool(kIsGoalSet) == false ||prefs.getBool(kIsGoalSet) == null ) {
            //               //   print(prefs.getBool(kIsGoalSet));
            //               //   CoolAlert.show(
            //               //
            //               //       lottieAsset: 'images/goal.json',
            //               //       context: context,
            //               //       type: CoolAlertType.success,
            //               //       widget: SingleChildScrollView(
            //               //
            //               //           child:
            //               //           Column(
            //               //             children: [
            //               //               Padding(
            //               //                 padding: const EdgeInsets.all(8.0),
            //               //                 child: TextField(
            //               //                   onChanged: (enteredQuestion){
            //               //                     question = enteredQuestion;
            //               //                     // instructions = customerName;
            //               //                     // setState(() {
            //               //                     // });
            //               //                   },
            //               //                   decoration: InputDecoration(
            //               //                       border:
            //               //                       //InputBorder.none,
            //               //                       OutlineInputBorder(
            //               //                         borderRadius: BorderRadius.circular(10),
            //               //                         borderSide: BorderSide(color: Colors.green, width: 2),
            //               //                       ),
            //               //                       labelText: 'Goal',
            //               //                       labelStyle: kNormalTextStyleExtraSmall,
            //               //                       hintText: 'This year I want to lose 10kg',
            //               //                       hintStyle: kNormalTextStyle
            //               //                   ),
            //               //
            //               //                 ),
            //               //               ),
            //               //             ],
            //               //           )
            //               //       ),
            //               //       text: 'What is your main goal for this year?',
            //               //       title: "${prefs.getString(kFirstNameConstant)}!",
            //               //       confirmBtnText: 'Set Goal',
            //               //       confirmBtnColor: Colors.green,
            //               //       backgroundColor: kBackgroundGreyColor,
            //               //       onConfirmBtnTap: () async{
            //               //         if (question != ""){
            //               //           final prefs = await SharedPreferences.getInstance();
            //               //           prefs.setString(kGoalConstant, question);
            //               //           prefs.setBool(kIsGoalSet, true);
            //               //           Navigator.pop(context);
            //               //           prefs.setString(kUserId, auth.currentUser!.uid);
            //               //           // updatePersonalInformationWithGoal();
            //               //           dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{
            //               //             'goal': question,
            //               //             'userId':auth.currentUser!.uid,
            //               //             // orderId
            //               //           });
            //               //           // Navigator.pushNamed(context, SuccessPageNew.id);
            //               //           Navigator.push(context,
            //               //               MaterialPageRoute(builder: (context)=> LoadingGoalsPage())
            //               //           );
            //               //         } else {
            //               //
            //               //         }
            //               //
            //               //
            //               //
            //               //         setState(() {
            //               //
            //               //         });
            //               //       }
            //               //   );
            //               //
            //               //
            //               //
            //               // }else{
            //               //   // Navigator.pushNamed(context, HomePage.id);
            //               //   Navigator.push(context,
            //               //       MaterialPageRoute(builder: (context)=> GoalsPage())
            //               //   );
            //               // }
            //
            //             },
            //
            //
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 30.0),
            //               child: Row(
            //                 children: [
            //
            //                   Text("${pointsList[0]}/100", style: kNormalTextStyle.copyWith(color: kGreenThemeColor, fontSize: 13,),),
            //                   kSmallWidthSpacing,
            //                   kSmallWidthSpacing,
            //                   SimpleCircularProgressBar(
            //                     size: 20,
            //                     progressColors: [kGreenThemeColor, kCustomColor, Colors.blue ],
            //                     progressStrokeWidth: 4,
            //                     backStrokeWidth: 10,
            //                     // valueNotifier: ValueNotifier(Provider.of<AiProvider>(context, listen: false).progressPoints * 1.0),
            //                     valueNotifier: ValueNotifier(pointsList[0].toDouble()),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //           //Text('Hi ${pointsList}', style: kNormalTextStyle.copyWith(color: kBlack),);
            //
            //       }
            //
            //     }
            //
            // ),

            // IconButton(
            //   icon: Icon(Icons.menu , color: kBlack,),
            //   onPressed: () {
            //     Navigator.pushNamed(context, SettingsTabController.id);
            //   },
            // ),
            // kSmallWidthSpacing,
          ],
        ),
     //    floatingActionButton: FloatingActionButton(onPressed: ()async {
     //      // final prefs = await SharedPreferences.getInstance();
     //      //
     //      // prefs.setBool(kSetWeekGoal, false);
     //      // upLoadOrder();
     //
     //      // FirebaseServerFunctions().updateAllUsers();
     //      updateArticleCountValues();
     //
     //
     //
     //      // CommonFunctions().scheduledNotification(heading: "Nice", body: "Test", year: 2023, month: 1, day: 24, hour: 23, minutes: 56, id: 10);
     //    },
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
                                            color: kCustomColor,
                                            shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                            shadowColor: kFaintGrey,
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
                                                        color: manualList[index] == false ? kPureWhiteColor: kPureWhiteColor,
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
                                              // instructions[index]!= null? Lottie.asset("images/cook.json", height: 30, width: 30): Container()

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
                        child:  Provider.of<AiProvider>(context, listen: false).tipStatus == true? Container(): Card(

                          // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          // shadowColor: kGreenThemeColor,
                           color: kCustomColor,
                          elevation: 2.0,
                          child: Container(
                            width: 260,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text("Tip of the Day 💡", style: kHeading2TextStyle.copyWith(color: kBlack),),
                                  kLargeHeightSpacing,
                                  Text( aiData.nutriTips[random.nextInt(aiData.nutriTips.length)],textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontSize: 14, color: kBlack)),
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



