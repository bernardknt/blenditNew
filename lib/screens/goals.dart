


import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/CommonFunctions.dart';
import 'delivery_page.dart';


List<String> splitText(String text) {
  // Split the text by ":" and "?" characters
  List<String> splitList = text.split(RegExp(r'[:?]'));

  // Filter out any empty strings from the split list
  List<String> filteredList = splitList.where((item) => item.trim().isNotEmpty).toList();

  return filteredList;
}

final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('setWeeksGoal');
String text = ": Plan and prep healthy meals? (referring to creating a meal plan and preparing nutritious meals in advance) : Complete 30-minute workouts daily? (referring to scheduling and completing daily 30-minute exercise sessions) : Reflect on progress, adjust accordingly? (referring to reviewing and adjusting your weight loss progress based on results and feedback)";
String newText = "Task 1: Complete work presentation draft? Task 2: Organize and declutter workspace? Task 3: Plan healthy meals for week?";


class GoalsPage extends StatefulWidget {
  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {


  List photos = ["","", ""];

  defaultInitialization() async{
    final prefs = await SharedPreferences.getInstance();
    isDateToday = prefs.getBool(kSetWeekGoal)!;
    setState(() {

    });

  }

  bool isDateToday = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColor, // Set background color to navy blue
      appBar: AppBar(
        backgroundColor: kBlueDarkColor,
        foregroundColor:kPureWhiteColor,
        elevation: 0,

      ),
      body: SafeArea(
          child: isDateToday != true ?
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'A journey of 1000 miles begins with one step 👞',
                  textAlign: TextAlign.center,
                  style: kNormalTextStyle.copyWith(fontSize: 24, color: kPureWhiteColor),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  // List<String> result = splitText(newText);
                  // print(result);
                  var docId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';


                  dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{

                    'goal': "I want to lose 10 kg this year",
                    'number':prefs.getString(kPhoneNumberConstant),
                    'docId': docId
                  });

                  prefs.setBool(kSetWeekGoal, !isDateToday);
                  Navigator.pop(context);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> GoalsPage())
                  );



                  setState((){
                    isDateToday = ! isDateToday;
                  });



                  // Action to perform when "Set Week Goal" button is pressed
                  // Add your logic here
                },
                child: Text("Set Week's Goal"),
              ),
            ],
          ): Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("For this Week:", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 24),),
              kSmallHeightSpacing,
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text("Drink atleast 2L of water each day. Take a photo when you have finished your water for each particular day",textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 15),),
              ),
              Center(
                child:
                Lottie.asset('images/workout4.json', height: 130, width: 150, fit: BoxFit.cover,),
              ),
              kLargeHeightSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  photos[0] == ""? PhotoWidget(): Container(height: 100, width: 100,color: kBabyPinkThemeColor,),
                  kMediumWidthSpacing,
                  photos[1] == ""? PhotoWidget(): Container(height: 100, width: 100,color: kBabyPinkThemeColor,),
                  kMediumWidthSpacing,
                  photos[2] == ""? PhotoWidget(): Container(height: 100, width: 100,color: kBabyPinkThemeColor,),
                ],
              ),
              Spacer(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.info, color: kPureWhiteColor,),
              //       kSmallWidthSpacing,
              //       Text("Losing weight is the goal", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 15),),
              //     ],
              //   ),
              // )
            ],
          )
      ),
    );
  }
}

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle icon click here
        CommonFunctions().pickImage(ImageSource.camera,   'goal${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context);

        print('Icon clicked!');
      },
      child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kPureWhiteColor,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.photo_camera,
          size: 48,
          color: kPureWhiteColor,
        ),
      ),
    );
  }
}
