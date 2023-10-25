
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/ingredientsList.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/screens/customized_juice_page.dart';
import 'package:blendit_2022/screens/goals.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:blendit_2022/screens/special_blend.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../controllers/orders_controller_page.dart';
import '../main.dart';
import '../models/responsive/dimensions.dart';
import '../models/responsive/responsive_layout.dart';
import '../utilities/font_constants.dart';
import 'checkout_page.dart';
import 'choose_juice_page.dart';
import 'execution_pages/wildly_important_goal.dart';
import 'loading_goals_page.dart';
import 'onboarding_page.dart';


class NewBlenderPage extends StatefulWidget {
  static String id  = 'newblender';


  @override
  _NewBlenderPageState createState() => _NewBlenderPageState();
}
class _NewBlenderPageState extends State<NewBlenderPage> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // DEFAULT INITIALIZATIONS
  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFirstNameConstant) ?? 'Hi';
    String newEmail = prefs.getString(kEmailConstant) ?? 'Hi';

    String newFullName = prefs.getString(kFullNameConstant) ?? 'Hi';
    bool isFirstTime = prefs.getBool(kIsFirstTimeUser) ?? false;
    bool isFirstTimeBlending = prefs.getBool(kIsFirstBlending)?? true;
    setState(() {
      firstName = newName;
      email = newEmail;
      Provider.of<BlenditData>(context, listen: false).setCustomerName(newFullName);
      updateMe =  Provider.of<BlenditData>(context, listen: false).updateApp;
      firstBlend = isFirstTimeBlending;
    });
    if (isFirstTime == true){
      // Navigator.pushNamed(context, BlenderOnboardingPage.id);
    }
  }

// THIS IS USED TO CHECK THE CURRENT APP VERSION AND ENCOURAGE THE USER TO UPDATE
  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();

    if (status?.canUpdate == true && updateMe == true) {

      newVersion.showUpdateDialog(
        dismissAction: (){
          Navigator.pop(context);
          Provider.of<BlenditData>(context, listen: false).setAppUpdateStatus();
        },

        updateButtonText: 'Update Now',
        context: context,
        versionStatus: status!,
        dialogTitle: 'App Update 🎉',
        dialogText: 'We are excited to announce that Some awesome new features have been released. Upgrade from version ${status.localVersion} to ${status.storeVersion} to get the best experience',

      );
    }
  }
  void firstBlendDone()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kIsFirstBlending, false);
    firstBlend = false;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }


// THIS IS FOR THE INITIAL TUTORIAL WALK THROUGH AND SHOW
  void tutorialShow ()async{
    final prefs = await SharedPreferences.getInstance();
    tutorialDone = prefs.getBool(kIsTutorial2Done) ?? false;
    if (tutorialDone== false){
      initialId = 'feature1';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FeatureDiscovery.discoverFeatures(context,
            <String>['feature1','feature2', 'feature3', 'feature4', 'feature5']);
      });
    }else{
      print("Tutorial $tutorialDone}");
    }
    prefs.setBool(kIsTutorial2Done, true);
  }
  // SHOW FLUTTER NOTIFICATIONS

  // GET APP DATA FROM THE SERVER
  Future deliveryStream()async{
    var prefs = await SharedPreferences.getInstance();

    var start = FirebaseFirestore.instance.collection('prices').snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        var open = doc['open'];
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
        var shareUrl = doc['shareUrl'];
        var discount = doc['discount'];

        setState(() {
          Provider.of<BlenditData>(context, listen: false).setBlenderDefaultPrice(blender, saladPrice, saladMeatPrice, saladExtrasPrice);
          Provider.of<BlenditData>(context, listen: false).setNewShareUrl(shareUrl);
          Provider.of<BlenditData>(context, listen: false).setStoreOpen(open);
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
          prefs.setDouble(kDiscountPercentage, discount);


        });
      });
    });

    return start;
  }
 // BEGINNING OF BLENDER GREETING FUNCTIONS
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
      return 'Add Ingredients to your Blender';
      // return 'Want to blend something Nutritious?';
    }
    if (hour < 17) {
      return 'Blend something';
    }
    return 'Blend something Nutritious?';
  }
  // END OF BLENDER GREETING FUNCTIONS
  // GET BLENDER INGREDIENTS
  Future<dynamic> getIngredients() async {
    vegetables = [];
    fruits = [];
    extras = [];
    vegInfo = [];
    fruitInfo = [];
    extraInfo = [];

  final availableIngredients = await FirebaseFirestore.instance
      .collection('ingredients').orderBy('name',descending: false)
      .get()
      .then((QuerySnapshot querySnapshot) {
  querySnapshot.docs.forEach((doc) {
    if (doc['category']== 'vegetables'){
      if (doc['quantity'] >= 1){
        vegetables.add(doc['name']);
        vegInfo.add(doc['info']);
      }
    } else if(doc['category']== 'fruits'){
      if (doc['quantity'] >= 1){
        fruits.add(doc['name']);
        fruitInfo.add(doc['info']);
      }

    } else{
      if (doc['quantity'] >= 1){
        extras.add(doc['name']);
        extraInfo.add(doc['info']);
      }
    }
  });
  extras = extras.reversed.toList();
  extraInfo = extraInfo.reversed.toList();
  vegetables = vegetables.reversed.toList();
  vegInfo = vegInfo.reversed.toList();
  fruits = fruits.reversed.toList();
  fruitInfo = fruitInfo.reversed.toList();


  });
    Provider.of<BlenditData>(context, listen: false).setJuiceLeaves(vegetables, fruits, extras);
  return availableIngredients ;
}

