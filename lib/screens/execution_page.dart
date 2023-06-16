


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
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../models/CommonFunctions.dart';
import '../widgets/chart_widget.dart';
import 'delivery_page.dart';
import 'loading_goals_page.dart';


final HttpsCallable callableGoalUpdate = FirebaseFunctions.instance.httpsCallable('updateUserVision');


class ExecutionPage extends StatefulWidget {
  @override
  State<ExecutionPage> createState() => _ExecutionPageState();
}

class _ExecutionPageState extends State<ExecutionPage> {


  List photos = ["","", ""];
  String vision = "";
  String uniqueIdentifier = "";
  List pointsNumbers = [];
  List targetNumbers = [];
  List pointsDates = [];
  Color appInterfaceColor = kBackgroundGreyColor;
  Color appFontColor = kBlack;
  String question = "";
  var pointsList = [];
  final auth = FirebaseAuth.instance;
  List _getCheckboxText = ["Take 2 Liters of Water", "Take 5 minutes walking", "Take 2 Healthy meals today"];


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
      backgroundColor: appInterfaceColor, // Set background color to navy blue
      appBar: AppBar(
        backgroundColor: appInterfaceColor,
        automaticallyImplyLeading: false,
        foregroundColor:kPureWhiteColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Lose 30kgs by 30th, August, 2023", style: kNormalTextStyle.copyWith(color: appFontColor, fontSize: 14, fontWeight: FontWeight.bold),),
            kSmallWidthSpacing,
            GestureDetector(
                onTap: ()async {
                  final prefs = await SharedPreferences.getInstance();
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
                      text: 'Set a goal you want to achieve',
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
                },
                child:

            Icon(Icons.edit, color: kGreenThemeColor,size: 20,))
          ],
        ),
        centerTitle: true,


      ),
      body: SafeArea(
          child:

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


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
                        targetNumbers = doc['targetNumbers'];
                        return doc['articleCountValues'] ;
                      }).toList();

                      separateChartData(chartData[0]);

                      return Container(
                          height: 200,
                          child:
                          // Text(chartData[0].toString(), style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)
                          LineChartWidget(
                              graphValues: List.generate(pointsNumbers.length, (index) {
                                return

                                  FlSpot(index.toDouble(), pointsNumbers[index].toDouble());
                              },
                              ),
                            targetValues:
                            List.generate(targetNumbers.length, (index) {
                              return

                                FlSpot(index.toDouble(), targetNumbers[index].toDouble());
                            },
                            ),

                            // [
                            //
                            //   FlSpot(0, 10),
                            //   FlSpot(1, 30),
                            //   FlSpot(2, 20),
                            //   FlSpot(3, 40),
                            //   FlSpot(4, 50),
                            //   FlSpot(5, 60),
                            //   FlSpot(6, 90),
                            //
                            // ],
                          )
                      );


                    },
                  ),
                  // Center(
                  //   child:
                  //   Lottie.asset('images/workout4.json', height: 60, width: 70, fit: BoxFit.cover,),
                  // ),
                  kLargeHeightSpacing,
                  Text("Focus",style: kNormalTextStyle.copyWith(fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Stack(
                      children: [

                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: kBlueThemeColor,
                            borderRadius: BorderRadius.circular(10),

                          ),
                          child: ListView.builder(
                            itemCount: 3,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CheckboxListTile(

                                // dense: true,
                                tileColor: kPureWhiteColor,
                                enabled: true,





                                title: Text(
                                  _getCheckboxText[index],
                                  style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                value: false,
                                onChanged: (bool? value) {
                                  CommonFunctions().pickImage(ImageSource.camera,   'goal${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context);

                                  // setState(() {
                                  //   value = value!;
                                  // });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: kCustomColor,

                                checkColor: kBlack,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 2,
                          child:
                        StreamBuilder<QuerySnapshot> (
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('docId', isEqualTo: uniqueIdentifier)
                                .snapshots(),
                            builder: (context, snapshot)
                            {
                              if(!snapshot.hasData){
                                return Container();
                              }
                              else{
                                pointsList = [];

                                var orders = snapshot.data?.docs;
                                for( var doc in orders!) {
                                  pointsList.add(doc['articleCount']??0);
                                }
                                // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
                                return  SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: Row(
                                      children: [

                                        Text("${pointsList[0]}/100", style: kNormalTextStyle.copyWith(color: kGreenThemeColor, fontSize: 11,),),
                                        kSmallWidthSpacing,
                                        kSmallWidthSpacing,
                                        SimpleCircularProgressBar(
                                          backColor: kBlueDarkColor,
                                          size: 20,
                                          progressColors: [kGreenThemeColor, kCustomColor, Colors.blue ],
                                          progressStrokeWidth: 4,
                                          backStrokeWidth: 10,
                                          // valueNotifier: ValueNotifier(Provider.of<AiProvider>(context, listen: false).progressPoints * 1.0),
                                          valueNotifier: ValueNotifier(pointsList[0].toDouble()),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                //Text('Hi ${pointsList}', style: kNormalTextStyle.copyWith(color: kBlack),);

                              }

                            }

                        ),
                        )
                      ],
                    ),
                  ),



                  kLargeHeightSpacing,
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                    child: Text("Take a Photo working towards your goal to get points",textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: appFontColor, fontSize: 15),),
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

                  // Spacer(),

                ],
              ),
            ),
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
            color: kBlack,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.photo_camera,
          size: 48,
          color: kBlack,
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
              color: kBlack,
              width: 1,
            ),
          ),
          child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: vision == null? Text("Set Your Goal", style: kNormalTextStyle.copyWith(color: kBlack),) : Text(vision, textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),),
          ))
      ),
    );
  }
}
