


import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:blendit_2022/models/service_providers_model.dart';
import 'package:blendit_2022/screens/calendar_page.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
import 'package:blendit_2022/screens/photo_onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../screens/ios_onboarding.dart';
import '../screens/make_payment_page.dart';
import '../screens/success_appointment_create.dart';
import '../screens/success_challenge_done.dart';
import '../utilities/constants.dart';
import '../utilities/font_constants.dart';
import '../widgets/InputFieldWidget.dart';
import 'ai_data.dart';
import 'blendit_data.dart';
import 'firebase_functions.dart';




class CommonFunctions {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  /// Initialize notification



  final auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var formatter = NumberFormat('#,###,000');
  var description = "";
  CollectionReference challengeCollection = FirebaseFirestore.instance.collection('challenges');
  CollectionReference trends = FirebaseFirestore.instance.collection('photoUpLoads');
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  CollectionReference quality = FirebaseFirestore.instance.collection('qualityControl');
  CollectionReference users = FirebaseFirestore.instance.collection('users');



  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  File? image;
  UploadTask? uploadTask;
  final storage = FirebaseStorage.instance;
  // Initialize the timezone package

  initializeNotification() async {
    _configureLocalTimeZone();
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  // This should get the paywall values from Revenuecat

  Future <List<Offering>> fetchOffers() async{
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;


      return current == null ? [] : [current];
    } on PlatformException catch (e){
      print(e);
      return [];

    }
  }
  // This function extracts the $ sign or strings like KES from an amount and outputs the double value

  double extractNumberFromString(String input) {
    String numberString = '';

    // Remove all non-digit and non-decimal characters from the input
    String cleanedInput = input.replaceAll(RegExp(r'[^0-9\.]'), '');

    // Check if the cleaned input is empty
    if (cleanedInput.isEmpty) {
      return 0.0; // Return 0 if there are no valid digits in the input
    }

    // Split the cleaned input into two parts: the whole number and the decimal part
    List<String> parts = cleanedInput.split('.');

    // Add the whole number part
    numberString += parts[0];

    // Add the decimal part if it exists
    if (parts.length > 1) {
      numberString += '.' + parts[1];
    }

    // Parse the number string and return the result
    return double.parse(numberString);
  }

  // This function extracts the Currency string from the amount String

  String extractCurrencyFromString(String input) {
    String currencyString = '';

    // Remove all digit and decimal characters from the input
    String cleanedInput = input.replaceAll(RegExp(r'[0-9\.]'), '');

    // Remove any leading or trailing whitespace
    cleanedInput = cleanedInput.trim();

    // Return the cleaned string
    return cleanedInput;
  }

  // This function signs out the User

  void subscribeToTopic( topic)async{
    await FirebaseMessaging.instance.subscribeToTopic(topic).then((value) =>
        print('Succefully Subscribed')
    );
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      // 'This channel is used for important Notifications',
      importance: Importance.high,
      playSound: true
  );

  // This is the function for scheduling time

