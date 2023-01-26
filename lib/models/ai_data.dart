

import 'package:blendit_2022/utilities/icons_constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../utilities/constants.dart';
import 'challengeDays.dart';

class AiProvider extends ChangeNotifier{

  List buttonColourQuestions = [Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,];
  String userSex = '';
  List<Color> preferencesColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor];
  List preferencesSelected = [];
  List <String>preferencesIdSelected = [];
  DateTime userBirthday = DateTime.now();
  DateTime appointmentDate = DateTime.now();
  DateTime appointmentTime = DateTime.now();
  Color preferencesContinueColor = kCustomColor;
  List <Color> welcomeButtons = [kPureWhiteColor, kPureWhiteColor, kPureWhiteColor];
  List <Color> welcomeFontColors = [kFontGreyColor, kFontGreyColor, kFontGreyColor];
  List <IconData> welcomeIcons = [Icons.cancel_outlined, Icons.cancel_outlined, Icons.cancel_outlined];
  List <IconData> dayIcons = [Icons.circle, Icons.circle, Icons.circle, Icons.circle, Icons.circle, Icons.circle, Icons.circle];
  List <Color> dayIconsColor = [kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor,kGreenThemeColor, ];
  List <Color> dayGoalColors = [Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange , ];
  // List <IconData> dayIcons = [LineIcons.checkCircle,LineIcons.checkCircle,LineIcons.checkCircle,LineIcons.checkCircle,LineIcons.checkCircle,LineIcons.checkCircle,LineIcons.checkCircle, ];
  //List  dayIcons = [kIconCheckMark, kIconCheckMark, kIconCheckMark,kIconCheckMark, kIconCheckMark, kIconCheckMark,kIconCheckMark, kIconCheckMark, kIconCheckMark,kIconCheckMark, kIconCheckMark, kIconCheckMark,kIconCheckMark, kIconCheckMark, kIconCheckMark,kIconCheckMark, kIconCheckMark, kIconCheckMark, ];
  List  welcomeFacts = [false, false, false];
  bool goToNextLevel = false;

  // Challenge Variables

  String challengeName = '';
  String challengeDescription = '';
  String challengeWelcomeMessage = '';
  int challengePosition = 0;
  String challengeRules = '';
  String challengeSchedule = '';
  String challengeId = '';
  List challengeDaysKeys = [];
  List challengeDaysValues = [];
  String challengeShoppingList = '';
  int activeChallengeIndex = 0;
  Map<String, dynamic> challengeDays = {};
  List <Step> challengeSteps = [Step(title: Text("TEST"), content: Text('Infor'))];

  List challengeDayData = [];


 // setChangeLottieImage(int index, IconData image){
 //   dayIcons[index] = image;
 //   notifyListeners();
 // }
  setChallengePosition (){
    challengePosition += 1;
    activeChallengeIndex = 0;
    // lottieImages[challengePosition + 1] = 'images/letsgo.json';
    // for (var i = 0; i < challengePosition; i++) {
    //   lottieImages[i] = 'images/cloud.json';
    // }
    notifyListeners();
  }


  setGoToNextLevel(value){
    goToNextLevel = value;
    notifyListeners();
  }

  setActiveChallengeIndexFromServer(position){
    print(position);
    if (position != 0 ){
      for(var i = 0; i< position; i++){
        dayGoalColors[i] = kGreenThemeColor;
      }
    }else{
      dayGoalColors[0] = Colors.orange;
    }
  }

  resetChallengeDayColors(){
dayGoalColors = [Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange ,Colors.orange , ];

    notifyListeners();
  }

  setActiveChallengeIndex(index){
    activeChallengeIndex += 1;
    dayGoalColors[index] = kGreenThemeColor;
    notifyListeners();
  }
  setAppointmentTimeDate(date, time){
    appointmentDate = date;
    appointmentTime = time;

    notifyListeners();
  }

  setChallengeParameters (id, name, description, welcomeMessage, rules, schedule, position, days, daysValues, shopping, activePosition, challengeDaysIndex){
    challengeId = id;
    challengeName = name;
    challengeDescription = description;
    challengeWelcomeMessage = welcomeMessage;
    challengeRules = rules;
    challengeSchedule = schedule;
    challengePosition = position;
    challengeDaysKeys = days;
    challengeDaysValues = daysValues;
    challengeShoppingList = shopping;
    activeChallengeIndex = activePosition;
    challengeDays = challengeDaysIndex;


    if (position > 0 ){
      welcomeButtons = [kCustomColor, kCustomColor, kCustomColor];
      welcomeFontColors = [kBlack, kBlack, kBlack];
      welcomeIcons= [Icons.check_circle, Icons.check_circle, Icons.check_circle];
      welcomeFacts= [true, true, true];
      dayIconsColor[position - 1] = Colors.orange;
      for (var i = 0; i < position - 1; i++) {
        dayIcons[i] = LineIcons.checkCircle;
        dayIconsColor[i] = kGreenThemeColor;
      }
    }
    notifyListeners();
  }

  void resetToDefaultValues(){

    notifyListeners();
  }

  void setWelcomeButtons(index){
    welcomeButtons[index] = kCustomColor;
    welcomeFontColors[index] = kBlack;
    welcomeIcons[index] = Icons.check_circle;
    welcomeFacts[index] = true;
    notifyListeners();
  }

  void setPreferencesBoxColor(index, color, name, id){
    print(name);

    if (color!= kGreenThemeColor){
      preferencesSelected.add(name);
      preferencesIdSelected.add(id);
      preferencesColorOfBoxes[index] = kGreenThemeColor;
    }else {
      preferencesColorOfBoxes[index] = kCustomColor;
      preferencesSelected.remove(name);
      preferencesIdSelected.remove(id);
    }
    if (preferencesIdSelected.isNotEmpty){
      preferencesContinueColor = kGreenThemeColor;
    }else{
      preferencesContinueColor = kCustomColor;
    }

    notifyListeners();
  }


  void resetQuestionButtonColors(){
    preferencesColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,];
    preferencesIdSelected = [];
    preferencesSelected = [];
    notifyListeners();

  }

  void setUserBirthday(day){

    userBirthday = day;
    notifyListeners();
  }

  void setButtonBoxColors(buttonIndex, sex){
    buttonColourQuestions[buttonIndex] = kGreenThemeColor;
    userSex = sex;
    notifyListeners();
  }

  void setChallengeDays (ChallengeDays listData){
    challengeDayData.add(listData);
    // print('YUYUYUYUYUYUYUYU ${listData.answers}');
    notifyListeners();
  }
}