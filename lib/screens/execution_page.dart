
import 'dart:convert';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/loading_challenge.dart';
import 'package:blendit_2022/screens/your_vision.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/memories_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../models/CommonFunctions.dart';
import '../widgets/chart_widget.dart';
import 'coach_page.dart';
// import 'delivery_page.dart';
import 'execution_pages/wildly_important_goal.dart';
import 'loading_goals_page.dart';
import 'nutri_mobile_money.dart';


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
  List rawDailyTasks = [];
  List dailyTasks = [];
  List dailyTasksBooleans = [];
  List pointsDates = [];
  Color appInterfaceColor = kBackgroundGreyColor;
  Color appFontColor = kBlack;
  String question = "";
  String goal = "";
  var pointsList = [];
  final auth = FirebaseAuth.instance;

 coachCalling(){

   var start = FirebaseFirestore.instance.collection('users').where('docId', isEqualTo: uniqueIdentifier)
       .where('coach', isEqualTo: true)
       .snapshots().listen((QuerySnapshot querySnapshot) {
     querySnapshot.docs.forEach((doc) async {
       // setState(() {
       //
       // });
       showModalBottomSheet(
           isScrollControlled: true,
           context: context,

           builder: (context) {
             return Container(color: kBackgroundGreyColor,
               child: CoachMessaging(),
               // InputPage()
             );
           });



     });
   });
   return start;
 }

  defaultInitialization() async{


    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonMap = json.decode(prefs.getString(kUserVision)!);

    //
    vision = jsonMap['vision'];
    goal = jsonMap['goal'];
    // goal = prefs.getString(kGoalConstant)!;
    uniqueIdentifier = prefs.getString(kUniqueIdentifier)!;
    // if(Provider.of<AiProvider>(context, listen: false).iosUpload == false){
    //
    // }



    setState(() {
      coachCalling();
    });

  }

  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('users');

  void splitArrayElements(List data) {
    List<bool> booleanArray = [];
    List<String> stringArray = [];


    for (String element in data) {
      List<String> splitValues = element.split("?");
      if (splitValues.length == 2) {
        bool booleanValue = splitValues[0].toLowerCase() == "true";
        booleanArray.add(booleanValue);
        stringArray.add(splitValues[1]);
      }
    }
    dailyTasks = stringArray;
    dailyTasksBooleans = booleanArray;
    print("Boolean Array: $booleanArray");
    print("String Array: $stringArray");
  }

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
            Container(
                width: 250,
                child: GestureDetector(

                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return
                          CupertinoAlertDialog(
                          title: const Text('YOUR GOAL'),
                          content: Text(goal, style: kNormalTextStyle.copyWith(color: kBlack),),
                          actions: [CupertinoDialogAction(isDestructiveAction: true,
                              onPressed: (){
                                // _btnController.reset();
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'))],
                        );
                      });
                    },

                    child: Center(child: Text(goal,overflow: TextOverflow.fade, style: kNormalTextStyle.copyWith(color: kBlack,  fontSize: 14, fontWeight: FontWeight.bold),)))),
            kSmallWidthSpacing,
            GestureDetector(
                onTap: ()async {
                  final prefs = await SharedPreferences.getInstance();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> WildlyImportantGoal())
                  );
                  // CoolAlert.show(
                  //
                  //     lottieAsset: 'images/goal.json',
                  //     context: context,
                  //     type: CoolAlertType.success,
                  //     widget: SingleChildScrollView(
                  //
                  //         child:
                  //         Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child:
                  //               TextField(
                  //                 onChanged: (enteredQuestion){
                  //                   question = enteredQuestion;
                  //                   // instructions = customerName;
                  //                   // setState(() {
                  //                   // });
                  //                 },
                  //                 decoration: InputDecoration(
                  //                     border:
                  //                     //InputBorder.none,
                  //                     OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(10),
                  //                       borderSide: BorderSide(color: Colors.green, width: 2),
                  //                     ),
                  //                     labelText: 'Goal',
                  //                     labelStyle: kNormalTextStyleExtraSmall,
                  //                     hintText: 'This year I want to lose 10kg',
                  //                     hintStyle: kNormalTextStyle
                  //                 ),
                  //
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //     ),
                  //     text: 'Set a goal you want to achieve',
                  //     title: "${prefs.getString(kFirstNameConstant)}!",
                  //     confirmBtnText: 'Set Goal',
                  //     confirmBtnColor: Colors.green,
                  //     backgroundColor: kBackgroundGreyColor,
                  //     onConfirmBtnTap: () async{
                  //       if (question != ""){
                  //         final prefs = await SharedPreferences.getInstance();
                  //         prefs.setString(kGoalConstant, question);
                  //         prefs.setBool(kIsGoalSet, true);
                  //         Navigator.pop(context);
                  //         prefs.setString(kUserId, auth.currentUser!.uid);
                  //         // updatePersonalInformationWithGoal();
                  //         dynamic serverCallableVariable = await callableGoalUpdate.call(<String, dynamic>{
                  //           'goal': question,
                  //           'userId':auth.currentUser!.uid,
                  //           // orderId
                  //         });
                  //         // Navigator.pushNamed(context, SuccessPageNew.id);
                  //         Navigator.push(context,
                  //             MaterialPageRoute(builder: (context)=> LoadingGoalsPage())
                  //         );
                  //       } else {
                  //
                  //       }
                  //     }
                  // );
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
                        rawDailyTasks = doc["dailyTasks"];
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
                          )
                      );


                    },
                  ),
                  kLargeHeightSpacing,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(

                                ),
                              );
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

                                      pointsList[0] < 50 ? Text("${pointsList[0]}/100", style: kNormalTextStyle.copyWith(color: Colors.red, fontSize: 12,fontWeight: FontWeight.bold),):
                                       Text("${pointsList[0]}/100", style: kNormalTextStyle.copyWith(color: kGreenThemeColor, fontSize: 12,fontWeight: FontWeight.bold),),
                                      kSmallWidthSpacing,
                                      kSmallWidthSpacing,
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamed(context, MemoriesPage.id);
                                          Get.snackbar(
                                              'Daily Points Count',
                                              'You have ${pointsList[0]} Goal points today. Keep Going💪',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: kCustomColor,
                                              colorText: kBlack,
                                              icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
                                        },
                                        child: SimpleCircularProgressBar(
                                          backColor: kBlueDarkColor,
                                          size: 20,
                                          progressColors: [kGreenThemeColor, Colors.red, Colors.blue ],
                                          progressStrokeWidth: 4,
                                          backStrokeWidth: 10,
                                          // valueNotifier: ValueNotifier(Provider.of<AiProvider>(context, listen: false).progressPoints * 1.0),
                                          valueNotifier: ValueNotifier(pointsList[0].toDouble()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              //Text('Hi ${pointsList}', style: kNormalTextStyle.copyWith(color: kBlack),);

                            }

                          }

                      ),
                      Text("Weeks Focus",style: kNormalTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: kBlack),),
                      Lottie.asset('images/workout4.json', height: 40, width: 50, fit: BoxFit.cover,),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Stack(
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
                              return Container();
                              //   const
                              // Center(
                              //   child: CircularProgressIndicator(
                              //
                              //   ),
                              // );
                            }

                            var orders = snapshot.data?.docs;
                            for( var doc in orders!) {
                              rawDailyTasks = doc["dailyTasks"];
                              // pointsList.add(doc['articleCount']??0);
                            }

                            splitArrayElements(rawDailyTasks);


                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: kCustomColor,
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: ListView.builder(
                                itemCount:  rawDailyTasks.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(

                                    // dense: true,
                                    // tileColor: kGreenThemeColor,
                                    // enabled: false,

                                    title: Text(

                                      dailyTasks[index],
                                      style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 12),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    value: dailyTasksBooleans[index],
                                    onChanged: (bool? value) {
                                      CommonFunctions().pickImage(ImageSource.camera,   'goal${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context);

                                      // setState(() {
                                      //   value = value!;
                                      // });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                    activeColor: kBlueThemeColor,

                                    checkColor: kPureWhiteColor,
                                  );
                                },
                              ),
                            );



                          },
                        ),


                        Positioned(
                            right: 10,
                            bottom: 20,

                            child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, MemoriesPage.id);

                                },

                                child:  CircleAvatar(
                                    backgroundColor: kBlueDarkColor,
                                    child: Icon(Iconsax.magic_star , size: 20, color: kPureWhiteColor,))))
                      ],
                    ),
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kBlueDarkColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async{
                        // Navigator.pushNamed(context, CustomerCareChatMessaging.id);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,

                            builder: (context) {
                              return Container(color: kBackgroundGreyColor,
                                child: CoachMessaging(),
                                // InputPage()
                              );
                            });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> LoadingChallengePage())
                        );
                        // Navigator.pushNamed(context, LoadingChallengePage.id);

                      },


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Contact Coach", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                          kSmallWidthSpacing,

                        ],
                      )),


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