  tz.TZDateTime _convertTime(int year, int month, int day, int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      hour,
      minutes,
    );
    // if (scheduleDate.isBefore(now)) {
    //   scheduleDate = scheduleDate.add(const Duration(days: 1));
    // }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = 'Africa/Kampala';
    //await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  String changeTheDate (date){
    return DateFormat('EE dd MMMM yyyy - HH:mm').format(date);
  }

  /// Scheduled Notification
  scheduledNotification({required String heading,required String body,required int year,required int month,required int day, required int hour, required int minutes, required int id})
  async {

    initializeNotification();
    await flutterLocalNotificationsPlugin.zonedSchedule(id, heading, body,
      _convertTime(year, month, day, hour, minutes),
       NotificationDetails(
        android: AndroidNotificationDetails(
          "$id",
          '$heading',
          sound: RawResourceAndroidNotificationSound('tiktok'),
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
         //  sound: RawResourceAndroidNotificationSound(sound),
        ),
        iOS: IOSNotificationDetails(sound:'tiktok.mp3'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      // payload: 'It could be anything you pass',
    );
    print("Scheduled message $heading for $year-$month-$day $hour:$minutes with id: $id");
  }

  // This function is for cancelling the notification
  cancelLocalNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  cancelNotification(uid) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    try {
      // Get a reference to the user's document in the 'users' collection
      var userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Update the 'token' field to an empty string
      await userRef.update({'token': ''});

      print('User token updated successfully');
    } catch (e) {
      print('Error updating user token: $e');
    }

  }

  void showNotification(String notificationTitle, String notificationBody){
    flutterLocalNotificationsPlugin.show(0, notificationTitle, notificationBody,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // channel.description,
              importance: Importance.high,
              // sound: RawResourceAndroidNotificationSound('notification'),
              color: Colors.green,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                subtitle: channel.description

            )
        ));

  }

  Future<void> signOut() async {
    await auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kIsLoggedInConstant, false);
    prefs.setBool(kIsFirstTimeUser, true);


  }

  //This gets the phone User  token of the user
  String getUserTokenOfPhone (){
    var token = '';
    _firebaseMessaging.getToken().then((value) => token = value!);
    return token;
  }

  // This function uploads the users photo to the database

  Future<void> uploadImageToServer(challengeId, image) {

    return challengeCollection.doc(challengeId)
        .update({
      'personalImages': FieldValue.arrayUnion([image]),
    })
        .then((value) => print("Image Added"))
        .catchError((error) => print("Failed to send Communication: $error"));
  }

  Future<void> uploadActiveChallengePosition(challengeId, position){
    return challengeCollection.doc(challengeId).update({
      'activePosition': position
    });
  }

  Future<void> uploadPhoto(String filePath, String fileName , String challengeId, int activeChallengeIndex,  int listOfKeysLength, int challengePosition,int challengeDayKeysLength, String challengeName, String customerName, int currentStep, String planDay, context)
  async {
    File file = File(filePath);
    try {
      uploadTask  = storage.ref('challenges/$fileName').putFile(file);
      final snapshot = await uploadTask!.whenComplete((){

        Get.snackbar('NICE WORK!', 'On we go💪',
            snackPosition: SnackPosition.TOP,
            backgroundColor: kCustomColor,
            colorText: kBlack,
            icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
        uploadActiveChallengePosition(challengeId, activeChallengeIndex + 1);

      });

      final urlDownload = await snapshot.ref.getDownloadURL();
      print("POPOPOPOPOPOPOP $urlDownload");
     onStepContinue(activeChallengeIndex, listOfKeysLength, challengePosition, challengeDayKeysLength, customerName, challengeName, challengeId, planDay, urlDownload, currentStep, context);
    }  catch(e){
      print(e);
      Get.snackbar('Error uploading Image', " $e");
    }
  }

  void onStepContinue(activeChallengeIndex, listOfKeysLength, challengePosition, challengeDayKeysLength, customerName, challengeName, challengeId, planDay, urlDownloaded, int currentStep, context) {
    Provider.of<AiProvider>(context, listen: false).setActiveChallengeIndex(activeChallengeIndex);


    // This is done to take the user from one day to the other
    print('ActiveChallengeIndex $activeChallengeIndex: | listOfKeysLength: $listOfKeysLength');
    if ( activeChallengeIndex + 1 == listOfKeysLength)
    {
      // IF THE CHALLENGE IS DONE
      print("challengePosition: $challengePosition| challengeDayKeysLength: $challengeDayKeysLength");
      if ( challengePosition == challengeDayKeysLength){
        // Navigator.pushNamed(context, CalendarPage.id);
        showNotification("CHALLENGE COMPLETE $customerName", "You Just completed the ${challengeName} challenge");
        uploadCompleteChallenge(challengeId, context);


      }
      else{
        Provider.of<AiProvider>(context, listen: false).setChallengePosition();
        uploadStageChanges(challengeId, DateTime.now(), currentStep + 1);
       showNotification("Congratulations $customerName", "You Just completed $planDay of $challengeName");
        Navigator.pop(context);
        Navigator.pushNamed(context, ChallengePage.id);
        Navigator.pushNamed(context, SuccessPageChallenge.id);
         uploadImageToServer(challengeId, urlDownloaded);
         uploadActiveChallengePosition(challengeId, 0);


      }
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(context, ChallengePage.id);
      Navigator.pushNamed(context, SuccessPageChallenge.id);
      uploadImageToServer(challengeId, urlDownloaded);
    }

  }


  // Launch Google Maps to webview
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    launchUrl(Uri.parse(googleUrl));
  }

  // Get distance between two points on the earth

  double calculateDistanceBetweenTwoPlacesOnEarth(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000; // Earth's radius in meters

    // Convert latitude and longitude from degrees to radians
    final double lat1Rad = degreesToRadians(lat1);
    final double lng1Rad = degreesToRadians(lng1);
    final double lat2Rad = degreesToRadians(lat2);
    final double lng2Rad = degreesToRadians(lng2);

    // Calculate the differences between the coordinates
    final double dLat = lat2Rad - lat1Rad;
    final double dLng = lng2Rad - lng1Rad;

    // Calculate the Haversine distance
    final double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance; // Distance in meters
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }


