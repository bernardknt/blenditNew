
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/ingredientsList.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/screens/customized_juice_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';
import 'package:blendit_2022/widgets/SelectedIngredientsListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'onboarding_page.dart';


class NewBlenderPage extends StatefulWidget {
  static String id  = 'newblender';


  @override
  _NewBlenderPageState createState() => _NewBlenderPageState();
}
class _NewBlenderPageState extends State<NewBlenderPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFirstNameConstant) ?? 'Hi';
    String newFullName = prefs.getString(kFullNameConstant) ?? 'Hi';
    bool isFirstTime = prefs.getBool(kIsFirstTimeUser) ?? false;
    bool isFirstTimeBlending = prefs.getBool(kIsFirstBlending)?? true;
    setState(() {
      firstName = newName;
      Provider.of<BlenditData>(context, listen: false).setCustomerName(newFullName);
      firstBlend = isFirstTimeBlending;
    });
    if (isFirstTime == true){
      Navigator.pushNamed(context, BlenderOnboardingPage.id);
    }
  }
  // void showCaseItems (){
  //   WidgetsBinding.instance!.addPostFrameCallback((_) =>
  //       ShowCaseWidget.of(context)!.startShowCase([
  //         keyOne
  //       ])
  //   );

  // }

  void firstBlendDone()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kIsFirstBlending, false);
    firstBlend = false;
  }
  final keyOne = GlobalKey();
  final prefs =  SharedPreferences.getInstance();
  bool firstBlend = true;
  bool tutorialDone = true;
  String firstName = 'Blender';
  String initialId = 'feature';

  void tutorialShow ()async{
    final prefs = await SharedPreferences.getInstance();
    tutorialDone = prefs.getBool(kIsTutorialDone) ?? false;
    if (tutorialDone == false){
      initialId = 'feature1';
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        FeatureDiscovery.discoverFeatures(context,
            <String>['feature1','feature2', 'feature3', 'feature4', 'feature5']);
      });
    }else{
      print("Tutorial $tutorialDone}");
    }
    prefs.setBool(kIsTutorialDone, true);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // WidgetsBinding.instance!.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(context)!.startShowCase([
    //       keyOne
    //     ])
    // );
    // showCaseItems();

    deliveryStream();
    defaultsInitiation();
    tutorialShow();
    getIngredients();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode, notification.title, notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                color:Colors.purple
                ,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            )
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification!= null && android != null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(notification.title!),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text(notification.body!)
                ],
              ) ,
            ),
          );
        });
      }
    });
  }

  void showNotification(String notificationTitle, String notificationBody){
    flutterLocalNotificationsPlugin.show(0, notificationTitle, notificationBody,
        NotificationDetails(
            android: AndroidNotificationDetails(
               channel.id,
              channel.name,
              // channel.description,
              importance: Importance.high,
              color: Colors.green,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails()
        ));
  }

  Future deliveryStream()async{
    var prefs = await SharedPreferences.getInstance();

    var start = FirebaseFirestore.instance.collection('prices').snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        var twoKm = doc['twoKm'];
        var fourKm = doc['fourKm'];
        var sixKm = doc['sixKm'];
        var nineKm = doc['nineKm'];
        var longKm = doc['longKm'];
        var rewardRatio = doc['rewardRatio'];
        var support = doc['support'];
        var whatsNumber = doc['whatsapp'];
        var blender = doc['blender'];
        var heading  = doc['heading'];
        var body = doc['body'];
        var saladPrice = doc['saladPrice'];
        var saladExtrasPrice = doc['saladExtrasPrice'];
        var saladMeatPrice = doc['saladMeatPrice'];



        setState(() {

          Provider.of<BlenditData>(context, listen: false).setBlenderDefaultPrice(blender, saladPrice, saladMeatPrice, saladExtrasPrice);
          prefs.setInt(kTwoKmDistance, twoKm);
          prefs.setInt(kFourKmDistance, fourKm);
          prefs.setInt(kSixKmDistance, sixKm);
          prefs.setInt(kNineKmDistance, nineKm);
          prefs.setInt(kLongKmDistance, longKm);
          prefs.setDouble(kRewardsRatio, rewardRatio);
          prefs.setString(kSupportNumber, support);
          prefs.setString(kAboutHeading, heading);
          prefs.setString(kAboutBody, body);
          prefs.setString(kWhatsappNumber, whatsNumber);
          prefs.setInt(kBlenderBaseValue, blender);

        });
      });
    });

    return start;
  }
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Hey';
    }
    return 'Hi';
  }
  String greetingEmoji() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return '😊';
    }
    if (hour < 17) {
      return '🤗';
    }
    return '🙂';
  }
  String blenderMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Add Ingredients and Blender';
      // return 'Want to blend something Nutritious?';
    }
    if (hour < 17) {
      return 'Blend something';
    }
    return 'Blend something Nutritious?';
  }
  Future<dynamic> getIngredients() async {
    vegetables = [];
    fruits = [];
    extras = [];
    vegInfo = [];
    fruitInfo = [];
    extraInfo = [];

  final availableIngredients = await FirebaseFirestore.instance
      .collection('ingredients').orderBy('name',descending: false)
      // .where('quantity', isGreaterThan: 0)
      .get()
      .then((QuerySnapshot querySnapshot) {
  querySnapshot.docs.forEach((doc) {
    if (doc['category']== 'vegetables'){
      vegetables.add(doc['name']);
      vegInfo.add(doc['info']);


    } else if(doc['category']== 'fruits'){
      fruits.add(doc['name']);
      fruitInfo.add(doc['info']);
    } else{
      extras.add(doc['name']);
      extraInfo.add(doc['info']);
    }
  });
  });
    Provider.of<BlenditData>(context, listen: false).setJuiceLeaves(vegetables, fruits, extras);
  return availableIngredients ;
}

