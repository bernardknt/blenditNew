import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/models/challengeDays.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
import 'package:blendit_2022/screens/onboarding_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../utilities/icons_constants.dart';
import '../widgets/roundedIcon.dart';



class ChallengeActivePage extends StatefulWidget {
  static String id = 'events_page';

  @override
  _ChallengeActivePageState createState() => _ChallengeActivePageState();
}

class _ChallengeActivePageState extends State<ChallengeActivePage> {


  void defaultsInitiation() async{
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(kPhoneNumberConstant)!;
    setState((){
    });


  }
  // OVERRIDE INITIAL STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();

  }


  // Variables
  String title = 'Your';
  String userId = '';
  var date = [];
  var welcomeMessageList = [];
  var time = [];
  var formatter = NumberFormat('#,###,000');
  var challengeName = [];
  var nameList = [];
  var imgList = [];
  var scheduleList = [];
  var challengeStatus = [];
  var rulesList = [];
  var challengeId = [];
  var opacityList = [];
  var tokenList = [];
  var shoppingList = [];
  var activePositionList = [];
  List<Map<String, dynamic>> daysList = [];
  var costList = [];
  var pendingList = [];
  var positionList = [];
  var communityList = [];
  var promoList = [];
  var totalList = [];
  var token;

 // var containerToDisplay = Padding(padding: EdgeInsets.all(10), child: Center(child: Text('You have no Appointments Scheduled', style: kHeadingTextStyle,),),);
  @override

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      backgroundColor: kGreyLightThemeColor,

        body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('challenges')
                  .where('client_phoneNumber', isEqualTo: userId)
                  .where('active', isEqualTo: true)
                  .where('completed', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print(userId);

                } else {
                  date = [];
                  welcomeMessageList = [];
                  nameList = [];
                  imgList = [];
                  scheduleList = [];
                  challengeId = [];
                  opacityList = [];
                  tokenList = [];
                  costList = [];
                  challengeName = [];
                  challengeStatus = [];
                  daysList = [];
                  opacityList = [];
                  rulesList = [];
                  totalList = [];
                  positionList = [];
                  promoList = [];
                  communityList = [];
                  shoppingList = [];
                  activePositionList = [];

                  var challengeData = snapshot.data!.docs;
                  for (var challenge in challengeData) {

                        imgList.add(challenge.get('image'));
                        scheduleList.add(challenge.get('schedule'));
                        rulesList.add(challenge.get('rules'));
                        challengeId.add(challenge.get('orderNumber'));
                        nameList.add(challenge.get('client'));
                        promoList.add(challenge.get('promo'));
                        welcomeMessageList.add(challenge.get('welcome'));
                        costList.add(challenge.get('total_price'));
                        challengeName.add(challenge.get('challenge'));
                        daysList.add(challenge.get('days'));
                        positionList.add(challenge.get('position'));
                        challengeStatus.add(challenge.get('challengeStatus'));
                        communityList.add(challenge.get('community'));
                        shoppingList.add(challenge.get('shopping'));
                        activePositionList.add(challenge.get('activePosition'));
                        date.add(challenge.get('challengeStartTime').toDate());

                        if (challenge.get('challengeStatus') == false){
                          opacityList.add(0.0);
                          pendingList.add(1.0);
                          if(challenge.get('status') == 'Product'){
                            positionList.add(true);

                          }else {
                            positionList.add(false);
                          }

                        }else{
                          opacityList.add(1.0);
                          pendingList.add(0.0);
                        }

                    print(daysList);

                  }

                }
                return challengeId.length == 0 ?
                Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Challenges🫣.\nIt looks lonely Here', style: kNormalTextStyle.copyWith(color: kBlack),),
                    Lottie.asset('images/workout6.json', height: 200)
                    
                  ],
                ),) :
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(

                      itemCount: imgList.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: ()async{
                           //  print("BEGIN: ${daysList[index]}: END");
                           // // List < Map<String, dynamic>> data = daysList[index].entries.toList();
                           //  var myMap = daysList[index];
                           //  List<Map<String, dynamic>> myList = myMap.entries.map((entry) => {'key': entry.key, 'value': entry.value}).toList();
                           //  myList.sort((a, b) => a.keys.last.compareTo(b.keys.first));
                           //
                           //
                           //  // Map<String, dynamic> myMapBack = Map<String, dynamic>();
                           //  Map<String, dynamic> myMapBack = Map.fromEntries(myList.map((item) => MapEntry(item['key'], item['value'])));
                           //
                           //  // print(myList);
                           //  print("ANALYZE OLD: ${myList}");
                           //  print("ANALYZE NEW: ${myMapBack}");
                           //  Provider.of <AiProvider> (context, listen: false).setChallengeDays(ChallengeDays(
                           //      day: day,
                           //      timestamp:
                           //      timestamp,
                           //      activity:
                           //      activity));



                           //  final sorted = new SplayTreeMap<String,dynamic>.from(map, (a, b) => a.compareTo(b));
                           //  List sortedList = data.entries.toList()..sort((entry1, entry2) => entry1.value.compareTo(entry2.value));
                           //  print("WAHAMBANATI: $sortedList");
                            // Provider.of<AiProvider>(context, listen: false).resetChallengeDayColors();
                            // var map = SortedMap(Ordering.byValue());
                            // map.addAll(daysList[index]);
                            // // print(map);


                            // map.sort((a, b) => a.weight.compareTo(b.weight));
                            Provider.of<AiProvider>(context, listen: false).setActiveChallengeIndexFromServer(activePositionList[index]);

                            Provider.of<AiProvider>(context, listen:false).setChallengeParameters(
                                challengeId[index],
                                challengeName[index],
                                promoList[index],
                                welcomeMessageList[index],
                                rulesList[index],
                                scheduleList[index],
                                positionList[index],
                                daysList[index].keys.toList(),
                                daysList[index].values.toList(),
                                shoppingList[index],
                              activePositionList[index],
                              daysList[index]
                            );

                            print('WALALALLA ${daysList[index]}');
                            if (challengeStatus[index] == false){
                              Navigator.pushNamed(context, BlenderOnboardingPage.id);

                            }else{
                              Navigator.pushNamed(context, ChallengePage.id);
                            }


                          },
                          child:
                          Stack(
                              children: [
                                Card(

                                  child: Row(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        Column(
                                          children: [
                                            RoundImageRing(networkImageToUse: imgList[index], outsideRingColor: kBeigeThemeColor, radius: 150,),

                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(challengeName[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: kHeadingTextStyle,),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  kIconCalendar,
                                                  kSmallWidthSpacing,
                                                  Text(DateFormat('dd, MMMM, yyyy').format(date[index]),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kNormalTextStyle),
                                                ],
                                              ),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  kIconClock,
                                                  kSmallWidthSpacing,
                                                  Text('${daysList[index].keys.toList().length} Days',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kNormalTextStyle),
                                                    
                                                  // Text(DateFormat('hh:mm ').format(date[index]),
                                                  //   style: kNormalTextStyle
                                                  //   ,),
                                                ],
                                              ),
                                              kSmallHeightSpacing,
                                              Row(
                                                children: [
                                                  Icon(Icons.qr_code_2_outlined, size: 20,color: kFontGreyColor,),
                                                  kSmallWidthSpacing,
                                                  Text("${challengeId[index]}",overflow: TextOverflow.visible, style: kNormalTextStyle,),
                                                ],
                                              ),
                                              kSmallHeightSpacing,

                                            ],
                                          ),),
                                      ),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  right: 10,
                                  bottom: 10,


                                  child: Opacity(
                                    opacity: pendingList[index],
                                    child: Container(


                                      decoration: const BoxDecoration(
                                          color: kBlueDarkColorOld,
                                          borderRadius: BorderRadius.all(Radius.circular(6))
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child:

                                        Text('Start Challenge', style: kNormalTextStyleWhitePendingLabel,),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,


                                  child: Opacity(
                                    opacity: opacityList[index],
                                    child: Container(


                                      decoration: const BoxDecoration(
                                          color: kAppPinkColor,
                                          borderRadius: BorderRadius.all(Radius.circular(6))
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Text('Challenge in Progress', style: kNormalTextStyleWhitePendingLabel,),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        );
                      }),
                );

                  // containerToDisplay;


              }
          ),
        )
    );
  }
}