// call number
  void callPhoneNumber (String phoneNumber){
    launchUrl(Uri.parse('tel://$phoneNumber'));
  }


  // Visit Link
  void goToLink (String link){
    launchUrl(Uri.parse(link));
  }

  Future<void> uploadUserToken(token) async {
    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'token': token
        }).then((value) => print("Its finished",
    ));
  }

  Future<void> uploadUserTokenWithName(token, firstName, fullNames) async {
    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'token': token,
          'firstName': firstName,
          'lastName': fullNames
        }).then((value) => print("Its finished",
    ));
  }
  Future<void> uploadCompleteChallenge(id, context) async {
    await FirebaseFirestore.instance
        .collection('challenges').doc(id)
        .update(
        {

          'completed': true,
          'challengeStatus': false,
          'challengeEndTime': DateTime.now(),


        }).then((value) {
      Navigator.pop(context);
      Navigator.pushNamed(context, SuccessPageChallenge.id);
      Get.snackbar('Congratulations', 'You just completed the challenge',
          snackPosition: SnackPosition.TOP,
          backgroundColor: kCustomColor,
          colorText: kBlack,
          icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
    } ).catchError((error) {

    Get.snackbar('Error', 'Something went wrong : $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kAppPinkColor,
        colorText: kBlack,
        icon: Icon(Icons.error_outline, color: kBlack,));
    print("YUUUUUUYUUUUU: $error");

    });
    //     Get.snackbar('Success', 'Welcome to Nutri',
    // ));
  }


  Future<void> uploadStageChanges(id, date, position ) async {
    await FirebaseFirestore.instance
        .collection('challenges').doc(id)
        .update(
        {

          'challengeStatus': true,
          'dateSet' : true,
          'rulesRead' : true,
          'scheduleRead' : true,
          'challengeStartTime' : date,
          'position' : position,
          'activePosition': 0

        }).then((value) => print('UPLOADED') );
    //     Get.snackbar('Success', 'Welcome to Nutri',
    // ));
  }

  Future<dynamic> AlertPopUpDialogueMain(BuildContext context,
      {required String imagePath, required String text, required String title,

      }) {
    return CoolAlert.show(
        lottieAsset: imagePath,
        context: context,
        type: CoolAlertType.success,
        text: text,
        title: title,
        confirmBtnText: 'Add',
        cancelBtnText: 'Cancel',
        showCancelBtn: true,
        confirmBtnColor: Colors.green,
        backgroundColor: kBlueDarkColor,
        onConfirmBtnTap: (){
          Navigator.pop(context);
          // bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
        }
    );
  }



  // Check for internet connectivity
  Future<void> execute(InternetConnectionChecker internetConnectionChecker,
      ) async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
          //   Get.snackbar('Internet Restored', 'You are back online');
          //   print('PARARARARA we are back on.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            Get.snackbar('No Internet', 'Please check your internet connection');

            print('OH NOOOOOOO GAGENZE');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }

  // This function Updates the users personal preferences to the servers

  Future<void> uploadUserPreferences(preferences, sex, dateOfBirth, List preferenceId) async {
    final prefs = await SharedPreferences.getInstance();
    print("THIS RUN AND TRIGGERED auth id: ${auth.currentUser!.uid} plus: $preferenceId");


    for(var i = 0; i < preferenceId.length; i++){
     // subscribeToTopic(preferences[i]);
    }

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'email': prefs.getString(kEmailConstant) ?? "",
          'preferences': preferences,
          'preferencesId': preferenceId,
          // 'sex': sex,
          // 'dateOfBirth': dateOfBirth,
          // 'level': "Beginner"
        }).then((value) =>
       print("KOKOKOKOKOKOKOKOKOKO preferences: $preferences , sex: $sex , date of Birth: $dateOfBirth uploaded"
    )
    );
  }

  Future<void> uploadUserLocation(latitude, longitude, location) async {

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'cord':  GeoPoint(latitude, longitude),
          'currentLocation': location,

        }).then((value) => print("Location Updated"));
  }

  // HERE ARE FUNCTIONS FOR PHOTO UPLOAD
  Future<void> uploadFile(String filePath, String fileName, String description, context, bool goalBool, String goalText, List goalArray )async {
    File file = File(filePath);
    try {
      uploadTask  = storage.ref('chatImages/$fileName').putFile(file);
      final snapshot = await uploadTask!.whenComplete((){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image Uploaded')));

      });
      final urlDownload = await snapshot.ref.getDownloadURL();
      final imageName = await snapshot.ref.name;
      print("KIWEEEEEEDDDEEEEEEEEEEEEEE: $urlDownload");
      addPhotoToDB(fileName, urlDownload, imageName, description, context, goalBool, goalText, goalArray);

      // Navigator.pushNamed(context, ControlPage.id);
    }  catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Uploading: $e')));
    }
  }


  // THIS FUNCTION CHANGES THE VALUE OF THE FALSE IN THE DAILY TASKS TO A TRUE VALUE
  String transformString(String inputString) {
    // Check if the inputString starts with "false?"
    if (inputString.startsWith('false?')) {
      // Extract the value after "false?"
      final value = inputString.substring(6);
      return 'true?$value';
    }
    // Return the original string if it doesn't match the expected format
    return inputString;
  }


  // THIS FUNCTION UPDATES THE DAILY TASKS VALUES AND GIVES THE USER NEW POINTS IN THE DB
  Future<void> updateDailyTargetValues(List rawTargetArray, String wordToReplace, chatId, context) async {
    final prefs = await SharedPreferences.getInstance();
    // This should be a transformation of the string to a true value
    final String replacementWord = transformString(wordToReplace);

    final List<String> updatedArray = List<String>.from(rawTargetArray);
    final int index = updatedArray.indexOf(wordToReplace);

    if (index != -1) {
      updatedArray[index] = replacementWord;

      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(prefs.getString(kUniqueIdentifier))
            .update({'dailyTasks': updatedArray});
        FirebaseServerFunctions().increasePointsCount(prefs.getString(kUniqueIdentifier)!, context, chatId);

      } catch (error) {
        print('Error updating array field: $error');
      }
    } else {

    }
  }


  Future<void> addPhotoToDB(trendsId, image, name, description, context, goalBool, goalText, goalArray) async {
    // Call the user's CollectionReference to add a new user
    bool winning = false;
    if (goalBool == true){
      winning = true;
      updateDailyTargetValues(goalArray, goalText, trendsId, context);
    }
    final prefs = await SharedPreferences.getInstance();
    // quality.doc(trendsId)
    //     .set({
    //   'replied': false,
    //   'status' : true,
    //   'time':  DateTime.now(),
    //   'message': "📸 $description",
    //   'response': '',
    //   'userId': prefs.getString(kUniqueIdentifier),
    //   'weight': prefs.getDouble(kUserWeight),
    //   'height': prefs.getInt(kUserHeight),
    //   'name': prefs.getString(kFullNameConstant),
    //   'token': prefs.getString(kToken),
    //   'id':trendsId,
    //   'history': [],
    //   'length': 200,
    //   'lastQuestion': "None",
    //   'manual': false,
    //   'photo': true,
    //   'country': prefs.getString(kUserCountryName),
    //   'birthday': prefs.getString(kUserBirthday),
    //   'preferences': prefs.getString(kUserPersonalPreferences),
    //   'image': image,
    //   'agent': false,
    //   'visible': true,
    //   'replyTime': DateTime.now(),
    //   "agentName": "",
    //   "admins":  Provider.of<AiProvider>(context, listen: false).adminsOnDuty,
    //   "tag": trendsId,
    //   "winning":false,
    //   "pointApplication": true
    // });

    return chat.doc(trendsId)
        .set({
      'replied': false,
      'status' : true,
      'time':  DateTime.now(),
      'message': "📸 $description",
      'response': '',
      'userId': prefs.getString(kUniqueIdentifier),
      'weight': prefs.getDouble(kUserWeight),
      'height': prefs.getInt(kUserHeight),
      'name': prefs.getString(kFullNameConstant),
      'token': prefs.getString(kToken),
      'id':trendsId,
      'history': [],
      'length': 200,
      'lastQuestion': "None",
      'manual': false,
      'photo': true,
      'country': prefs.getString(kUserCountryName),
      'birthday': prefs.getString(kUserBirthday),
      'preferences': prefs.getString(kUserPersonalPreferences),
      'image': image,
      'agent': false,
      'visible': true,
      'replyTime': DateTime.now(),
      "agentName": "",
      "admins":  Provider.of<AiProvider>(context, listen: false).adminsOnDuty,
      "tag": trendsId,
      "goalBool": goalBool,
      "goalText": goalText,
      "winning": winning,

    })

        .then((value) {
      Navigator.pop(context); getImageUrl(name);

    })

        .catchError((error) => print("Failed to send Communication: $error"));
  }
  Future<String> getImageUrl(String imageName) async {
    try {
      // Get a reference to the Firebase Storage instance
      final storageRef =   storage.refFromURL("gs://blend-it-8a622.appspot.com/chatImages/challenges/$imageName");
      // FirebaseStorage.instance.ref();

      // Get a reference to the image file
      // final imageRef = storageRef.child(imageName);

      // Get the download URL for the image
      //final imageUrl = await imageRef.getDownloadURL();
      final imageUrl = await storageRef.getDownloadURL();

      print("WOLOLOLOLOLOLOL $imageUrl");

      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return "";
    }
  }

  Future<File?> compressImage(File file)async {
    File? compressedImage;

    // Wrap the async operation in a try-catch block to handle exceptions
    try {
      final compressedImageFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        "${file.path}_compressed.jpg",
        quality: 50,
      );
      compressedImage = compressedImageFile;
    } catch (e) {
      // Handle exceptions if any
      print('Failed to compress image: $e');
    }


    return compressedImage;
  }

  void showBottomSheet(BuildContext context, String serviceId, File? imageReceived, goalBool, goalText, goalArray) {
    showModalBottomSheet(

      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: kRoundedContainerColor,
            child: Scaffold(
              backgroundColor: kBackgroundGreyColor,
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(

                child: Container(

                  // height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child:

                    Column(
                      children: [
                        kLargeHeightSpacing,
                        Text("Photo to Upload", style: kNormalTextStyle.copyWith(fontSize: 18, color: kBlack),),

                        Padding(
                          padding: const EdgeInsets.all(8.0),

                          child:

                          imageReceived != null ?
                          Image.file(imageReceived!, height: 200,) :

                          Container(
                            width: double.infinity,
                            height: 250,

                            child: Text("data"),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: kPureWhiteColor),

                          ),
                        ),
                        kLargeHeightSpacing,



                        Container(
                          height: 80,
                          child:
                          // InputFieldWidget(hintText: "Is this good for me?", onTypingFunction: (value){description = value;}, keyboardType: TextInputType.text, labelText: " What's your Question", inputTextColor: kPureWhiteColor,),
                          //
                          TextField(
                            // obscureText: passwordType,
                            // keyboardType: keyboardType,
                            onChanged: (value){description = value;},
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            style: kNormalTextStyle.copyWith(color: kBlack),
                            //keyboardType: TextInputType.number,

                            decoration: InputDecoration(

                              hintText: "Is this good for me?",
                              fillColor: kPureWhiteColor,
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                              labelText: " Add Question / Note ",

                              labelStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kBlueDarkColor, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kBlueDarkColor, width: 0),
                                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
                          ),
                        ),
                        RoundedLoadingButton(
                          width: double.maxFinite,
                          color: kGreenThemeColor,
                          child: Text('Send to Nutri', style: TextStyle(color: kPureWhiteColor)),
                          controller: _btnController,
                          onPressed: () async {
                            image = imageReceived;
                            if ( description == ''){
                              _btnController.error();
                              showDialog(context: context, builder: (BuildContext context){
                                return
                                  CupertinoAlertDialog(
                                    title: Text("Oops you haven't added asked your Question"),
                                    content: Text('Make sure you have filled in this field'),
                                    actions: [CupertinoDialogAction(isDestructiveAction: true,
                                        onPressed: (){
                                          _btnController.reset();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'))],
                                  );
                              });
                            }else {
                              // compressImage(image!, serviceId, description, context);


                              uploadFile(image!.path, serviceId, description, context, goalBool, goalText, goalArray );


                              //Implement registration functionality.
                            }
                          },
                        ),
                        TextButton(onPressed: (){
                          
                          Navigator.pop(context);
                        }, child: Text('Cancel', style: kNormalTextStyle.copyWith(color: Colors.red), )
                        
                        ), 
                        const Opacity(
                            opacity: 0,
                            child: Text("There was an error", style: TextStyle(color: Colors.red),)),
                      ],
                    )),
                  ),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: kBackgroundGreyColor ,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25), topLeft: Radius.circular(25))),

                ),
              ),
            ),
          ),
        );
      },
    );
  }
  // STARTING SUBSCRIPTION FOR NUTRI
  void startTrialSubscription(context, int time) {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: time));
    final formattedDate = Timestamp.fromDate(futureDate);

    Provider.of<AiProvider>(context, listen: false).setCommonVariables(1500, DateTime.now().add(Duration(days: 3)),"Trial", true);

    users.doc(auth.currentUser!.uid).update({
      // "aiActive": false,
      "subscriptionEndDate": futureDate,
      "subscriptionStartDate": now,
      "subscribed": false,
      "trial": "Premium",

    });

  }

  Future pickImage(ImageSource source, serviceId, context, goal, goalText, goalArray) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(kFirstTimePhoto)== false){
      try {
        final image = await ImagePicker().pickImage(source: source);
        // await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image == null){
          return ;
        }else {
          final compressedImage = await compressImage(File(image.path));

          var file = File(image.path);
          showBottomSheet(context, serviceId, compressedImage, goal, goalText, goalArray);
        }
      } on PlatformException catch (e) {
        print('Failed to pick image $e');

      }

    }
    else{
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=> PhotoOnboarding())
      );


    }
  }
  // STREAMING DATA FROM THE USERS PROFILE
  Future userSubscription(context) async {
    var userData = await users.doc(auth.currentUser!.uid).get();
    Provider.of<AiProvider>(context,listen: false).setCommonVariables(
      userData['loyalty'],
      userData['subscriptionEndDate'].toDate(),
      userData['trial'],
      userData['freeSession'],
    );
    print("Subscription Status is at: ${userData['freeSession']}");

  }

  Future<void> cancelOrderStatus(String documentId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the specific document in the 'orders' collection
      DocumentReference orderRef = firestore.collection('orders').doc(documentId);

      // Update the 'paymentStatus' field to 'Cancelled'
      await orderRef.update({
        // 'paymentStatus': 'Cancelled',
        'status':"CANCELLED",
        'cancelled': true,

      });


      print('Payment status updated to Cancelled for document ID: $documentId');
    } catch (e) {
      print('Error updating payment status: $e');
    }
  }


  Future<void> updateFreeSession() async {
    try {
      // Get the current user's UID
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString(kUniqueIdentifier);
          // FirebaseAuth.instance.currentUser?.uid;


      // Reference to the users collection and document
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentReference userDocument = users.doc(uid);

      // Update the freeSession field
      await userDocument.update({
        'freeSession': false,
      });

      print('Free session updated successfully.');
    } catch (e) {
      print('Error updating free session: $e');
    }
  }

  CollectionReference userOrder = FirebaseFirestore.instance.collection('orders');
  Future<void> uploadAppointment (context,DateTime deliverTime,String chef_note, String deliverInstructions, String newLocation, String phoneNumber, bool loyaltyApplied, double totalPrice, String type, String customerName, String orderId,List<ServiceProviderItem> products, String providerId, String providerNumber, GeoPoint providerCoordinates, String providerImage, String providerName, List duration  )
  async {

    final prefs =  await SharedPreferences.getInstance();
    // var products = Provider.of<BlenditData>(context, listen: false).basketItems;
    var dateNow = DateTime.now();
    String paymentStatus = 'pending';
    if (int.parse(prefs.getString(kBillValue)!) == 0) {
      paymentStatus = 'paid';
      updateFreeSession();
    }


    return userOrder.doc(orderId)
        .set({
      'client': customerName,
      //prefs.getString(kFullNameConstant),
      'client_phoneNumber': phoneNumber, // John Doe
      'chef_note': chef_note, // Stokes and Sons
      'instructions': deliverInstructions,
      'sender_id': prefs.getString(kEmailConstant),
      'location': newLocation,
      'deliveryTime': deliverTime,
      'orderNumber': orderId,
      'paymentMethod': 'cash',
      'paymentStatus': paymentStatus,
      'rating':0,
      'rating_comment': '',
      'hasRated': false,
      'distance': 0,
      'providerName':providerName,
      'status': 'submitted',
      'total_price': totalPrice,
      'image': providerImage,
      'duration':duration,
      //Provider.of<BlenditData>(context, listen: false).totalPrice + Provider.of<BlenditData>(context, listen: false).deliveryFee,
      'order_time': dateNow,
      'prepareStartTime':dateNow,
      'prepareEndTime':dateNow,
      'chef': 'none',
      'loyaltyApplied': loyaltyApplied,
      'serviceProvider': providerId,
      'serviceNumber': providerNumber,
      'cord': providerCoordinates,
      'cancelled': false,
      'token': prefs.getString(kToken),
      'type': "Appointment",
      'complete': false,
      'phoneNumber': prefs.getString(kPhoneNumberConstant),
      'items': [for(var i = 0; i < products.length; i ++){
        'product': products[i].product,
        'quantity': products[i].quantity,
        'totalPrice': products[i].amount,
        'days': products[i].days
      }
      ]
    }).whenComplete(() => Navigator.pushNamed(context, SuccessPageNew.id))




        .catchError((error) {
      Get.snackbar("Error Placing Order", "Ooops something seems to have gone wrong. Check your internet");
      print(error);
    } );
  }


  makeRevenueCatPayment(context, customerID,productStoreId, price, title, duration, transactionId) async{

    final prefs = await SharedPreferences.getInstance();
    try{


      showDialog(context: context, builder:
          ( context) {
        return const Center(child: CircularProgressIndicator());
      });
      await Purchases.purchaseProduct(productStoreId);

      Provider.of<AiProvider>(context, listen: false).setShowPaymentDialogue(true);
      Navigator.pushNamed(context, MakePaymentPage.id);
      // transactionStream();
      await FirebaseServerFunctions().callableRevenueCatPayment.call(<String, dynamic>{
        'id': productStoreId,
        'amount': CommonFunctions().extractNumberFromString(price),
        'product': title,
        'transId': transactionId,
        'duration': productStoreId == "nutri_69.99_annual_subscription" ? 365: 31,
        'token': prefs.getString(kToken),
        'uid' : prefs.getString(kUniqueIdentifier),
        'name': prefs.getString(kFullNameConstant),
        'currency': CommonFunctions().extractCurrencyFromString(price),
        'revenueCatId': customerID,
        // orderId
      }).then((value) => null);

    } catch(e){
      debugPrint("Failed to Purchase product $title, error: $e");
    }

  }






}