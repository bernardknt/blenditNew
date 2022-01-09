
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/ingredientsList.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/screens/settings_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';
import 'package:blendit_2022/widgets/SelectedIngredientsListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'loyalty_page.dart';
import 'onboarding_page.dart';

class NewBlenderPage extends StatefulWidget {
  static String id  = 'newblender';

  @override
  _NewBlenderPageState createState() => _NewBlenderPageState();
}
class _NewBlenderPageState extends State<NewBlenderPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    // _firebaseMessaging.getToken().then((value) => prefs.setString(kToken, value!));
    String newName = prefs.getString(kFirstNameConstant) ?? 'Hi';
    String newFullName = prefs.getString(kFullNameConstant) ?? 'Hi';
    bool isFirstTime = prefs.getBool(kIsFirstTimeUser) ?? false;
    bool isFirstTimeBlending = prefs.getBool(kIsFirstBlending)?? true;
    setState(() {
      firstName = newName;
      Provider.of<BlenditData>(context, listen: false).setCustomerName(newFullName);
      firstBlend = isFirstTimeBlending;
      print('WALALALALALLALA ${prefs.get(kToken)}');
    });
    print('PPOPOPOPOPOPOPOPOP $isFirstTime');
    if (isFirstTime == true){
      Navigator.pushNamed(context, BlenderOnboardingPage.id);
    }
  }

  void firstBlendDone()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kIsFirstBlending, false);
    firstBlend = false;
  }

  final prefs =  SharedPreferences.getInstance();
  bool firstBlend = true;
  String firstName = 'Blender';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryStream();
    defaultsInitiation();
    getIngredients();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode, notification.title, notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                color:Colors.purple
                ,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            )
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new OnMessage event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification!= null && android != null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(notification.title!),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text(notification.body!)
                ],
              ) ,
            ),
          );
        });
      }
    });
  }

  void showNotification(String notificationTitle, String notificationBody){
    flutterLocalNotificationsPlugin.show(0, notificationTitle, notificationBody,
        NotificationDetails(
            android: AndroidNotificationDetails(
               channel.id,
              channel.name,
              // channel.description,
              importance: Importance.high,
              color: Colors.green,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails()
        ));
  }

  Future deliveryStream()async{
    var prefs = await SharedPreferences.getInstance();

    var start = FirebaseFirestore.instance.collection('prices').snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        var twoKm = doc['twoKm'];
        var fourKm = doc['fourKm'];
        var sixKm = doc['sixKm'];
        var nineKm = doc['nineKm'];
        var longKm = doc['longKm'];
        var rewardRatio = doc['rewardRatio'];
        var support = doc['support'];
        var blender = doc['blender'];
        var heading  = doc['heading'];
        var body = doc['body'];

        setState(() {
          Provider.of<BlenditData>(context, listen: false).setBlenderDefaultPrice(blender);
          prefs.setInt(kTwoKmDistance, twoKm);
          prefs.setInt(kFourKmDistance, fourKm);
          prefs.setInt(kSixKmDistance, sixKm);
          prefs.setInt(kNineKmDistance, nineKm);
          prefs.setInt(kLongKmDistance, longKm);
          prefs.setDouble(kRewardsRatio, rewardRatio);
          prefs.setString(kSupportNumber, support);
          prefs.setString(kAboutHeading, heading);
          prefs.setString(kAboutBody, body);
          prefs.setInt(kBlenderBaseValue, blender);
        });
      });
    });
    return start;
  }
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Hey';
    }
    return 'Hi';
  }
  String greetingEmoji() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return '😊';
    }
    if (hour < 17) {
      return '🤗';
    }
    return '🙂';
  }
  String blenderMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Add Ingredients to your Blender';
      // return 'Want to blend something Nutritious?';
    }
    if (hour < 17) {
      return 'What would you like to blend';
    }
    return 'Want to blend something Nutritious?';
  }
  Future<dynamic> getIngredients() async {
    vegetables = [];
    fruits = [];
    extras = [];
    vegInfo = [];
    fruitInfo = [];
    extraInfo = [];

  final availableIngredients = await FirebaseFirestore.instance
      .collection('ingredients').orderBy('name',descending: false)
      // .where('quantity', isGreaterThan: 0)
      .get()
      .then((QuerySnapshot querySnapshot) {
  querySnapshot.docs.forEach((doc) {
    if (doc['category']== 'vegetables'){
      vegetables.add(doc['name']);
      vegInfo.add(doc['info']);


    } else if(doc['category']== 'fruits'){
      fruits.add(doc['name']);
      fruitInfo.add(doc['info']);
    } else{
      extras.add(doc['name']);
      extraInfo.add(doc['info']);
    }
  });

  });
  return availableIngredients ;
}

