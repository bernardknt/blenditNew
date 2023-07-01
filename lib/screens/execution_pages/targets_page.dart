import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/execution_pages/get_a_number_page.dart';
import 'package:blendit_2022/screens/execution_pages/goal_calendar_page.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page5.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import '../../../models/CommonFunctions.dart';
import '../../../utilities/font_constants.dart';
import '../../../widgets/InputFieldWidget2.dart';
import '../../../widgets/gliding_text.dart';
import '../../controllers/home_controller.dart';



class TargetsPage extends StatefulWidget {
  //  static String id = 'success_challenge_new';

  @override
  _TargetsPageState createState() => _TargetsPageState();
}

class _TargetsPageState extends State<TargetsPage> {



  late Timer _timer;
  var goalSet= "";
  var countryName = '';
  var countrySelected = false;
  var initialCountry = "";
  var countryFlag = '';
  var countryCode = "+256";
  var name = "";
  var random = Random();
  var inspiration = "Welcome to Nutri, Our goal is to help you achieve your nutrition and health goals, Anywhere you go. Let me set you up";
  var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var userId = "";
  var modifiedValues = [];

  void defaultInitialization() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(kUniqueIdentifier)!;

    initialCountry = Provider.of<AiProvider>(context,listen: false).favouriteCountry;
    name = prefs.getString(kFirstNameConstant) ?? "";
    Provider.of<AiProvider>(context, listen: false).setUseName(name);
    inspiration = "$name, What Important Goal would you like to achieve?";
    CommonFunctions().uploadUserTokenWithName(prefs.getString(kToken)!,prefs.getString(kFirstNameConstant), prefs.getString(kFullNameConstant) );
  }

  List<String> addPrefixToElements(List inputArray) {
    return inputArray.map((element) => 'false?$element').toList();
  }

  List<int> createArray() {
    List<int> array = [];

    for (int i = 2; i <= 8; i++) {
      int element =  40;
      array.add(element);
    }
    final random = Random();

    array.shuffle(random);

    return array;
  }
  //
  // void createModifiedValues(values) {
  //   final random = Random();
  //   modifiedValues.clear();
  //
  //   if (values.length >= 2) {
  //     // Randomly select two values
  //     final index1 = random.nextInt(values.length);
  //     final index2 = random.nextInt(values.length - 1);
  //     final selectedValue1 = values[index1];
  //     final selectedValue2 = values[index2 < index1 ? index2 : index2 + 1];
  //
  //     // Create modified strings
  //     final modifiedString1 = 'false?$selectedValue1';
  //     final modifiedString2 = 'false?$selectedValue2';
  //
  //     // Add modified strings to the new array
  //     modifiedValues.addAll([modifiedString1, modifiedString2]);
  //   }
  //   updateTasks();
  // }

  List<int> generateRandomArray() {
    final List<int> numbers = [];
    final random = Random();

    int previousNumber = 0;
    int highestNumber = 0;

    for (int i = 0; i < 7; i++) {
      // Determine the maximum value for this position
      final maxNumber = min(100, highestNumber + 10);

      // Generate a random number within the valid range
      final randomNumber = random.nextInt(maxNumber - previousNumber + 1) +
          previousNumber -
          (previousNumber % 10);

      // Update the previous and highest numbers
      previousNumber = randomNumber;
      highestNumber = max(highestNumber, randomNumber);

      // Add the number to the array
      numbers.add(randomNumber);
    }

    return numbers;
  }

  Future<void> updateTasks() async {
    final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
    final DocumentReference userDoc = usersCollection.doc(userId);
      await userDoc.update({
        'dailyTasks': addPrefixToElements(Provider.of<AiProvider>(context, listen: false).preferencesSelected) ,
        'articleCount': 0,
        'targetNumbers': createArray(),
        'articleCountValues':['0?${DateTime.now().toIso8601String()}']
      }).then((value){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> GetANumberPage())
        );
        // Navigator.pushNamed(context, ControlPage.id);
      });
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    _startTyping();
    animationTimer();
  }
  double opacityValue = 0.0;
  final String _text = 'Hello World';


  void _startTyping() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {

      });
    });
  }

  final _random = new Random();
  animationTimer() async{
    final prefs = await SharedPreferences.getInstance();
    _timer = Timer(const Duration(milliseconds: 3000), () {
      prefs.setBool(kChallengeActivated, true);
      opacityValue = 1.0;
      setState(() {


      });


    });
  }

  Widget build(BuildContext context) {
    var aiData = Provider.of<AiProvider>(context, listen: false);
    var aiDataDisplay = Provider.of<AiProvider>(context);


    return Scaffold(
      backgroundColor: kPureWhiteColor,

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Access the vision field from the snapshot
          final vision = snapshot.data!['vision'];

          // Parse the vision JSON string
          final visionData = jsonDecode(vision);

          return SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Card(
                      color: kCustomColor,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(20))),
                      // shadowColor: kGreenThemeColor,
                      // color: kBeigeColor,
                      elevation: 1.0,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 260,
                            child:
                            Center(child: GlidingText(
                              text: visionData['goal'],
                              delay: const Duration(seconds: 1),
                            ),

                            )
                        ),
                      ),
                    ),

                    Stack(
                      children: [
                        Lottie.asset('images/target.json', height: 180, width: 300, fit: BoxFit.contain ),
                        Positioned(
                            bottom: 55,
                            right: 0,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: kAppPinkColor, 
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(visionData['target'], style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 10),),
                            )))
                      ],
                    ),
                    Text("Select Any 2 Activities to Focus\nOn This Week",textAlign: TextAlign.center, style: kHeading2TextStyleBold,),
                    kLargeHeightSpacing
                    
                  ],
                ),
                Container(
                  height: 290,
                  // width: 200,
                  child: ListView.builder(
                    itemCount: visionData['action'].length,
                    itemBuilder: (
                        BuildContext context, int index)
                    {
                      return GestureDetector(
                        onTap: (){
                          aiDataDisplay.setPreferencesBoxColor(index, aiData.preferencesColorOfBoxes[index], visionData['action'][index], visionData['action'][index]);
                          print(visionData['action'][index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Provider.of<AiProvider>(context, listen: false).preferencesColorOfBoxes[index],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              visionData['action'][index],
                              style: TextStyle(
                                color: kBlueDarkColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(aiDataDisplay.targetsContinueColor)),
                      onPressed: ()async {
                        if(aiDataDisplay.targetsContinueColor == kGreenThemeColor) {
                          final prefs = await SharedPreferences.getInstance();
                         print(aiDataDisplay.preferencesSelected);
                         updateTasks();
                          prefs.setString(kUserVision, vision);



                        } else {
                          showDialog(context: context, builder: (BuildContext context){
                            return
                              CupertinoAlertDialog(
                                title: const Text('SELECT 2 TARGETS'),
                                content: Text("Please select 2 targets", style: kNormalTextStyle.copyWith(color: kBlack),),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      // _btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'))],
                              );
                          });
                        }


                      }, child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
