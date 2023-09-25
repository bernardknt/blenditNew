import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/execution_pages/get_a_number_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../models/CommonFunctions.dart';
import '../../../utilities/font_constants.dart';
import '../../../widgets/gliding_text.dart';
import '../models/basketItem.dart';
import '../models/blendit_data.dart';
import '../widgets/SelectedIngredientsListView.dart';
import 'loading_ingredients_page.dart';



class AiJuice extends StatefulWidget {
  //  static String id = 'success_challenge_new';

  @override
  _AiJuiceState createState() => _AiJuiceState();
}

class _AiJuiceState extends State<AiJuice> {



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
  // var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];
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
    setState(() {

    });
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
      // setState(() {
      //
      // });
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
    var blendedData = Provider.of<BlenditData>(context, listen: false);


    return Scaffold(
      backgroundColor: kPureWhiteColor,

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
        //.doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("EEEEERRRRRRRROOOOOORRR");
          }
          // return Container(child: Text("Nice",style: kHeading2TextStyleBold,),);
          String jsonString = '{"ingredients": "","instructions": "","purpose": "","urgency": "", "type":"", "youtube":""}';

          // Access the vision field from the snapshot
          final vision = snapshot.data?['activeJuice'] ?? jsonString;

          // Parse the vision JSON string
          final visionData = jsonDecode(vision);

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Card(
                      color: kCustomColor,
                      shape: const RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(20))),
                      // shadowColor: kGreenThemeColor,
                      // color: kBeigeColor,
                      elevation: 1.0,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 260,
                            child:
                            Center(child: GlidingText(
                              text: visionData['purpose'],
                              delay: const Duration(seconds: 1),
                            ),

                            )
                        ),
                      ),
                    ),

                    Stack(
                      children: [
                        Lottie.asset('images/bilungo.json', height: 150, ),
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
                                  child: Text(visionData['type'], style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 10),),
                                )))
                      ],
                    ),
                   Text("${visionData['type']} for: \n${visionData['summary']}",textAlign: TextAlign.center, style: kHeading2TextStyleBold,),
                    kLargeHeightSpacing

                  ],
                ),
                Container(
                  height: 290,
                  // width: 200,
                  child:
                  ListView.builder(
                    itemCount: visionData['ingredients'].length,
                    itemBuilder: (
                        BuildContext context, int index)
                    {
                      return GestureDetector(
                        onTap: (){
                          // aiDataDisplay.setPreferencesBoxColor(index, aiData.preferencesColorOfBoxes[index], visionData['action'][index], visionData['action'][index]);
                          // print(visionData['ingredients'][index]);
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
                             "${index+1}. ${visionData['ingredients'][index]}",
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
                kLargeHeightSpacing,
                // Linkify(
                //     onOpen: (link) {
                //       CommonFunctions().goToLink(link.url);
                //     },
                //     style: kNormalTextStyle2.copyWith(color:kBlueDarkColor,
                //         fontSize: 15, fontWeight: FontWeight.w400),
                //     linkStyle: TextStyle(color: Colors.blue),
                //     text: visionData['youtube']),
                // kSmallHeightSpacing,
                // Text("Recipe", style: kNormalTextStyle.copyWith(color: kBlack),),
                // Text(visionData['instructions'].toString()),

                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: (){
                            CommonFunctions().goToLink(visionData['youtube']);
                          }, child: Icon(FontAwesomeIcons.youtube, color: kPureWhiteColor,)),
                      kSmallWidthSpacing,
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kBlack)),
                          onPressed: (){

                            showDialog(context: context, builder: (BuildContext context){
                              return GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Material(
                                      color: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${visionData['type']} Instructions for ${visionData['purpose']}", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontWeight: FontWeight.bold),),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(

                                                height: visionData['instructions'].length < 6? 270:380,
                                                decoration: BoxDecoration(
                                                    color:  kBiegeThemeColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:
                                                  ListView.builder(
                                                    itemCount: visionData['instructions'].length,
                                                    itemBuilder: (
                                                        BuildContext context, int index)
                                                    {
                                                      return GestureDetector(
                                                        onTap: (){
                                                          // aiDataDisplay.setPreferencesBoxColor(index, aiData.preferencesColorOfBoxes[index], visionData['action'][index], visionData['action'][index]);
                                                          // print(visionData['ingredients'][index]);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                                                          child: Text(
                                                            "${index+1}. ${visionData['instructions'][index]}",
                                                            style: TextStyle( fontSize: visionData['instructions'].length < 6? 20 : 16,
                                                              color: kBlueDarkColor,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),

                                                  //Text('${taskList[index]}',textAlign: TextAlign.center, style: kNormalTextStyleDark.copyWith(color: kBlack, fontSize: 20),),
                                                )),
                                          ),
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,
                                          kLargeHeightSpacing,


                                        ],
                                      )));
                            });


                          }, child: Text("Recipe", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
                      kSmallWidthSpacing,
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
                          onPressed: (){
                            // for(int i = 0; i < visionData['ingredients']; i++ ){
                              Provider.of<BlenditData>(context, listen: false).setSelectedJuiceIngredients(visionData['ingredients']);

                            // }

                            // showModalBottomSheet(
                            //     context: context,
                            //     builder: (context) {
                            //
                            //       return SelectedJuiceIngredientsListView();
                            //
                            //     });
                            //   Vibrate.vibrateWithPauses(pauses);
                              Navigator.pop(context);
                              Navigator.pushNamed(context, LoadingIngredientsPage.id);
                              Provider.of<BlenditData>(context, listen: false)
                                  .addToBasket(BasketItem(amount: blendedData.refJuicePrice, quantity: blendedData.litres, name: 'Custom Juice', details: blendedData.selectedJuiceIngredients.join(", "))); //
                              Provider.of<BlenditData>(context, listen: false).clearListJuice();

                          }, child: Text("Order This Recipe", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),

                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
