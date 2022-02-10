import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/screens/about.dart';
import 'package:blendit_2022/screens/allProducts_page.dart';
import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/blender_page_salad.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/screens/choose_juice_page.dart';
import 'package:blendit_2022/screens/customized_juice_page.dart';
import 'package:blendit_2022/screens/delivery_page.dart';
import 'package:blendit_2022/screens/detox_juice.dart';
import 'package:blendit_2022/screens/detox_plans.dart';
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/input_page.dart';
import 'package:blendit_2022/screens/loading_ingredients_page.dart';
import 'package:blendit_2022/screens/login_page.dart';
import 'package:blendit_2022/screens/loyalty_page.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/screens/news_comments_page.dart';
import 'package:blendit_2022/screens/news_page.dart';
import 'package:blendit_2022/screens/onboarding_page.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:blendit_2022/screens/paymentMode_page.dart';
import 'package:blendit_2022/screens/register_page.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/screens/settings_page.dart';
import 'package:blendit_2022/screens/splash_page.dart';
import 'package:blendit_2022/screens/success_page.dart';
import 'package:blendit_2022/screens/tropical_page.dart';
import 'package:blendit_2022/screens/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';


import 'models/blendit_data.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    // 'This channel is used for important Notifications',
    importance: Importance.high,
    playSound: true
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(

    // Replace with actual values
    // name: 'Secondary App',

    // options: const FirebaseOptions(
    //   apiKey: "AIzaSyCwEb8qLqVUVgx6ZVHq49eu2BIRdGms2h4",
    //   appId: "1:1036391886488:web:ebbbb16f292e260af46aed",
    //   messagingSenderId: "1036391886488",
    //   projectId: "blend-it-8a622",
    // ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return BlenditData();
      },

      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: ShowCaseWidget(
            builder: Builder(builder: (_) => NewBlenderPage()),
          ),
        debugShowCheckedModeBanner: false,

        initialRoute: SplashPage.id,

        routes: {
          // '/': (context) => WelcomePage(),
          HomePage.id: (context) => HomePage(),
          ControlPage.id: (context) => ControlPage(),
          DetoxJuicePage.id: (context)=> DetoxJuicePage(),
          DetoxPlansPage.id: (context)=> DetoxPlansPage(),
          SaladsPage.id: (context)=> SaladsPage(),
          TropicalPage.id: (context)=> TropicalPage(),
          OrdersPage.id: (context)=> OrdersPage(),
          CheckoutPage.id: (context)=> CheckoutPage(),
          LoadingIngredientsPage.id: (context)=> LoadingIngredientsPage(),
          DeliveryPage.id: (context)=> DeliveryPage(),
          WelcomePage.id: (context)=> WelcomePage(),
          RegisterPage.id: (context)=> RegisterPage(),
          BlenderOnboardingPage.id: (context)=>BlenderOnboardingPage(),
          NewBlenderPage.id: (context)=>  NewBlenderPage(),
          InputPage.id: (context)=>InputPage(),
          SuccessPage.id: (context)=>SuccessPage(),
          SplashPage.id: (context)=>SplashPage(),
          AllProductsPage.id: (context)=>AllProductsPage(),
          BlogPage.id: (context)=>BlogPage(),
          SettingsPage.id: (context)=>SettingsPage(),
          LoginPage.id: (context)=>LoginPage(),
          MobileMoneyPage.id: (context)=>MobileMoneyPage(),
          LoyaltyPage.id: (context)=>LoyaltyPage(),
          PaymentMode.id: (context)=>PaymentMode(),
          AboutPage.id: (context)=>AboutPage(),
          ReadComments.id: (context)=>ReadComments(comments: [],),
          CustomizeController.id: (context)=>CustomizeController(),
          SaladBlenderPage.id: (context)=>SaladBlenderPage(),
          CustomizedJuicePage.id: (context)=>CustomizedJuicePage(),
          ChooseJuicePage.id: (context)=>ChooseJuicePage(),
        },
      ),
    );
  }

}
