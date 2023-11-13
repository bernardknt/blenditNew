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