@override
  var formatter = NumberFormat('#,###,000');
  var vegetables= [''];
  var fruits = [''];
  var boxColours = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  var extras = [''];
  var vegInfo = [''];
  var fruitInfo = [''];
  var extraInfo = [''];


  Widget build(BuildContext context) {
    var blendedData = Provider.of<BlenditData>(context);
    Size size = MediaQuery.of(context).size;


    var fruitProvider = Provider.of<BlenditData>(context).boxColourListFruit;
    var vegProvider = Provider.of<BlenditData>(context).boxColourListVeg;
    var extraProvider = Provider.of<BlenditData>(context).boxColourListExtra;
    return Scaffold(

      backgroundColor: kBiegeThemeColor ,
      floatingActionButton: FloatingActionButton.extended(

        backgroundColor: blendedData.blendButtonColour,
        onPressed: (){

          if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
            AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');

          }
          else {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SelectedIngredientsListView();
                });
          }
        },
        icon: Icon(LineIcons.blender),
        label: Text('Start Blending'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      // appBar: AppBar(
      //   shadowColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   title: Text(''),
      //   backgroundColor: kBiegeThemeColor,
      //   leading:Transform.translate(offset: Offset(20*0.7, 0),
      //     child: IconButton(
      //       icon: Icon(LineIcons.trophy, color: Colors.grey,),
      //       onPressed: () {
      //        // showNotification('notificationTitle', 'notificationBody');
      //
      //         Navigator.pushNamed(context, LoyaltyPage.id);
      //       },
      //     ),
      //   ),
      //   actions: [
      //     GestureDetector(
      //       onTap: (){
      //         Navigator.pushNamed(context, SettingsPage.id);
      //       },
      //       child: Container(
      //           padding:EdgeInsets.all(10),child:
      //       Icon(LineIcons.user, color: Colors.grey,)),
      //     )],
      // ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(

              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${greeting()} $firstName ${greetingEmoji()},\n${blenderMessage()}', textAlign:TextAlign.center , style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 18
                  ),),
                  SizedBox(height: 10,),
                  ingredientButtons(
                    buttonTextColor: Colors.white,
                    buttonColor: blendedData.ingredientsButtonColour,
                      firstButtonFunction: (){
                        showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            color: Color(0xFF6e7069),
                            child:
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),color: kPinkBlenderColor,),
                              padding: EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          radius: 12,
                                          child: Icon(Icons.arrow_back, size: 12, color: Colors.white,)),
                                      SizedBox(width: 10,),
                                      Text('Selected Ingredients ${Provider.of<BlenditData>(context).ingredientsNumber}', style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                          radius: 12,
                                          child: Icon(Icons.arrow_forward, size: 12, color: Colors.white,)),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Vegetables 🥬',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  SizedBox(height: 10,),
                                  IngredientsList(ingredients: vegetables, boxColors: boxColours, provider: vegProvider, type: 'veggie', info: vegInfo,),
                                  SizedBox(height: 10,),
                                  Text('Fruits 🍓',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  SizedBox(height: 10,),
                                  IngredientsList(ingredients: fruits, boxColors: boxColours, provider: fruitProvider, type: 'fruit', info: fruitInfo,),
                                  SizedBox(height: 10,),
                                  Text('Extras 🥑'
                                    ,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  SizedBox(height: 10,),
                                  IngredientsList(ingredients: extras, boxColors: boxColours, provider: extraProvider, type: 'extra', info: extraInfo,),
                                  SizedBox(height: 20),
                                ingredientButtons(buttonTextColor: Colors.white, buttonColor: Colors.green, buttonTextSize: 12, lineIconFirstButton: LineIcons.thumbsUp, firstButtonFunction: (){Navigator.pop(context); }, firstButtonText: 'Done (Ugx${formatter.format(blendedData.price)})')],
                              ),
                            ),
                          );
                        });
                        if (firstBlend == true){
                         firstBlendDone();
                          AlertPopUpDialogue(context, imagePath: 'images/longpress.json', text: 'To know the Health benefits of an ingredient long press on it', title: 'Tip 2: Long Press for Benefits');
                          AlertPopUpDialogue(context, imagePath: 'images/swipe.json', text: 'To view all ingredients Swipe left and Right on each Category', title: 'Tip 1: Swipe to View');

                        }
                      }, firstButtonText: 'Add Ingredients',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              child:
              Stack(children:[
                GestureDetector(
                    onTap: (){
                      if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
                        AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');
                      }
                      else {
                        //Vibration.vibrate(pattern: [200, 500, 200]);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SelectedIngredientsListView();
                            });
                      }
                    },
                    child: Image.asset(blendedData.blenderImage)),
                Positioned(
                  right: 30,
                  top: 15,
                  child: GestureDetector(
                    child:
                    Row(
                        children:[

                          CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.orange,
                              child: Text('${blendedData.ingredientsNumber}',style: TextStyle(color: Colors.white, fontSize: 15),)),
                          //SizedBox(width: 5,),
                          Icon(LineIcons.blender, color: Colors.black,size: 25,),

                        ] ),
                    onTap: (){
                      if(Provider.of<BlenditData>(context, listen: false).ingredientsNumber == 0){
                        AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');
                      }
                      else {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SelectedIngredientsListView();
                            });
                      }
                    },

                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qty (Litres)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          QuantityBtn(onTapFunction: (){
                            Provider.of<BlenditData>(context, listen: false).decreaseLitres();

                          }, text: '-', size: 28,),
                          const SizedBox(width: 3,),
                          Text('${blendedData.litres}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(width: 3,),
                          QuantityBtn(onTapFunction: (){
                            Provider.of<BlenditData>(context, listen: false).increaseLitres();
                          }, text: '+',size: 28),
                        ],
                      ),
                      const SizedBox(height: 10,) ,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Ugx ${formatter.format(blendedData.price)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),)
                        ],
                      ),
                    ],
                  ),
                ),

              ] ),
            ),

          ],
        ),
      ),
    );
  }

  Future<dynamic> AlertPopUpDialogue(BuildContext context,
      {required String imagePath, required String text, required String title}) {

    return CoolAlert.show(
              lottieAsset: imagePath,
              context: context,
              type: CoolAlertType.success,
              text: text,
              title: title,
              confirmBtnText: 'Ok',
              confirmBtnColor: Colors.green,
              backgroundColor: kBlueDarkColor,
          );
  }
}

