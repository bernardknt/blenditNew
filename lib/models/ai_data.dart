

import 'package:blendit_2022/models/service_providers_model.dart';
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
  String userId = '';
  List<Color> preferencesColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor];
  //List<Color> gymItemSelectedColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor];
  List<Color> gymItemSelectedColorOfBoxes = [kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,];
  List<Color> boxElevationSelectedColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor, ];
  DateTime onlineAppointmentTime = DateTime.now();
  List<DateTime> onlineAppointmentTimeArray = [];
  List preferencesSelected = [];
  List boxElevation = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,];
  List <ServiceProviderItem> gymItemSelected = [];
  double gymItemPrices = 0.0;
  List <String>preferencesIdSelected = [];
  DateTime userBirthday = DateTime.now();
  DateTime appointmentDate = DateTime.now();
  DateTime appointmentTime = DateTime.now();
  Color preferencesContinueColor = kCustomColor;
  Color targetsContinueColor = kFontGreyColor;
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
  int trialTime = 7;
  bool iosUpload = false;
  List countries = [ 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi',
    'Cape Verde', 'Cameroon', 'Central African Republic', 'Chad', 'Comoros', 'Democratic Republic of the Congo', 'Republic of the Congo', 'Djibouti', 'Equatorial Guinea', 'Eritrea', 'Eswatini', 'Ethiopia', 'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Ivory Coast', 'Kenya', 'Lesotho', 'Liberia', 'Madagascar', 'Malawi', 'Mali', 'Mauritania', 'Mauritius',  'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', 'Sao Tome and Principe', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa', 'South Sudan', 'Sudan', 'Tanzania', 'Togo',  'Uganda', 'Zambia', 'Zimbabwe', 'Brazil', 'Haiti', 'Jamaica', 'Trinidad and Tobago','Dominican Republic', 'Bahamas', 'Barbados', 'Guyana', 'Saint Lucia', 'Grenada', 'Belize', 'Saint Kitts and Nevis', 'Antigua and Barbuda', 'Saint Vincent and the Grenadines', 'Suriname', 'Cuba', 'Puerto Rico', 'Panama', 'Colombia',
  ];
  Map prompt = {};
  String ugTrial = "20k";
  String qualityControl = "";
  String favouriteCountry = "Uganda";
  Map youtubeVideos = {};
  String intTrial = "5.99";
  String annualGoal = "";
  String coach = "Philip";
  String customerCareNumber = "+256700457826";
  String userName = "";
  bool showPaymentNotification = false;
  List <Offering> subscriptionProducts = [];
  List powerPoints = [];
  String revCustomerId = "";
  String revProductStoreId = "";
  String revPrice = '';
  String revTitle = '';
  String revDuration = '';
  String revTransId = '';

  List dailyTarget = [];


// Appointments Made
  DateTime appointmentMadeDate = DateTime.now();
  DateTime appointmentMadeTime = DateTime.now();
  String appointmentMadeBeautician = "";
  String appointmentMadeAppointmentId = "";
  String appointmentMadeBeauticianId = "";
  String appointmentMadeLocation = "";
  String appointmentMadeBeauticianPhoneNumber = "";
  double appointmentMadeBeauticianLatitude = 0;
  double appointmentMadeBeauticianLongitude = 0;
  List appointmentMadeBeauticianItems = [];
  double appointmentMadeTotalFee = 0;
  bool appointmentComplete = false;
  List appointmentDaysArray = [];








  // Challenge Variables
  String goal = '';
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
  double dailyProgressPoint = 0;
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