var formatter = NumberFormat('#,###,000');
  var vegetables= [''];
  var fruits = [''];
  var boxColours = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  var extras = [''];
  var vegInfo = [''];
  var fruitInfo = [''];
  var extraInfo = [''];

  @override
  Widget build(BuildContext context) {

    var blendedData = Provider.of<BlenditData>(context);

    var fruitProvider = Provider.of<BlenditData>(context).boxColourJuiceListFruit;
    var vegProvider = Provider.of<BlenditData>(context).boxColourJuiceListVeg;
    var extraProvider = Provider.of<BlenditData>(context).boxColourJuiceListExtra;
    return Scaffold(

      backgroundColor: kBiegeThemeColor ,
      floatingActionButton: DescribedFeatureOverlay(
        openDuration: Duration(seconds: 1),
        overflowMode: OverflowMode.extendBackground,
        enablePulsingAnimation: true,
        barrierDismissible: false,
        pulseDuration: Duration(seconds: 1),
        title: Text('Step 3: Start Blending'),
        description: Text('When you are SATISTIFIED with your recipe. Tap the Start Blending Button to save your selection, ready to be made'),
        contentLocation: ContentLocation.above,
        backgroundColor: Colors.teal,
        targetColor: Colors.yellow,
        featureId: 'feature4',
        tapTarget: const Icon(LineIcons.blender),
        child: FloatingActionButton.extended(

          backgroundColor: blendedData.blendButtonColourJuice,
          onPressed: (){

            if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
              AlertPopUpDialogueMain(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your Blender', fruitProvider: fruitProvider, extraProvider: extraProvider, blendedData: blendedData, vegProvider: vegProvider);
            }
            else {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SelectedJuiceIngredientsListView();
                  });
            }
          },
          icon: const Icon(LineIcons.blender),
          label: const Text('Start Blending'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,


      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(

              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${greeting()} $firstName ${greetingEmoji()},\n${blenderMessage()}', textAlign:TextAlign.center , style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 18
                  ),),
                  const SizedBox(height: 10,),
                  DescribedFeatureOverlay(
                    openDuration: Duration(seconds: 1),
                    overflowMode: OverflowMode.extendBackground,
                    enablePulsingAnimation: true,
                    barrierDismissible: false,
                    pulseDuration: Duration(seconds: 1),
                    title: Text('Step 1: Add Ingredients'),
                    description: Text('Tap the Add Ingredients Button and Select the ingredients you want to add to your Blender'),
                    contentLocation: ContentLocation.above,
                    backgroundColor: Colors.black,
                    targetColor: Colors.green,
                    featureId: 'feature2',
                    tapTarget: const Icon(CupertinoIcons.add),

                    child: ingredientButtons(
                      lineIconFirstButton: LineIcons.plus,
                      buttonTextColor: Colors.white,
                      buttonColor: blendedData.ingredientsButtonColour,
                        firstButtonFunction: (){
                          bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
                          if (firstBlend == true){
                           firstBlendDone();
                            AlertPopUpDialogue(context, imagePath: 'images/longpress.json', text: 'To know the Health benefits of an ingredient long press on it', title: 'Tip 2: Long Press for Benefits');
                            AlertPopUpDialogue(context, imagePath: 'images/swipe.json', text: 'To view all ingredients Swipe left and Right on each Category', title: 'Tip 1: Swipe to View');
                          }
                        }, firstButtonText: 'Add Ingredients',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child:
              Stack(children:[
                DescribedFeatureOverlay(
                  openDuration: Duration(seconds: 1),
                  overflowMode: OverflowMode.extendBackground,
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  pulseDuration: Duration(seconds: 1),
                  title: Text('Quick Tour'),
                  description: Text('Welcome $firstName 🥳. Your new Health Journey starts here. Let us show you how Blendit Works '),
                  contentLocation: ContentLocation.above,
                  backgroundColor: kBlueDarkColor,
                  targetColor: kBiegeThemeColor,
                  featureId: initialId,
                  tapTarget: Icon(CupertinoIcons.hand_thumbsup),
                  child: GestureDetector(
                      onTap: (){
                        if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
                          AlertPopUpDialogueMain(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your Blender', fruitProvider: fruitProvider, extraProvider: extraProvider, blendedData: blendedData, vegProvider: vegProvider);
                        }
                        else {
                          // Vibration.vibrate(pattern: [200, 500, 200]);

                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SelectedJuiceIngredientsListView();
                              });
                        }
                      },
                      child:DescribedFeatureOverlay(
                          openDuration: Duration(seconds: 1),
                          overflowMode: OverflowMode.extendBackground,
                          enablePulsingAnimation: true,
                          barrierDismissible: false,
                          pulseDuration: Duration(seconds: 1),
                          title: Text('Step 2: See Health Benefits '),
                          description: Text('Long Press on any ingredient to see its Health Benefits as you add it to your blender'),
                          contentLocation: ContentLocation.above,
                          backgroundColor: Colors.pink,
                          targetColor: Colors.black,
                          featureId: 'feature3',
                          tapTarget: const Icon(LineIcons.fruitApple, color: Colors.white,),
                          child: Image.asset(blendedData.blenderImage))),
                ),
                Positioned(
                  right: 30,
                  top: 15,
                  child: GestureDetector(
                    child:
                    Row(
                        children:[

                          CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.orange,
                              child: Text('${blendedData.ingredientsNumber}',style: TextStyle(color: Colors.white, fontSize: 15),)),
                          //SizedBox(width: 5,),
                          Icon(LineIcons.blender, color: Colors.black,size: 25,),

                        ] ),
                    onTap: (){
                      if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
                        AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');
                      }
                      else {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SelectedJuiceIngredientsListView();
                            });
                      }
                    },

                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qty (Litres)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          QuantityBtn(onTapFunction: (){
                            Provider.of<BlenditData>(context, listen: false).decreaseJuiceLitres();

                          }, text: '-', size: 28,),
                          const SizedBox(width: 3,),
                          Text('${blendedData.litres}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(width: 3,),
                          QuantityBtn(onTapFunction: (){
                            Provider.of<BlenditData>(context, listen: false).increaseJuiceLitres();
                          }, text: '+',size: 28),
                        ],
                      ),
                      const SizedBox(height: 10,) ,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Ugx ${formatter.format(blendedData.juicePrice)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                          const SizedBox(height: 50,),
                          DescribedFeatureOverlay(
                            openDuration: const Duration(seconds: 1),
                            overflowMode: OverflowMode.extendBackground,
                            enablePulsingAnimation: true,
                            barrierDismissible: false,
                            pulseDuration: const Duration(seconds: 1),
                            title: const Text('And Finally'),
                            description: Text('$firstName If you want something specialized. Click the SURPRISE ME button to see our Categories of unique juices for different things.\n'),
                            contentLocation: ContentLocation.trivial,
                            backgroundColor: kBlueDarkColor,
                            targetColor: kBiegeThemeColor,
                            featureId: 'feature5',
                            tapTarget: Lottie.asset('images/juiceBlender.json', width: 50),
                            child: GestureDetector
                              (onTap: (){
                              Navigator.pushNamed(context, CustomizedJuicePage.id);
                            },
                              child: Lottie.asset('images/juiceBlender.json', width: 50),

                            ),
                          ),
                          const Text('Surprise \n Me',textAlign: TextAlign.center , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),

                        ],
                      ),
                    ],
                  ),
                ),

              ] ),
            ),

          ],
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetAddIngredients(BuildContext context, List<dynamic> vegProvider, List<dynamic> fruitProvider, List<dynamic> extraProvider, BlenditData blendedData) {

    return showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            color: const Color(0xFF6e7069),
                            child:
                            Container(
                              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),color: kPinkBlenderColor,),
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                          radius: 12,
                                          child: Icon(Icons.arrow_back, size: 12, color: Colors.white,)),
                                      const SizedBox(width: 10,),
                                      Text('Selected Ingredients ${Provider.of<BlenditData>(context).ingredientsNumber}', style: TextStyle(fontWeight: FontWeight.bold),),
                                      const SizedBox(width: 10,),
                                      const CircleAvatar(
                                          radius: 12,
                                          child: Icon(Icons.arrow_forward, size: 12, color: Colors.white,)),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Text('Vegetables 🥬',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  const SizedBox(height: 10,),
                                  IngredientsList(ingredients: vegetables, boxColors: boxColours, provider: vegProvider, type: 'veggie', info: vegInfo,),
                                  const SizedBox(height: 10,),
                                  Text('Fruits 🍓',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  const SizedBox(height: 10,),
                                  IngredientsList(ingredients: fruits, boxColors: boxColours, provider: fruitProvider, type: 'fruit', info: fruitInfo,),
                                  const SizedBox(height: 10,),
                                  Text('Extras 🥑'
                                    ,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  SizedBox(height: 10,),
                                  IngredientsList(ingredients: extras, boxColors: boxColours, provider: extraProvider, type: 'extra', info: extraInfo,),
                                  SizedBox(height: 20),
                                ingredientButtons(buttonTextColor: Colors.white, buttonColor: Colors.green, buttonTextSize: 12, lineIconFirstButton: LineIcons.thumbsUp, firstButtonFunction: (){Navigator.pop(context); }, firstButtonText: 'Done (Ugx${formatter.format(blendedData.juicePrice)})')],
                              ),
                            ),
                          );
                        });

  }

  Future<dynamic> AlertPopUpDialogue(BuildContext context,
      {required String imagePath, required String text, required String title}) {

    return CoolAlert.show(
              lottieAsset: imagePath,
              context: context,
              type: CoolAlertType.success,
              text: text,
              title: title,
              confirmBtnText: 'Ok',
              confirmBtnColor: Colors.green,
              backgroundColor: kBlueDarkColor,
          );
  }

  Future<dynamic> AlertPopUpDialogueMain(BuildContext context,
      {required String imagePath, required String text, required String title,
        required vegProvider, required fruitProvider, required extraProvider, required blendedData
      }) {
    return CoolAlert.show(
        lottieAsset: imagePath,
        context: context,
        type: CoolAlertType.success,
        text: text,
        title: title,
        confirmBtnText: 'Add',
        cancelBtnText: 'Cancel',
        showCancelBtn: true,
        confirmBtnColor: Colors.green,
        backgroundColor: kBlueDarkColor,
        onConfirmBtnTap: (){
          Navigator.pop(context);
          bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
        }
    );
  }
}

