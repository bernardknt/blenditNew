


import 'package:blendit_2022/screens/your_vision.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/CommonFunctions.dart';
import '../widgets/chart_widget.dart';
import 'delivery_page.dart';
import 'loading_goals_page.dart';


final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('updateUserVision');


class GoalsPage extends StatefulWidget {
  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {


  List photos = ["","", ""];
  String vision = "";
  String uniqueIdentifier = "";
  List pointsNumbers = [];
  List pointsDates = [];


  defaultInitialization() async{
    final prefs = await SharedPreferences.getInstance();
    vision = prefs.getString(kUserVision)!;
    uniqueIdentifier = prefs.getString(kUniqueIdentifier)!;

    setState(() {

    });

  }

  // bool isDateToday = false;
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('users');

  void separateChartData(List<dynamic> chartData) {
    List<int> numbersArray = [];
    List<DateTime> datesArray = [];

    for ( var data in chartData) {
      String newData = data.toString();
      List splitData = newData.split('?');
      print("POPOPOP: $splitData");
      if (splitData.length == 2) {
        int? number = int.tryParse(splitData[0]);
        DateTime? date = DateTime.tryParse(splitData[1]);

        if (number != null) {
          numbersArray.add(number);
        }

        if (date != null) {
          datesArray.add(date);
        }
      }
    }
    pointsNumbers = numbersArray;
    pointsDates = datesArray;

    // Print the separated arrays
    print('Numbers Array: $numbersArray');
    print('Dates Array: $datesArray');
    // setState(() {
    //
    // });
  }



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
          child:

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Container(
              //   height: 200,
              //     child: LineChartWidget(graphValues:[
              //
              //       FlSpot(0, 80),
              //       FlSpot(1, 40),
              //       FlSpot(2, 60),
              //       FlSpot(3, 20),
              //       FlSpot(4, 60),
              //       FlSpot(5, 80),
              //       FlSpot(6, 20),
              //
              //     ],)
              // ),
              // kLargeHeightSpacing,
              FutureBuilder<QuerySnapshot>(
                future: dataCollection.where('docId', isEqualTo: uniqueIdentifier).limit(7).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching data'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(

                      ),
                    );
                  }

                  List chartData = snapshot.data!.docs.map((doc) {
                    return doc['articleCountValues'] ;
                  }).toList();
                  separateChartData(chartData[0]);

                  return Container(
                      height: 200,
                      child:
                      // Text(chartData[0].toString(), style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)
                      LineChartWidget(
                        graphValues:
                        //List.generate(chartData[0].length, (index) {
                        List.generate(pointsNumbers.length, (index) {
                          return
                            //FlSpot(index.toDouble(), chartData[index])
                            FlSpot(index.toDouble(), pointsNumbers[index].toDouble())
                          ;
                        }
                        ),
                        targetValues: [

                          FlSpot(0, 10),
                          FlSpot(1, 30),
                          FlSpot(2, 20),
                          FlSpot(3, 40),
                          FlSpot(4, 50),
                          FlSpot(5, 60),
                          FlSpot(6, 90),

                        ],
                      )
                  );


                  //   Container(
                  //   height: 100,
                  //   child: LineChart(
                  //     LineChartData(
                  //       // Rest of the chart configuration...
                  //       minX: 0,
                  //       maxX: chartData.length.toDouble() - 1,
                  //       minY: 0,
                  //       maxY: 100,
                  //       lineBarsData: [
                  //         LineChartBarData(
                  //           spots: List.generate(chartData.length, (index) {
                  //             return FlSpot(index.toDouble(), chartData[index]);
                  //           }),
                  //           // Rest of the chart configuration...
                  //         ),
                  //       ],
                  //       // Rest of the chart configuration...
                  //     ),
                  //   ),
                  // );
                },
              ),
              Center(
                child:
                Lottie.asset('images/workout4.json', height: 130, width: 150, fit: BoxFit.cover,),
              ),
              kLargeHeightSpacing,
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                child: Text("Take a Photo working towards your goal to get points",textAlign: TextAlign.justify, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 15),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  photos[0] == ""? PhotoWidget(): Container(height: 100, width: 100,color: kBabyPinkThemeColor,),
                  kMediumWidthSpacing,
                  photos[1] == ""? GoalsWidget(vision: vision,): Container(height: 100, width: 100,color: kBabyPinkThemeColor,),
                  // kMediumWidthSpacing,
                  // photos[2] == ""? PhotoWidget(): Container(height: 100, width: 100,color: kBabyPinkThemeColor,),
                ],
              ),
              Spacer(),

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

class GoalsWidget extends StatelessWidget {
  GoalsWidget({required this.vision});
  final String vision;
  final auth = FirebaseAuth.instance;

  String question = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              }
          );



        }else{
          // Navigator.pushNamed(context, HomePage.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> YourVision())
          );
        }

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
        child: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: vision == null? Text("Set Your Goal", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),) : Text(vision, textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 10),),
        ))
      ),
    );
  }
}