// This adds power points to the Nutri chat when something good is done

  setGoalValue(goalValue){
    goal = goalValue;
    notifyListeners();
  }
  setRevenueCatValue( customerID,productStoreId, revenuecatPrice, title, duration, rcTransactionId){
    revCustomerId = customerID;
    revProductStoreId = productStoreId;
    revPrice = revenuecatPrice;
    revTitle = title;
    revDuration = duration;
    revTransId = rcTransactionId;

    notifyListeners();

  }

  addPowerPoints (token){
    powerPoints.add(token);
    notifyListeners();
  }
  void setUserId(id){
    userId= id;
    notifyListeners();
  }

  setDailyProgressPoints (amount){
    dailyProgressPoint += amount;
    notifyListeners();
  }

  setSubscriptionProducts(value) {
    subscriptionProducts = value;
    notifyListeners();
  }
  setUseName(name){
    userName = name;
    notifyListeners();
  }

  setDailyTargets(targets){
    dailyTarget = targets;
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

  void setPreferencesBoxColor(index, Color color, name, id){
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
      if(preferencesIdSelected.length == 2){
        targetsContinueColor = kGreenThemeColor;
      } else {
        targetsContinueColor = kFaintGrey;
      }

    }else{
      preferencesContinueColor = kCustomColor;

        targetsContinueColor = kFaintGrey;


    }

    notifyListeners();
  }

  void setSelectedTimeValues(index,double elevatedButton,DateTime time){
    if (elevatedButton== 0.0){
      onlineAppointmentTime = time;
      boxElevation[index] = 10.0;
      boxElevationSelectedColorOfBoxes[index] = kGreenThemeColor;
      onlineAppointmentTimeArray.add(time);
    }else {
      boxElevation[index] = 0.0;
      onlineAppointmentTime = DateTime.now();
      onlineAppointmentTimeArray.remove(time);
      boxElevationSelectedColorOfBoxes[index] = kButtonGreyColor;
    }
    notifyListeners();
  }
  void resetSelectedTimeValues(){
    boxElevation = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,];
    onlineAppointmentTimeArray.clear();
    boxElevationSelectedColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor, ];
    print("THIS CLEARING HAPPENED IN AI PROVIDER");
    notifyListeners();
  }

  void clearServiceProviderInfo(){
   // gymItemSelectedColorOfBoxes =  [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor];
  //  gymItemSelectedColorOfBoxes =  [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor];
    gymItemSelectedColorOfBoxes =  [kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,];
    gymItemSelected.clear();
    gymItemPrices = 0.0;
    notifyListeners();
  }

  void addTotalFeeForServiceProvider(ServiceProviderItem item){
    gymItemPrices += (item.amount * item.quantity);
    notifyListeners();
  }
  void subtractTotalFeeForServiceProvider(ServiceProviderItem item){
    gymItemPrices -= (item.amount * item.quantity);
    notifyListeners();
  }

  void setGymServiceBoxColor(index,Color color, ServiceProviderItem name){
    if (color!= kGreenThemeColor){
      gymItemSelected.add(name);
      gymItemSelectedColorOfBoxes[index] = kGreenThemeColor;
      addTotalFeeForServiceProvider(name);
    }else {
      //gymItemSelectedColorOfBoxes[index] =kButtonGreyColor;
      gymItemSelectedColorOfBoxes[index] =kCustomColor;
      gymItemSelected.removeWhere((item) => item.product == name.product);
      subtractTotalFeeForServiceProvider(name);
    }
    notifyListeners();
  }


  void resetQuestionButtonColors(){
    preferencesColorOfBoxes = [kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,kButtonGreyColor,];
    // preferencesColorOfBoxes = [kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,kCustomColor,];
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
  void setSubscriptionVariables(ugMonth, ugYear, intMonth, intYear, ugTrialAmount, intTrialAmount, customerCare, tipsList, notify, welcomeTagline, subscription, time, ios, blackCountries, countryPrompt, control, favCountry, videos, goal, onlineCoach){
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
    prompt = countryPrompt;
    qualityControl = control;
    favouriteCountry = favCountry;
    youtubeVideos = videos;
    annualGoal = goal;
    coach = onlineCoach;

    notifyListeners();
  }
  setCoach(name){
    coach = name;
    notifyListeners();
  }

  void setAppointmentMade(date, time, location, beautician, phone, latitude, longitude, items, id, beauticianId, amountTotal, complete, numberOfDays){
    appointmentMadeDate = date;
    appointmentMadeTime = time;
    appointmentMadeBeautician = beautician;
    appointmentMadeAppointmentId = id;
    appointmentMadeBeauticianId = beauticianId;
    appointmentMadeLocation = location;
    appointmentMadeBeauticianPhoneNumber = phone;
    appointmentMadeBeauticianLatitude = latitude;
    appointmentMadeBeauticianLongitude = longitude;
    appointmentMadeBeauticianItems = items;
    appointmentMadeTotalFee = amountTotal;
    appointmentComplete = complete;
    appointmentDaysArray = numberOfDays;


    notifyListeners();
  }
}

