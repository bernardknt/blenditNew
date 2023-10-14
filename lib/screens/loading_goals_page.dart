import 'dart:async';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import 'ai_juice.dart';

class LoadingGoalsPage extends StatefulWidget {
  @override
  _LoadingGoalsPageState createState() => _LoadingGoalsPageState();
}

class _LoadingGoalsPageState extends State<LoadingGoalsPage> {
  Timer? _timer;
  var inspiration =
      "Consistency is the key to unlocking the door to a healthy lifestyle. It's not about being perfect; it's about making small, positive choices day in and day out.";

  String _displayText = '';
  int _characterIndex = 0;
  double opacityValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _animationTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed of
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer = Timer.periodic(Duration(milliseconds: 70), (timer) {
      setState(() {
        if (_characterIndex < inspiration.length) {
          _displayText += inspiration[_characterIndex];
          _characterIndex++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  _animationTimer() async {
    final prefs = await SharedPreferences.getInstance();
    _timer = Timer(const Duration(milliseconds: 12000), () {
      prefs.setBool(kChallengeActivated, true);
      setState(() {
        opacityValue = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColorOld,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('images/stir.json',
                height: 200, width: 200, fit: BoxFit.contain),
            kSmallHeightSpacing,
            Center(
              child: Text(
                _displayText,
                textAlign: TextAlign.center,
                style: kHeading2TextStyleBold.copyWith(fontSize: 15, color: kPureWhiteColor),
              ),
            ),
            kLargeHeightSpacing,
            Opacity(
              opacity: opacityValue,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String id = prefs.getString(kUniqueIdentifier)!;
                  Provider.of<AiProvider>(context, listen: false).resetQuestionButtonColors();
                  Provider.of<AiProvider>(context, listen: false).setUserId(id);

                  Navigator.pushNamed(context, AiJuice.id);

                    // Navigator.push(context,
                    //    // MaterialPageRoute(builder: (context)=> TargetsPage())
                    //     MaterialPageRoute(builder: (context)=> AiJuice())
                    // );
                  // Additional code here...
                },
                child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:math';
// import 'package:blendit_2022/models/ai_data.dart';
// import 'package:blendit_2022/screens/execution_pages/targets_page.dart';
// import 'package:blendit_2022/utilities/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utilities/font_constants.dart';
// import 'ai_juice.dart';
// import 'goals.dart';
// import 'home_page.dart';
//
//
// class LoadingGoalsPage extends StatefulWidget {
//   //  static String id = 'success_challenge_new';
//
//   @override
//   _LoadingGoalsPageState createState() => _LoadingGoalsPageState();
// }
//
// class _LoadingGoalsPageState extends State<LoadingGoalsPage> {
//
//
//
//   late Timer _timer;
//   var random = Random();
//  // var inspiration = "Success is a journey shared with those who lift you HIGHER. With Support, Accountability and the right Challenge, every step is a VICTORY in the making.";
//   var inspiration = "Consistency is the key to unlocking the door to a healthy lifestyle. It's not about being perfect; it's about making small, positive choices day in and day out, because it's the consistent drops of water that eventually fill the ocean of well-being.";
//   var message  = ['Well done', 'Keep Going', 'Your doing Great', 'You are killing this Challenge', 'Keep Going', 'Your a Champion', 'Standing Ovation👏', 'Keep going', 'You are winning'];
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//   // Future<Object?> getUserAge(String uid) async {
//   //
//   //   final prefs = await SharedPreferences.getInstance();
//   //
//   //   final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//   //   prefs.setString(kUserVision, userDoc["vision"]);
//   //   final userData = userDoc.data();
//   //
//   //   return userData;
//   // }
//   @override
//
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _startTyping();
//     animationTimer();
//   }
//   String _displayText = '';
//   int _characterIndex = 0;
//   double opacityValue = 0.0;
//   final String _text = 'Hello World';
//
//   void _startTyping() {
//     Timer.periodic(Duration(milliseconds: 70), (timer) {
//       setState(() {
//         if (_characterIndex < inspiration.length) {
//           _displayText += inspiration[_characterIndex];
//           _characterIndex++;
//         } else {
//           timer.cancel();
//         }
//       });
//     });
//   }
//
//   final _random = new Random();
//   animationTimer() async{
//     final prefs = await SharedPreferences.getInstance();
//     // final player = AudioCache();
//     // player.play("transition.wav");
//     _timer = Timer(const Duration(milliseconds: 12000), () {
//       prefs.setBool(kChallengeActivated, true);
//
//
//       // Navigator.pop(context);
//       opacityValue = 1.0;
//       setState(() {
//
//
//
//       });
//
//
//     });
//   }
//
//   Widget build(BuildContext context) {
//     // var points = Provider.of<BlenditData>(context, listen: false).rewardPoints ;
//
//     return Scaffold(
//       backgroundColor: kBlueDarkColorOld,
//       body: Container(
//
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//
//           children: [
//             Lottie.asset('images/stir.json', height: 200, width: 200, fit: BoxFit.contain ),
//             kSmallHeightSpacing,
//             Center(child: Text(_displayText ,textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(fontSize: 15, color: kPureWhiteColor),)),
//             kLargeHeightSpacing,
//             Opacity(
//               opacity: opacityValue,
//               child: ElevatedButton(
//                   style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
//                   onPressed: ()async {
//                     Navigator.pop(context);
//                     Provider.of<AiProvider>(context, listen: false).resetQuestionButtonColors();
//                     Navigator.push(context,
//                        // MaterialPageRoute(builder: (context)=> TargetsPage())
//                         MaterialPageRoute(builder: (context)=> AiJuice())
//                     );
//
//                   }, child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),
//             ),
//             // kSmallHeightSpacing,
//             // Lottie.asset('images/challenge.json', height: 50, width: 150,),
//
//             // SizedBox(height: 10,),
//             // Center(child: Text('You have Earned',textAlign: TextAlign.center, style: GoogleFonts.lato( fontSize: 30),)),
//             //SizedBox(height: 10,),
//             // Center(child: Text('${points.toString()} points',textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),)),
//           ],
//         ),
//       ),
//     );
//   }
// }