// VARIABLE DECLARATIONS
  bool firstBlend = true;
  bool activeOrder = false;
  bool tutorialDone = true;
  String firstName = 'Blender';
  String email = 'Blender';
  String initialId = 'feature';
  var dateList = [];
  var statusList = [];
  var typeList = [];
  bool updateMe = true;
  String updateInfo = "There is a new update..";
  var formatter = NumberFormat('#,###,000');
  var vegetables= [''];
  var fruits = [''];
  var boxColours = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  var extras = [''];
  var vegInfo = [''];
  var fruitInfo = [''];
  var extraInfo = [''];




   // BEGINNING OF INIT OVERRIDE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryStream();
    defaultsInitiation();
    tutorialShow();
    getIngredients();
    FirebaseMessaging.instance.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        provisional: true
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      print('ZAKARABUS ${message.data['type']}');

      if (message.data['type'] == 'promotion') {
        Provider.of<BlenditData>(context, listen: false).setTabIndex(1);
        // Navigator.pushNamed(context, ControlPage.id);
        Navigator.pushNamed(context, ResponsiveLayout.id);


      } else if (message.data['type'] == 'blog') {
        Provider.of<BlenditData>(context, listen: false).setTabIndex(3);
        // Navigator.pushNamed(context, ControlPage.id);
        Navigator.pushNamed(context, ResponsiveLayout.id);
      }else if(message.data['type'] == 'accounts'){
        Provider.of<BlenditData>(context, listen: false).setTabIndex(2);
        // Navigator.pushNamed(context, ControlPage.id);
        Navigator.pushNamed(context, ResponsiveLayout.id);
      }else {

      }
    });

    final newVersion = NewVersion(
      iOSId: 'com.frutsexpress.blendit2022',
      androidId: 'com.frutsexpress.blendit_2022',
    );
    advancedStatusCheck(newVersion);
  }

  // END OF INIT OVERRIDE

  @override
  Widget build(BuildContext context) {

    var blendedData = Provider.of<BlenditData>(context);

    var fruitProvider = Provider.of<BlenditData>(context).boxColourJuiceListFruit;
    var vegProvider = Provider.of<BlenditData>(context).boxColourJuiceListVeg;
    var extraProvider = Provider.of<BlenditData>(context).boxColourJuiceListExtra;
    return Scaffold(

      backgroundColor: kPureWhiteColor,
      // kBiegeThemeColor ,
      floatingActionButton: DescribedFeatureOverlay(
        openDuration: const Duration(seconds: 1),
        overflowMode: OverflowMode.extendBackground,
        enablePulsingAnimation: true,
        barrierDismissible: false,
        pulseDuration: const Duration(seconds: 1),
        title: const Text('Use Recipe Or Place an Order'),
        description: const Text('Follow the Recipe but If you cant make it yourself, we shall make it and deliver to you.', style: TextStyle(fontSize: 16),),
        contentLocation: ContentLocation.above,
        backgroundColor: Colors.teal,
        targetColor: Colors.yellow,
        featureId: 'feature4',
        tapTarget: const Icon(LineIcons.blender),
        child:Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0? Container():
        FloatingActionButton.extended(

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
          label: Provider.of<BlenditData>(context, listen: false).ingredientsNumber != 0?const Text('Start Blending'): Text('Add Ingredients To Blender'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,


      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // width: 200,
              //MediaQuery.of(context).size.width >mobileWidth? 200 : MediaQuery.of(context).size.width,

              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${greeting()} $firstName ${greetingEmoji()}'
                     // '\n${blenderMessage()}'
                    , textAlign:TextAlign.center , style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 18
                  ),),
                  const SizedBox(height: 10,),
                  DescribedFeatureOverlay(
                    openDuration: Duration(seconds: 1),
                    overflowMode: OverflowMode.extendBackground,
                    enablePulsingAnimation: true,
                    barrierDismissible: true,
                    pulseDuration: Duration(seconds: 1),
                    title: Text('Personalized Natural Remedies'),
                    description: Text('Blendit allows you to get the perfect recipe to help you sort whatever you need. Simply Tap on the blender.', style: TextStyle(fontSize: 16),),
                    contentLocation: ContentLocation.below,
                    backgroundColor: Colors.black,
                    targetColor: Colors.green,
                    featureId: 'feature2',
                    tapTarget: const Icon(CupertinoIcons.add),

                    child: ingredientButtons(
                      lineIconFirstButton: LineIcons.plus,
                      buttonTextColor: Colors.white,
                      buttonColor: blendedData.ingredientsButtonColour,
                        firstButtonFunction: (){
                          if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){

                            showDialog(context: context,

                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(context,
                                                          MaterialPageRoute(builder: (context)=> SpecialBlendAi())
                                                      );
                                                      // Navigator.pushNamed(
                                                      //     context, SpecialBlendAi.id);
                                                    },
                                                    child: CircleAvatar(
                                                        radius: 40,
                                                        backgroundColor: kPureWhiteColor
                                                            .withOpacity(1),
                                                        child:
                                                        Lottie.asset("images/wiggle_chat.json", height: 60)
                                                      // const Icon(
                                                      //   Iconsax.box, color: kBlack,
                                                      //   size: 20,)
                                                    ),
                                                  ),
                                                  Text("Blend For Me",
                                                    textAlign: TextAlign.center,
                                                    style: kNormalTextStyle.copyWith(
                                                        color: kPureWhiteColor,
                                                        fontSize: 12),)
                                                ],
                                              ),
                                              kMediumWidthSpacing,
                                              kMediumWidthSpacing,
                                              kMediumWidthSpacing,
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
                                                      if (firstBlend == true){
                                                        firstBlendDone();

                                                        AlertPopUpDialogue(context, imagePath: 'images/longpress.json', text: 'To know the Health benefits of an ingredient long press on it', title: 'Tip 2: Long Press for Benefits');
                                                        AlertPopUpDialogue(context, imagePath: 'images/swipe.json', text: 'To view all ingredients Swipe left and Right on each Category', title: 'Tip 1: Swipe to View');
                                                      }
                                                      // Navigator.pushNamed(
                                                      //     context, ReStockPage.id);
                                                    },
                                                    child: CircleAvatar(
                                                        backgroundColor: kBlack
                                                            .withOpacity(1),

                                                        radius: 40,
                                                        child:
                                                        Lottie.asset("images/juiceBlender.json",)
                                                    ),
                                                  ),
                                                  Text("Select Your Blend",
                                                    textAlign: TextAlign.center,
                                                    style: kNormalTextStyle.copyWith(
                                                        color: kPureWhiteColor,
                                                        fontSize: 12),)
                                                ],
                                              ),

                                            ],
                                          )),
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          Text("Cancel",
                                            style: kNormalTextStyle.copyWith(
                                                color: kPureWhiteColor),)
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          }
                          else {
                            bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
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
                  title: Text('Welcome $firstName 🥳'),
                  description: Text('Have you felt unwell with flu or cold, or wanted to get a healthy option for that weight, or Skin?', style: TextStyle(fontSize: 16),),
                 // description: Text(' Your new Health Journey starts here. Let us show you how Blendit Works '),
                  contentLocation: ContentLocation.above,
                  backgroundColor: kBlueDarkColor,
                  targetColor: kBiegeThemeColor,
                  featureId: initialId,
                  tapTarget: Icon(CupertinoIcons.hand_thumbsup),
                  child: GestureDetector(
                      onTap: (){

                        if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
                        // AlertPopUpDialogueMain(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your Blender', fruitProvider: fruitProvider, extraProvider: extraProvider, blendedData: blendedData, vegProvider: vegProvider);

                          showDialog(context: context,
                              // barrierLabel: 'Appointment',
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context)=> SpecialBlendAi())
                                                        );
                                                    // Navigator.pushNamed(
                                                    //     context, SpecialBlendAi.id);
                                                  },
                                                  child: CircleAvatar(
                                                      radius: 40,
                                                      backgroundColor: kPureWhiteColor
                                                          .withOpacity(1),
                                                      child:
                                                      Lottie.asset("images/wiggle_chat.json", height: 60)
                                                      // const Icon(
                                                      //   Iconsax.box, color: kBlack,
                                                      //   size: 20,)
                                                  ),
                                                ),
                                                Text("Blend For Me",
                                                  textAlign: TextAlign.center,
                                                  style: kNormalTextStyle.copyWith(
                                                      color: kPureWhiteColor,
                                                      fontSize: 12),)
                                              ],
                                            ),
                                            kMediumWidthSpacing,
                                            kMediumWidthSpacing,
                                            kMediumWidthSpacing,
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
                                                    if (firstBlend == true){
                                                      firstBlendDone();
                                                      AlertPopUpDialogue(context, imagePath: 'images/longpress.json', text: 'To know the Health benefits of an ingredient long press on it', title: 'Tip 2: Long Press for Benefits');
                                                      AlertPopUpDialogue(context, imagePath: 'images/swipe.json', text: 'To view all ingredients Swipe left and Right on each Category', title: 'Tip 1: Swipe to View');
                                                    }
                                                    // Navigator.pushNamed(
                                                    //     context, ReStockPage.id);
                                                  },
                                                  child: CircleAvatar(
                                                      backgroundColor: kBlack
                                                          .withOpacity(1),

                                                      radius: 40,
                                                      child:
                                                      Lottie.asset("images/juiceBlender.json",)
                                                  ),
                                                ),
                                                Text("Select Your Blend",
                                                  textAlign: TextAlign.center,
                                                  style: kNormalTextStyle.copyWith(
                                                      color: kPureWhiteColor,
                                                      fontSize: 12),)
                                              ],
                                            ),

                                          ],
                                        )),
                                        kLargeHeightSpacing,
                                        kLargeHeightSpacing,
                                        kLargeHeightSpacing,
                                        kLargeHeightSpacing,
                                        kLargeHeightSpacing,
                                        kLargeHeightSpacing,
                                        kLargeHeightSpacing,
                                        Text("Cancel",
                                          style: kNormalTextStyle.copyWith(
                                              color: kPureWhiteColor),)
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
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
                          title: Text('Describe What You Want'),
                          description: Text('Flu? Fatigue? Weight loss? High Blood Pressure?..Blendit will generate a personalized recipe instantly!', style: TextStyle(fontSize: 16),),
                          contentLocation: ContentLocation.above,
                          backgroundColor: Colors.pink,
                          targetColor: Colors.black,
                          featureId: 'feature3',
                          tapTarget: const Icon(LineIcons.fruitApple, color: Colors.white,),
                          child: Center(
                            child: Container(
                              width: 500,
                              child: Stack(
                                children: [
                                  Container(height: 200,),
                                  Positioned(
                                      bottom: 30,
                                      right: 5,
                                      left: 5,
                                      child: Lottie.asset('images/newform.json', height: 300)),
                                  Image.asset(blendedData.blenderImage),
                                ],
                              ),
                            ),
                          ))),
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
                          const SizedBox(height: 100,),

                              blendedData.basketNumber == 0? Container():
                              Stack(children: [
                                  Positioned(
                                    top: 4,
                                    right: 2,
                                    child: CircleAvatar(radius: 10,
                                        child: Text(
                                          '${blendedData.basketNumber}', style: TextStyle(fontSize: 10),)),
                                  ) ,
                                  IconButton
                                    (onPressed: (){
                                    if (blendedData.basketNumber == 0) {

                                    }else {
                                      Navigator.pushNamed(context, CheckoutPage.id);
                                    }
                                  },
                                    icon: Icon(LineIcons.shoppingBasket),),
                                ]),
                          kSmallHeightSpacing,


                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('orders')
                                        .where('sender_id', isEqualTo: email)
                                        // .where('cancelled', isEqualTo: false)
                                        .orderBy('deliveryTime', descending: false)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          color: Colors.teal,
                                        );
                                      } else {
                                        dateList = [];
                                        statusList = [];
                                        typeList = [];
                                        var data = snapshot.data!.docs;
                                        for (var item in data) {

                                          Timestamp deliveryTimestamp = item.get('deliveryTime');
                                          var status = item.get('status');
                                          var cancelled = item.get('cancelled');


                                          if (status!= 'CANCELLED'&& cancelled == false){

                                            if (status!= 'delivered') {
                                              print(status);
                                              typeList.add(item.get('type'));
                                              activeOrder = true;
                                              dateList.add(item.get('deliveryTime').toDate());
                                              statusList.add(item.get('status'));
                                              print(statusList);
                                            }else{
                                              activeOrder = false;

                                            }
                                          } else{
                                            activeOrder = false;
                                          }

                                          // You can add other logic related to processing data here
                                        }
                                      }
                                      print(typeList);
                                      return
                                        activeOrder==false ? Container():
                                        GestureDetector(
                                          onTap: (){
                                            showModalBottomSheet(
                                                isScrollControlled: true, // Set this property to true
                                                context: context,
                                                builder: (context) {
                                                  return Scaffold(
                                                    appBar: AppBar(
                                                      backgroundColor: kBackgroundGreyColor,
                                                      elevation: 0,
                                                      automaticallyImplyLeading: false,
                                                    ),
                                                    body: Scaffold(
                                                        appBar: AppBar(
                                                          foregroundColor: kBlack,
                                                          backgroundColor:kBackgroundGreyColor,
                                                          elevation: 0,
                                                          automaticallyImplyLeading: true,
                                                        ),
                                                        body: OrdersTabController()),
                                                  );
                                                });
                                            // Navigator.pushNamed(context, OrdersTabController.id);
                                          },
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              typeList[0]=="Appointment"?Lottie.asset("images/workout5.json", height: 80):statusList[0]=="submitted"?Lottie.asset("images/freeChat.json", height: 20):
                                              statusList[0]=="preparing"?Lottie.asset("images/cook.json", height: 80):
                                              statusList[0]=="Ready for Delivery"?Lottie.asset("images/package.json", height: 80):
                                              statusList[0]=="delivering"?Lottie.asset("images/deliver.json", height: 50):
                                              Container(),
                                              statusList[0]=="CANCELLED"?Container():Text('${dateList.length} Active Order\n${ DateFormat('EE, dd MMM\nkk:mm').format(dateList[0])}', style: kNormalTextStyle.copyWith(color: kBlack),),
                                              statusList[0]=="CANCELLED"?Container():Text('${statusList[0]}', style: kNormalTextStyle.copyWith(color: kGreenThemeColor),),
                                            ]
                                      ),
                                        );
                                    }
                                ),



                              ]),


                          blendedData.basketNumber == 0? Container():const Text('Your Basket',textAlign: TextAlign.center , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),

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
                            width: MediaQuery.of(context).size.width >mobileWidth? screenDisplayWidth : MediaQuery.of(context).size.width,

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
      width: MediaQuery.of(context).size.width >mobileWidth? screenDisplayWidth : MediaQuery.of(context).size.width,

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

