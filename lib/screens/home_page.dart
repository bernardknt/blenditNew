
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/screens/your_vision.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/show_summary_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'detox_juice.dart';
import 'detox_plans.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'loading_goals_page.dart';

class HomePage extends StatefulWidget {
  static String id = 'home_page';

  const HomePage({Key? key}) : super(key: key);



  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var images = ['https://bit.ly/37a6mWG', 'https://bit.ly/3hAKtpr', 'https://bit.ly/3wL1NMN', 'https://bit.ly/36vfVyS'];
  var colours = [Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent, Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent, Colors.pink, Colors.deepPurpleAccent, Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent];
  var challengeName = [];
  var promoList = [];
  var daysList = [];
  var headingList = [];
  var numberList = [];
  var scheduleList = [];
  var shoppingList = [];
  var rulesList = [];
  var challengeIdList = [];
  var difficultyList = [];
  var promoteList = [];
  var recipeList = [];
  var getList = [];
  List<DateTime> challengeEndTimeList = [];
  var prices = [];
  var welcomeList = [];
  var categories = ['🍵 Juices & Smoothies','🍏Detox Plans', '🥗 Salads']; //, 🍹Tropical Juices'
  var pages = [DetoxJuicePage.id, DetoxPlansPage.id, SaladsPage.id ]; // , TropicalPage.id
  String name = 'Bernard';
  var formatter = NumberFormat('#,###,000');
  final numbers = List.generate(100, (index) => '$index');
  final controller = ScrollController();
  var tutorialDone = false;
  var initialId = "";
  var question = '';
  final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('updateUserVision');
  final auth = FirebaseAuth.instance;

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFirstNameConstant) ?? 'Hi';

    setState(() {
      name = newName;
    });
  }

  final newchallengeIndicator = GlobalKey();
  void newChallengeShow ()async {
    final prefs = await SharedPreferences.getInstance();
    var isRequirementsKnown = prefs.getBool(kChallengeActivated) ?? false;

    if (isRequirementsKnown == true) {
      //   initialId = 'feature1';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context,).startShowCase(
            [newchallengeIndicator]);
      });
      prefs.setBool(kChallengeRequirements, true);
    }
    print("KAMUNGULUZE");
  }

  void tutorialShow ()async{
    final prefs = await SharedPreferences.getInstance();
    tutorialDone = prefs.getBool(kIsTutorial2Done) ?? false;
    print("YEEEEEESSSUUUU $tutorialDone");
    if (tutorialDone == false){
      initialId = 'feature1';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FeatureDiscovery.discoverFeatures(context,
            <String>['feature3', 'feature4',  'feature5']);
        // <String>['feature1','feature2', 'feature3', 'feature4', 'feature5']);
      });
    }else{

    }
    prefs.setBool(kIsTutorial2Done, true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    defaultsInitiation();
    newChallengeShow();
    tutorialShow();

  }
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
      backgroundColor: kBackgroundGreyColor,
      // appBar: AppBar(
      //   backgroundColor: kBackgroundGreyColor,
      //   foregroundColor: kBlueDarkColor,
      //   elevation: 0,
      //   // title: Text('Welcome $name', style: kNo,),
      //   // centerTitle: true,
      // //   actions: [
      // //     IconButton(
      // //       onPressed: (){
      // //         CoolAlert.show(
      // //           context: context,
      // //           type: CoolAlertType.info,
      // //           title: 'Welcome $name',
      // //           text: 'This is the home page where you can fi',
      // // );
      // //       },
      // //       icon: Icon(Iconsax.info_circle, color: kBlueDarkColor,),
      // // )],
      // ),

      body: WillPopScope(
        onWillPop: () async {
          return false; // return a `Future` with false value so this route cant be popped or closed.
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('$name, commit \nand Challenge Yourself', textAlign:TextAlign.start , style: kHeading2TextStyleBold.copyWith(color: kBlack, fontSize: 20),),
                        Lottie.asset('images/workout3.json', height: 70, width: 100, fit: BoxFit.cover,),
                      ],
                    ),
                    kLargeHeightSpacing,
                    kLargeHeightSpacing,

                    Stack(
                      children: [

                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                              color: kGreenThemeColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        Positioned(
                          right: -45,
                          top: -40,
                          child: Container(

                            padding: const EdgeInsets.all( 30),
                            decoration: BoxDecoration(
                              // color: kAppPinkColor,
                                shape: BoxShape.circle,
                                border: Border.all(width: 18, color: kBabyPinkThemeColor)
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap:() async {
                                      final prefs = await SharedPreferences.getInstance();

                                      if (prefs.getBool(kIsGoalSet) == false ||prefs.getBool(kIsGoalSet) == null ) {
                                        print(prefs.getBool(kIsGoalSet));
                                        CoolAlert.show(

                                            lottieAsset: 'images/goal.json',
                                            context: context,
                                            type: CoolAlertType.success,
                                            widget: SingleChildScrollView(

                                                child:
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        onChanged: (enteredQuestion){
                                                          question = enteredQuestion;
                                                          // instructions = customerName;
                                                          // setState(() {
                                                          // });
                                                        },
                                                        decoration: InputDecoration(
                                                            border:
                                                            //InputBorder.none,
                                                            OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(color: Colors.green, width: 2),
                                                            ),
                                                            labelText: 'Goal',
                                                            labelStyle: kNormalTextStyleExtraSmall,
                                                            hintText: 'This year I want to lose 10kg',
                                                            hintStyle: kNormalTextStyle
                                                        ),

                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                            text: 'What is your main goal for this year?',
                                            title: "${prefs.getString(kFirstNameConstant)}!",
                                            confirmBtnText: 'Set Goal',
                                            confirmBtnColor: Colors.green,
                                            backgroundColor: kBackgroundGreyColor,
                                            onConfirmBtnTap: () async{
                                              if (question != ""){
                                                final prefs = await SharedPreferences.getInstance();
                                                prefs.setString(kGoalConstant, question);
                                                prefs.setBool(kIsGoalSet, true);
                                                Navigator.pop(context);
                                                prefs.setString(kUserId, auth.currentUser!.uid);
                                                // updatePersonalInformationWithGoal();
                                                dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{
                                                  'goal': question,
                                                  'userId':auth.currentUser!.uid,
                                                  // orderId
                                                });
                                                // Navigator.pushNamed(context, SuccessPageNew.id);
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context)=> LoadingGoalsPage())
                                                );
                                              } else {

                                              }



                                              setState(() {

                                              });
                                            }
                                        );



                                      }else{
                                        // Navigator.pushNamed(context, HomePage.id);
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=> YourVision())
                                        );
                                      }







                                    },
                                    child: DescribedFeatureOverlay(

                                      openDuration: const Duration(seconds: 1),
                                      overflowMode: OverflowMode.extendBackground,
                                      enablePulsingAnimation: true,
                                      barrierDismissible: false,
                                      pulseDuration: const Duration(seconds: 1),
                                      title: const Text('Welcome to Challenges!'),
                                      description: Text("These are No nonsense Challenges designed to help you become consistent and achieve your goals. Whether you want to lose weight, Prepare for a marathon, or put on a few Kilos, their is a challenge for you", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                                      contentLocation: ContentLocation.below,
                                      backgroundColor: kBlueDarkColorOld,
                                      targetColor: kBackgroundGreyColor,
                                      featureId: 'feature3',
                                      tapTarget: Lottie.asset('images/workout2.json', height: 60, fit: BoxFit.cover,),



                                      child: CircleAvatar(
                                        maxRadius: 25,
                                        backgroundColor: kBabyPinkThemeColor,
                                        child: Lottie.asset('images/workout2.json', height: 30, fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                  kSmallHeightSpacing,
                                  Text('', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 13),),
                                  kSmallHeightSpacing,
                                  Text('Vision', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)

                                ],
                              ),

                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      // Navigator.pushNamed(context, TrendsPage.id);
                                      //CommonFunctions().showNotification("notificationTitle", "notificationBody");
                                      // CommonFunctions().scheduledNotification(heading: "heading", body: "body", year: 2023, month: 1, day: 16, hour: 22, minutes: 26, id: 3);



                                      Get.snackbar('Coming Soon', 'This feature is coming soon',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: kAppPinkColor,
                                          colorText: kPureWhiteColor,
                                          margin: const EdgeInsets.all(10),
                                          borderRadius: 10,
                                          icon: const Icon(Icons.info_outline, color: kPureWhiteColor,),
                                          duration: const Duration(seconds: 3)
                                      );
                                    },
                                    child: const CircleAvatar(
                                      maxRadius: 25,
                                      backgroundColor: kBabyPinkThemeColor,
                                      child: Icon(Icons.family_restroom_outlined, color: kBlack, size: 20,),
                                    ),
                                  ),

                                  kSmallHeightSpacing,
                                  Text(' ', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 15),),
                                  kSmallHeightSpacing,
                                  Text('Community', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)

                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

                    kLargeHeightSpacing,
                    DescribedFeatureOverlay(
                        openDuration: const Duration(seconds: 1),
                        overflowMode: OverflowMode.extendBackground,
                        enablePulsingAnimation: true,
                        barrierDismissible: false,
                        pulseDuration: const Duration(seconds: 1),
                        title: Text('$name its time to Start Believing!'),
                        description: Text("We are cheering you all the way! Start a challenge", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                        contentLocation: ContentLocation.below,
                        backgroundColor: kBlueDarkColorOld,
                        targetColor: kBackgroundGreyColor,
                        featureId: 'feature5',
                        tapTarget: Lottie.asset('images/workout4.json', height: 60, fit: BoxFit.cover,),



                        child: Text("Pick a Challenge", style: kHeading2TextStyleBold.copyWith(color: kBlack, fontSize: 18))),
                    kLargeHeightSpacing,
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('plans')
                                  .where('active', isEqualTo: true).orderBy('challengeEndTime', descending: true)

                                  .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      color: Colors.black,
                                    );
                                  } else {
                                    challengeName=[];
                                    promoList = [];
                                    images = [];
                                    prices = [];
                                    daysList = [];
                                    headingList = [];
                                    welcomeList = [];
                                    rulesList = [];
                                    challengeEndTimeList = [];
                                    numberList = [];
                                    challengeIdList = [];
                                    scheduleList = [];
                                    shoppingList = [];
                                    difficultyList = [];
                                    promoteList = [];
                                    recipeList = [];


                                    var challenges = snapshot.data!.docs;
                                    for (var challenge in challenges) {
                                      promoList.add(challenge.get('promo'));
                                      challengeName.add(challenge.get('challenge'));
                                      images.add(challenge.get('image'));
                                      prices.add(challenge.get('total_price'));
                                      daysList.add(challenge.get('days'));
                                      headingList.add(challenge.get('heading'));
                                      rulesList.add(challenge.get('rules'));
                                      welcomeList.add(challenge.get('welcome'));
                                      challengeEndTimeList.add(challenge.get('challengeEndTime').toDate());
                                      numberList.add(challenge.get('number'));
                                      challengeIdList.add(challenge.get('challengeId'));
                                      scheduleList.add(challenge.get('schedule'));
                                      shoppingList.add(challenge.get('shopping'));
                                      difficultyList.add(challenge.get('difficulty'));
                                      getList.add(challenge.get('get'));
                                      promoteList.add(challenge.get('promote'));
                                      recipeList.add(challenge.get('recipe'));


                                    }
                                  }
                                  return

                                    StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      itemCount: challengeName.length,
                                      crossAxisSpacing: 10,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigator.pushNamed(context, AboutChallengePage.id);

                                            showSummaryDialog(
                                                context, images[index],
                                                challengeName[index],
                                                promoList[index],
                                                prices[index],
                                                daysList[index],
                                                scheduleList[index],
                                                challengeIdList[index],
                                                welcomeList[index],
                                                rulesList[index],
                                                promoList[index],
                                                headingList[index],
                                                shoppingList[index],
                                                difficultyList[index],
                                                getList[index],
                                              recipeList[index]
                                            );
                                          },
                                          child: DescribedFeatureOverlay(
                                            openDuration: const Duration(seconds: 1),
                                            overflowMode: OverflowMode.extendBackground,
                                            enablePulsingAnimation: true,
                                            barrierDismissible: false,
                                            pulseDuration: const Duration(seconds: 1),
                                            title: const Text('Step by Step Guidance'),
                                            description: Text("With each challenge we will provide you with the rules, information and personal guidance you need to succeed", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                                            contentLocation: ContentLocation.below,
                                            backgroundColor: kGreenThemeColor,
                                            targetColor: kBackgroundGreyColor,
                                            featureId: 'feature4',
                                            tapTarget: Lottie.asset('images/workout3.json', height: 60, fit: BoxFit.cover,),


                                            child: Container(
                                              margin: const EdgeInsets.only(top: 3,
                                                  right: 0,
                                                  left: 0,
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                // color: colours[index],
                                              ),
                                              child:
                                              Column(
                                                children: [
                                                  Column(

                                                    children: [
                                                      // Padding(
                                                      //   padding: const EdgeInsets.all(8.0),
                                                      //   child: Row(
                                                      //     children: [
                                                      //      numberList[index] < 100? Row(
                                                      //         children: [
                                                      //           const Icon(Iconsax.people, color: kGreenThemeColor, size: 13,),
                                                      //           Text(" ${numberList[index]}", style: kNormalTextStyle.copyWith( fontSize: 13),),
                                                      //         ],
                                                      //       ): Row(
                                                      //        children: [
                                                      //          Lottie.asset('images/flame.json', height: 20, fit: BoxFit.cover,),
                                                      //          Text(" ${numberList[index]}", style: kNormalTextStyle.copyWith( fontSize: 13),),
                                                      //        ],
                                                      //      ),
                                                      //
                                                      //       kMediumWidthSpacing,
                                                      //       challengeEndTimeList[index].day - DateTime.now().day <= 10 ? Row(
                                                      //         children: [
                                                      //           const Icon(Iconsax.ticket_expired, color: kAppPinkColor, size: 13,),
                                                      //           Text(' ${challengeEndTimeList[index].day - DateTime.now().day} Days left', style: kNormalTextStyle.copyWith( fontSize: 13),),
                                                      //         ],
                                                      //       ):
                                                      //           Row(
                                                      //             children: [
                                                      //               const Icon(Iconsax.drop3, color: kGreenThemeColor, size: 13,),
                                                      //               Text("Live Now", style: kNormalTextStyle.copyWith( fontSize: 13, color: kGreenThemeColor),),
                                                      //             ],
                                                      //           ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 150,
                                                            width: 170,
                                                            margin: const EdgeInsets.only(
                                                                top: 10,
                                                                right: 0,
                                                                left: 0,
                                                                bottom: 3),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(20),
                                                                // color: backgroundColor,
                                                                image: DecorationImage(
                                                                  image:  CachedNetworkImageProvider(images[index]),
                                                                  //NetworkImage(images[index]),
                                                                  fit: BoxFit.cover,
                                                                )
                                                              //colours[index],
                                                            ),

                                                          ),
                                                         prices[index] == 0? Positioned(
                                                            top: 20,
                                                              right: 20,

                                                              child: Container(
                                                                height: 20,
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                  color: kGreenThemeColor,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Free', textAlign: TextAlign.start,
                                                                    style: kNormalTextStyle.copyWith(
                                                                        color: kPureWhiteColor,
                                                                        fontSize: 13),
                                                                  ),
                                                                ),

                                                              )
                                                          ) :
                                                         Container(),
                                                          promoteList[index] == true?
                                                          Positioned(
                                                              top: 20,
                                                              right: 20,

                                                              child: Container(
                                                                height: 20,
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                  color: kBlack,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                         children: [

                                                                           Text("Trending", style: kNormalTextStyle.copyWith( fontSize: 13, color: kPureWhiteColor),),
                                                                           Lottie.asset('images/flame.json', height: 15, fit: BoxFit.cover,),
                                                                         ],
                                                                       ),

                                                              )
                                                          ) :
                                                          Container(),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      challengeName[index],
                                                      style: kNormalTextStyleWhite,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      staggeredTileBuilder: (index) =>
                                          const StaggeredTile.fit(1));
                                }),

                  ],
                ),
                Positioned(
                  bottom: 200,
                    right: 10,

                    child: Showcase(
                      disposeOnTap: true,
                      onToolTipClick: ()async{
                        print("WOOOOOEEEEEWWEEEE this run");
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool(kChallengeActivated, false);


                      },
                      onTargetClick: ()async{
                        print('Target clicked');
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool(kChallengeActivated, false);

                        print('Target clicked');
                      },

                  key: newchallengeIndicator,
                  titleTextStyle: kNormalTextStyle,
                  description: 'Looks like you have an active challenge. Go to Workouts Tab',
                  child: Text("")
                  ,))
              ],
            ),
          )
        ),
      ),
    );


  }

  // TextField searchBar() {
  //   return TextField(
  //     onTap: (){
  //       Navigator.pushNamed(context, AllProductsPage.id);
  //     },
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(50)),
  //               ),
  //               fillColor: Colors.white,
  //               filled: true,
  //               contentPadding:EdgeInsets.symmetric(horizontal: 20),
  //               prefixIcon: Icon(LineIcons.search),
  //               hintText: 'Chicken Salad'
  //
  //             ),
  //           );
  // }



}


