import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
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
  var rulesList = [];
  var challengeId = [];
  var opacityList = [];
  var tokenList = [];
  var shoppingList = [];
  List<Map> daysList = [];
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
                  daysList = [];
                  opacityList = [];
                  rulesList = [];
                  totalList = [];
                  positionList = [];
                  promoList = [];
                  communityList = [];
                  shoppingList = [];

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
                        communityList.add(challenge.get('community'));
                        shoppingList.add(challenge.get('shopping'));
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

                    //  }

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
                              shoppingList[index]
                            );

                            print('WALALALLA ${daysList[index]}');
                            Navigator.pushNamed(context, ChallengePage.id);

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



