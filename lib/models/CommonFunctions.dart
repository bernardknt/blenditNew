


import 'dart:async';
import 'dart:io';
import 'package:blendit_2022/screens/calendar_page.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../screens/success_challenge_done.dart';
import '../utilities/constants.dart';
import 'ai_data.dart';




class CommonFunctions {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  /// Initialize notification



  final auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var formatter = NumberFormat('#,###,000');
  CollectionReference challengeImage = FirebaseFirestore.instance.collection('challenges');
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
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = 'Africa/Kampala';
    //await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Scheduled Notification
  scheduledNotification({required String heading,required String body,required int year,required int month,required int day, required int hour, required int minutes, required int id}) async {

    initializeNotification();
    await
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      heading,
      body,
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
        iOS: IOSNotificationDetails(sound:'notification.mp3'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      // payload: 'It could be anything you pass',
    );
    print("Scheduled message $heading for $year-$month-$day $hour:$minutes with id: $id");
  }

  // This function is for cancelling the notification

  cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
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

    return challengeImage.doc(challengeId)
        .update({
      'personalImages': FieldValue.arrayUnion([image]),
    })
        .then((value) => print("Image Added"))
        .catchError((error) => print("Failed to send Communication: $error"));
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

      }
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(context, ChallengePage.id);
      Navigator.pushNamed(context, SuccessPageChallenge.id);
      uploadImageToServer(challengeId, urlDownloaded);
    }
    // setState(() {
    //
    // });


    // Navigator.pop(context);
    // Navigator.pushNamed(context, ChallengePage.id);
    // Navigator.pushNamed(context, SuccessPageChallenge.id);
   //  uploadImageToServer(challengeId, urlDownloaded);
  }


  // Launch Google Maps to webview
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    launchUrl(Uri.parse(googleUrl));
  }

  void callPhoneNumber (String phoneNumber){
    launchUrl(Uri.parse('tel://$phoneNumber'));
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
          'position' : position

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
    print("THIS RUN AND TRIGGERED auth id: ${auth.currentUser!.uid} plus: $preferenceId");


    for(var i = 0; i < preferenceId.length; i++){
      subscribeToTopic(preferences[i]);
    }

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'preferences': preferences,
          'preferencesId': preferenceId,
          'sex': sex,
          'dateOfBirth': dateOfBirth,
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

}