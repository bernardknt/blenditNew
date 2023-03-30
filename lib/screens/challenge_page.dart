
import 'dart:async';
import 'dart:io';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/challenge_show_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../widgets/categories_widget.dart';
import 'calendar_page.dart';



class ChallengePage extends StatefulWidget {
  static String id = 'challenge_page';


  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final requirementsIndicator = GlobalKey();
  final shoppingIndicator = GlobalKey();
  final  recipeIndicator = GlobalKey();
  late List <Step> stepsData;
  int currentStep = 0;
  Color textColor = kCustomColor;
  Color backGroundColor = kBlueDarkColorOld;
  String name = '';
  String intro = "";
  String id  = "";
  int stepperDataAnotherIndex = -1;

  var categories = ['Rules','Schedule', 'Start Date'];

// Camera functions
  File? image;
  var imageUploaded = false;
  Future pickImage(ImageSource source, challengeId, activeChallengeIndex, listOfKeysLength, challengePosition, challengeDayKeysLength, challengeName, customerName, currentChallengeStep, planDay)async{
    try {
      final image = await ImagePicker().pickImage(source: source);
      // await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null){
        return ;
      }else {
        var file = File(image.path);

        // final sizeImageBeforeCompression = file.lengthSync() / 1024;
        // print("BEFORE COMPRESSION: ${sizeImageBeforeCompression}kb");


        setState(() {
          imageUploaded = true;
          this.image = file;
        });

        CommonFunctions().uploadPhoto(image.path, image.name, challengeId, activeChallengeIndex, listOfKeysLength, challengePosition, challengeDayKeysLength, challengeName, customerName, currentChallengeStep, planDay, context);
      }
    } on PlatformException catch (e) {
      print('Failed to pick image $e');

    }
  }
  late Timer _timer;
  animationTimer() {
    _timer = new Timer(const Duration(milliseconds: 2000), () {
     setState(() {

     });


    });
  }

  // End


  void tutorialShow ()async {
    final prefs = await SharedPreferences.getInstance();
    var isRequirementsKnown = prefs.getBool(kChallengeRequirements) ?? false;

    if (isRequirementsKnown == false) {
      //   initialId = 'feature1';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context,).startShowCase(
            [requirementsIndicator, shoppingIndicator, recipeIndicator]);
      });
      prefs.setBool(kChallengeRequirements, true);
    }

  }

  void rulesFunction() {
    var newRules = Provider.of<AiProvider>(context, listen: false).challengeRules.split('.');
    List<String> modifiedLines = [];

    // Loop through the list of substrings and add consecutive number points to the beginning of each line
    for (int i = 0; i < newRules.length; i++) {
      modifiedLines.add((i + 1).toString() + ". " + newRules[i]);
    }

    // Join the modified lines into a single string
    String modifiedString = modifiedLines.join("\n");
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            backgroundColor: kPureWhiteColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('The Rules', textAlign: TextAlign.center,
                  style: kHeadingTextStyle.copyWith(color: kBlack),),
                kMediumWidthSpacing,
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Share.share("Check out the rules of the ${Provider.of<AiProvider>(context, listen: false).challengeName}:\n$modifiedString",
                            subject: 'Check out the rules of the ${Provider.of<AiProvider>(context, listen: false).challengeName}');
                      },

                      child: Icon(LineIcons.alternateShare, size: 15,
                        color: kPureWhiteColor,)),
                )
              ],
            ),
            content:
            Container(
                height: 350,
                color: kPureWhiteColor,
                child: SingleChildScrollView(child:
                Column(
                  children: [
                    Text(modifiedString, textAlign: TextAlign.left,
                      style: kNormalTextStyle.copyWith(fontSize: 14),),
                    kLargeHeightSpacing,
                    TextButton(onPressed: () {
                      Provider.of<AiProvider>(context, listen:false).setWelcomeButtons(0);
                      Navigator.pop(context);
                    },
                      child: Text('Understood',
                        style: kNormalTextStyle.copyWith(
                            color: kPureWhiteColor),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            kGreenThemeColor),),)
                  ],
                ))
            ),

          ),
    );
  }
  void planFunction() {
    var newSchedule = Provider.of<AiProvider>(context, listen: false).challengeSchedule.split('.').join("\n");

    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            backgroundColor: kPureWhiteColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('The Plan Schedule', textAlign: TextAlign.center,
                  style: kHeadingTextStyle.copyWith(color: kBlack),),
                kMediumWidthSpacing,
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Share.share('Check out the Schedule for ${Provider.of<AiProvider> (context, listen: false).challengeName}: \n$newSchedule',
                            subject: 'Check out the rules of the challenge');
                      },

                      child: Icon(LineIcons.alternateShare, size: 15,
                        color: kPureWhiteColor,)),
                )
              ],
            ),
            content:
            Container(
                height: 350,
                color: kPureWhiteColor,
                child: SingleChildScrollView(child:
                Column(
                  children: [
                    Text(newSchedule,
                      style: kNormalTextStyle.copyWith(fontSize: 14),),
                    kLargeHeightSpacing,
                    TextButton(onPressed: () {
                      Provider.of<AiProvider>(context, listen:false).setWelcomeButtons(1);
                      Navigator.pop(context);
                    },
                      child: Text('Got it',
                        style: kNormalTextStyle.copyWith(
                            color: kPureWhiteColor),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            kGreenThemeColor),),)
                  ],
                ))
            ),

          ),
    );
  }
  void  dateFunction(){
    Navigator.pushNamed(context, CalendarPage.id);

  }
  void defaultInitialization() async {

    var aiData = Provider.of<AiProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    currentStep = aiData.challengePosition;
    id = aiData.challengeId;
    name = prefs.getString(kFirstNameConstant)! ?? '';


    var planDays = aiData.challengeDaysKeys;


    var planInfo = aiData.challengeDaysValues;
    stepsData = [
      Step(

        title: Text("Start Here", style: kNormalTextStyle.copyWith(color: textColor),),
        content: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text('Welcome $name..',style: kHeading2TextStyle.copyWith(color: textColor, overflow: TextOverflow.ellipsis),),
                  Lottie.asset('images/lisa.json', height: 70,),
                ],
              ),
              Text(aiData.challengeWelcomeMessage,style: kNormalTextStyle.copyWith(color: textColor),),
              Categories(categoriesNumber: categories.length, categories: categories, pageName:[rulesFunction, planFunction,dateFunction ],)

            ],
          ),
        ),
        isActive: currentStep >= 0,
      ),
    ];

