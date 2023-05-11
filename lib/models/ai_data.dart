

import 'package:blendit_2022/utilities/icons_constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';

import '../utilities/constants.dart';
import 'challengeDays.dart';

class AiProvider extends ChangeNotifier{

  // List buttonColourQuestions = [Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,Colors.white12,];
  List buttonColourQuestions = [kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor,kBlueDarkColor, kBlueDarkColor, ];
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
  String ugMonthly = "19900";
  String ugYearly = "199000";
  String intMonthly = "5.99";
  String intYearly = "59.99";
  int trialTime = 3;
  bool iosUpload = false;
  List countries = [ 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi',
    'Cape Verde', 'Cameroon', 'Central African Republic', 'Chad', 'Comoros', 'Democratic Republic of the Congo', 'Republic of the Congo', 'Djibouti', 'Equatorial Guinea', 'Eritrea', 'Eswatini', 'Ethiopia', 'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Ivory Coast', 'Kenya', 'Lesotho', 'Liberia', 'Madagascar', 'Malawi', 'Mali', 'Mauritania', 'Mauritius',  'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', 'Sao Tome and Principe', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa', 'South Sudan', 'Sudan', 'Tanzania', 'Togo',  'Uganda', 'Zambia', 'Zimbabwe', 'Brazil', 'Haiti', 'Jamaica', 'Trinidad and Tobago','Dominican Republic', 'Bahamas', 'Barbados', 'Guyana', 'Saint Lucia', 'Grenada', 'Belize', 'Saint Kitts and Nevis', 'Antigua and Barbuda', 'Saint Vincent and the Grenadines', 'Suriname', 'Cuba', 'Puerto Rico', 'Panama', 'Colombia',
  ];
  String ugTrial = "20k";
  String intTrial = "5.99";
  String customerCareNumber = "+256700457826";
  String userName = "";
  bool showPaymentNotification = false;
  List <Offering> subscriptionProducts = [];








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
  String challengeRecipeList = '';
  String tagline = 'Its time to start achieving your Goals';
  bool subscriptionButton = true;
  int activeChallengeIndex = 0;
  Map<String, dynamic> challengeDays = {};
  List <Step> challengeSteps = [Step(title: Text("TEST"), content: Text('Infor'))];
  List adminsOnDuty = [];
  List nutriTips = [
    "Ask Nutri for personalized meal plans tailored to your health goals!",
    "Capture photos of your breakfast, lunch, and dinner to track your daily food intake with Nutri.",
    "Snap a pic of your post-workout snack to get insights into its nutritional value.",
    "Ask Nutri for healthy recipe ideas based on the ingredients you have in your fridge!",
    "Take photos of your snacks to see how they fit into your goal.",
    "Capture your pre- and post-workout meals to optimize your fitness routine.",
    "Get tips from Nutri on how to build healthy eating habits that last.",
    "Ask Nutri for advice on portions to eat",
    "Snap a pic of your favorite restaurant meal to see how it fits into your nutrition plan.",
    "Capture your daily water intake to stay hydrated and track your progress.",
    "Ask Nutri for suggestions on how to manage food allergies or intolerances.",
    "Take photos of your home-cooked meals to monitor your nutrient intake.",
    "Get insights from Nutri on how to optimize your protein, carb, and fat intake.",
    "Ask for a local dish to have today",
  ];
  bool tipStatus = false;
  List challengeDayData = [];
  List messageContext = [];
  int progressPoints = 0;
  DateTime subscriptionDate = DateTime.now();
  String subscriptionType = "Trial";



 // setChangeLottieImage(int index, IconData image){
 //   dayIcons[index] = image;
 //   notifyListeners();
 // }

  setSubscriptionProducts(value) {
    subscriptionProducts = value;
    notifyListeners();
  }
  setUseName(name){
    userName = name;

    notifyListeners();
  }
  setChallengePosition (){
    challengePosition += 1;
    activeChallengeIndex = 0;
    // lottieImages[challengePosition + 1] = 'images/letsgo.json';
    // for (var i = 0; i < challengePosition; i++) {
    //   lottieImages[i] = 'images/cloud.json';
    // }
    notifyListeners();
  }

  setTipStatus(){
    tipStatus = !tipStatus;
    notifyListeners();

  }

  setShowPaymentDialogue(value) {
    showPaymentNotification = value;

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

  setChallengeParameters (id, name, description, welcomeMessage, rules, schedule, position, days, daysValues, shopping, activePosition, challengeDaysIndex, recipeIndex){
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
    challengeRecipeList = recipeIndex;
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

    notifyListeners();
  }

  void setCommonVariables (points, date, subscription ){
    subscriptionDate = date;
    progressPoints = points;
    subscriptionType = subscription;

  }
  void setSubscriptionVariables(ugMonth, ugYear, intMonth, intYear, ugTrialAmount, intTrialAmount, customerCare, tipsList, notify, welcomeTagline, subscription, time, ios, blackCountries){
    ugMonthly = ugMonth.toString();
    ugYearly = ugYear.toString();
    intMonthly = intMonth.toString();
    intYearly = intYear.toString();
    ugTrial = ugTrial;
    intTrial = intTrialAmount;
    customerCareNumber = customerCare;
    nutriTips = tipsList;
    adminsOnDuty = notify;
    tagline = welcomeTagline;
    subscriptionButton = subscription;
    trialTime = time;
    iosUpload = ios;
    countries = blackCountries;

    notifyListeners();
  }
}