// THIS FUNCTION REARRANGES THE MAP DATA THAT COMES FROM CLOUD FIRESTORE. FOR SOME STRANGE REASON IT IS NOT ORDERED
    var myList = planDays;
    myList.sort((a, b) => a.compareTo(b));

    List myValues = [];

    for (String key in myList) {
      var value = aiData.challengeDays[key];
      myValues.add(value);
    }

     print("WAKANDA FOREVER: $myList");
     print("WAKANDA NOW: $myValues");

    for (int i = 0; i < planDays.length; i++) {
      Map data = myValues[i];
      // This function below sorts the data received from planInfo[i] and orders it according to date.. Gotten from chatgpt
      List sortedList = data.entries.toList()..sort((entry1, entry2) => entry1.value.compareTo(entry2.value));
      // print("WAKANDA FOREVER: $sortedList");

      List<StepperData> stepperDataAnother = [];
      var iconList = [Icon(LineIcons.cloudWithSun, color: kBlack), Icon(LineIcons.cloud, color: kBlack), Icon(LineIcons.cloudWithMoon, color: kBlack), Icon(LineIcons.moon, color: kBlack)];
      // var listOfKeys = data.keys.toList();
      // This Then extracts the keys of each entry and assigns it to the list of Keys
      var listOfKeys = sortedList.map((e) => e.key).toList();

      //var listOfValues = data.values.toList();
      // This Then extracts the values of each entry and assigns it to the list of Values
      var listOfValues = sortedList.map((e) => e.value).toList();
      for (int j = 0; j < listOfKeys.length; j++)
      {
        Timestamp timestamp = listOfValues[j];
        DateTime dateTime = timestamp.toDate();
        // This function checks whether the current page we are on is whats being looked at then sends
        if (i + 1 == currentStep){
          CommonFunctions().scheduledNotification(heading: "Day ${i+1}: Time for ${listOfKeys[j]}", body: "Tick ${listOfKeys[j]} off your list", year: DateTime.now().year, month: DateTime.now().month, day: DateTime.now().day, hour: dateTime.hour, minutes: dateTime.minute, id: j+1);
         //  print("LULULULLULU $currentStep : ${listOfKeys[j]}");
        }



        stepperDataAnother.add(
            StepperData(
            title: StepperText("${listOfKeys[j]}", textStyle: const TextStyle(
              color: kPureWhiteColor,
            ),),
            subtitle: StepperText(DateFormat('HH:mm').format(dateTime)),
            iconWidget: GestureDetector(
              onTap: () {
                if(Provider.of<AiProvider>(context, listen: false).activeChallengeIndex == j) {
                  if (DateTime.now().hour >= dateTime.hour - 2){
                    print(stepperDataAnotherIndex);
                    stepperDataAnotherIndex = j +1;
                    CoolAlert.show(
                        lottieAsset: 'images/camera.json',
                        context: context,
                        type: CoolAlertType.custom,
                        // title: "Enter option",
                        widget: Column(
                          children: [
                            Text('Take a photo of your ${listOfKeys[j]} activity to proceed',textAlign: TextAlign.center, style: kNormalTextStyle,),
                            //Text('Your appointment with ${Provider.of<BeauticianData>(context, listen: false).appointmentsToday.join(",")} is today', style: kNormalTextStyle,),
                            kLargeHeightSpacing,
                          ],
                        ),
                        confirmBtnText: 'Yes',
                        confirmBtnColor: kBlueDarkColorOld,
                        cancelBtnText: 'Cancel',
                        showCancelBtn: true,
                        backgroundColor: kPureWhiteColor,

                        onConfirmBtnTap: (){
                          // Camera functionality
                          Navigator.pop(context); // This is to close the cool alert
                          pickImage(ImageSource.camera, id, aiData.activeChallengeIndex, listOfKeys.length, aiData.challengePosition, aiData.challengeDaysKeys.length, aiData.challengeName, name, currentStep, planDays[i]);

                        }
                    );
                  } else {
                    CoolAlert.show(
                        lottieAsset: 'images/waiting.json',
                        context: context,
                        type: CoolAlertType.custom,
                        // title: "Enter option",
                        widget: Column(
                          children: [
                            Text('Looks like your too early to do this part of the Challenge',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontSize: 16),),
                            //Text('Your appointment with ${Provider.of<BeauticianData>(context, listen: false).appointmentsToday.join(",")} is today', style: kNormalTextStyle,),
                            kLargeHeightSpacing,


                          ],
                        ),
                        confirmBtnText: 'I will wait for ${dateTime.hour}:00',
                        confirmBtnColor: kBlueDarkColorOld,
                        // cancelBtnText: 'Cancel',
                        // showCancelBtn: true,
                        backgroundColor: kPureWhiteColor,

                        onConfirmBtnTap: (){
                          // Provider.of<AiProvider>(context, listen: false).setActiveChallengeIndex();
                          // setState(() {
                          //
                          // });
                          Navigator.pop(context);
                          // Navigator.pop(context);
                          // Navigator.pushNamed(context, ChallengePage.id);



                        }
                    );
                  }
                } else {
                  Get.snackbar('Not so fast!', 'Complete the Previous Challenge first',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: kCustomColor,
                      colorText: kBlack,
                      icon: Icon(Icons.dangerous_rounded, color: kAppPinkColor,));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color:
                    // Colors.orange,
                    Provider.of<AiProvider>(context, listen: false).dayGoalColors[j],
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child:  iconList[j],
              ),
            )
        )
        );

    }

      stepsData.add(Step(title: 
      Container(
        width: 300,
        child: Row(
          children: [
            Text("${planDays[i]}", style: kNormalTextStyle.copyWith(color: textColor),),
            kMediumWidthSpacing,
            Icon(
              // Icons.circle,
              Provider.of<AiProvider>(context, listen: false).dayIcons[i],
              color: Provider.of<AiProvider>(context, listen: false).dayIconsColor[i],
            size: 12,),
            // Lottie.asset(
            //   // 'images/celebrate.json', height: 20
            //   Provider.of<AiProvider>(context, listen: false).lottieImages[i],
            //  height: 20,
            // ),
          ],
        ),
      ),


        // Here if the day of the plan is today, then the step is active
        content:
        aiData.appointmentDate.day <= DateTime.now().day && aiData.appointmentDate.month <= DateTime.now().month &&  aiData.appointmentDate.year <= DateTime.now().year? Container(

          child:
          // Here we shall put the details of the steps for the day using another stepper
          AnotherStepper(

            stepperList: stepperDataAnother,
            stepperDirection: Axis.vertical,
            gap: 25,
            iconWidth: 40,
            iconHeight: 40,
            activeBarColor: Colors.green,
            inActiveBarColor: Colors.grey,

            activeIndex: Provider.of<AiProvider>(context, listen: false).activeChallengeIndex,
            barThickness: 4,
          ),
        ): Container(child: Column(
          children: [
            Text("Looks like the ${aiData.challengeName} starts on ${DateFormat('EEEE dd-MMM yyyy').format(Provider.of<AiProvider>(context, listen: false).appointmentDate)}. Get your shopping ready minwhile",textAlign:TextAlign.center, style: kNormalTextStyle.copyWith(color: kAppPinkColor),),
            TextButton(onPressed:
                (){
                Navigator.pushNamed(context, CalendarPage.id);
              },
                child: Text('Change Date', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      ),

            Lottie.asset('images/waiting.json', height: 200,),
            kLargeHeightSpacing,

          ],
        ),),
        isActive: currentStep >= 1 + i,
      ));

    }



    setState(() {
      name = prefs.getString(kFirstNameConstant) ?? '';
    });
    // Navigator.pushNamed(context, ChallengePage.id);
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context)=> LoadingChallengePage())
    // );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    defaultInitialization();

    //Navigator.pushNamed(context, ChallengePage.id);
     // animationTimer();
    tutorialShow();
  }


  @override
  Widget build(BuildContext context) {
    var aiData = Provider.of<AiProvider>(context);





    return Scaffold(
      backgroundColor: backGroundColor,
    appBar: AppBar(
      backgroundColor: backGroundColor,
      title: Text(aiData.challengeName,textAlign:TextAlign.center, style: kHeading2TextStyle.copyWith(fontSize: 14, color: kPureWhiteColor),),
      actions: [
        Showcase(
          key: recipeIndicator,
          titleTextStyle: kNormalTextStyle,
          description: 'Click here to see your Shopping list',
          child: IconButton(
            icon: Icon(Iconsax.menu_board, color:Colors.red,),
            onPressed: () {
              // var shoppingList = Provider.of<AiProvider>(context, listen: false).challengeRules.split('.');
              var shoppingList = Provider.of<AiProvider>(context, listen: false).challengeRecipeList;


              showShoppingListDialog(context, 'Recipes',shoppingList, ".", "\n");


            },
          ),
        ),
        kSmallWidthSpacing,
        Showcase(
          key: shoppingIndicator,
          titleTextStyle: kNormalTextStyle,
          description: 'Click here to see your Shopping list',
          child: IconButton(
            icon: Icon(Icons.shopping_cart, color:kGreenThemeColor,),
            onPressed: () {
             // var shoppingList = Provider.of<AiProvider>(context, listen: false).challengeRules.split('.');
              var shoppingList = Provider.of<AiProvider>(context, listen: false).challengeShoppingList;


              showShoppingListDialog(context, 'Your shopping List',shoppingList, ",", "\n - ");


            },
          ),
        ),
        kSmallWidthSpacing,
        Showcase(
        key: requirementsIndicator,
        titleTextStyle: kNormalTextStyle,
        description: 'Click here to check out the Schedule for your challenge',
          child: IconButton(
            icon: Icon(Icons.document_scanner, color: kCustomColor,),
            onPressed: () {
              var scheduleList = Provider.of<AiProvider>(context, listen: false).challengeSchedule;

              showShoppingListDialog(context, 'The Schedule',scheduleList, '.', " \n");


            },
          ),
        ),
        kSmallWidthSpacing,

      ],


    ),

    body: SingleChildScrollView(
      child: Column(
        children: [


          Stepper (

            steps: stepsData,
            // stepsData,
            type: StepperType.vertical,
            currentStep: currentStep,
            onStepTapped: (step) {
              print("onStepTapped : " + step.toString());
            },
            onStepContinue: () {

              // Create a switch statement to handle the different cases
              if (Provider.of<AiProvider>(context, listen: false).welcomeFacts.contains(false)){
                Get.snackbar('Oops', 'You have not read the rules and plan schedule yet, or set a date for the challenge',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: kCustomColor,
                    colorText: kBlack,
                    icon: Icon(Icons.dangerous_rounded, color: kAppPinkColor,));
              } else {
                if (currentStep == 0) {
                  CommonFunctions().uploadStageChanges(id, Provider.of<AiProvider>(context, listen: false).appointmentDate, currentStep + 1);
                  setState(() {currentStep < stepsData.length - 1 ? currentStep += 1 : currentStep = 0;
                  });
                } else if (Provider.of<AiProvider>(context, listen: false).goToNextLevel == true) {

                  setState(() {currentStep < stepsData.length - 1 ? currentStep += 1 : currentStep = 0;
                  });
                } else {
                  Get.snackbar('Oops', 'You have not completed the Todays activities',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: kCustomColor,
                      colorText: kBlack,
                      icon: Icon(Icons.calendar_month_sharp, color: kAppPinkColor,));
                }
              }
            },
            onStepCancel: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    )
    );

  }

}
