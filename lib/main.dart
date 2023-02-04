import 'package:blendit_2022/controllers/gym_tabs_controller.dart';
import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/screens/about_challenge_page.dart';
import 'package:blendit_2022/screens/about_us.dart';
import 'package:blendit_2022/screens/allProducts_page.dart';
import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/blender_page_salad.dart';
import 'package:blendit_2022/screens/browse_store.dart';
import 'package:blendit_2022/screens/calendar_page.dart';
import 'package:blendit_2022/screens/challenge_page.dart';
import 'package:blendit_2022/screens/chat_designed_page.dart';
import 'package:blendit_2022/screens/chat_page.dart';
import 'package:blendit_2022/screens/chat_third_design.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/screens/choose_juice_page.dart';
import 'package:blendit_2022/screens/customized_juice_page.dart';
import 'package:blendit_2022/screens/delivery_page.dart';
import 'package:blendit_2022/screens/detox_juice.dart';
import 'package:blendit_2022/screens/detox_plans.dart';
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/home_page_origina.dart';
import 'package:blendit_2022/screens/input_page.dart';
import 'package:blendit_2022/screens/loading_ingredients_page.dart';
import 'package:blendit_2022/screens/login_page.dart';
import 'package:blendit_2022/screens/loyalty_page.dart';
import 'package:blendit_2022/screens/make_payment_page.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/screens/blog_comments_page.dart';
import 'package:blendit_2022/screens/blog_page.dart';
import 'package:blendit_2022/screens/new_logins/signin_phone.dart';
import 'package:blendit_2022/screens/new_logins/verify_phone.dart';
import 'package:blendit_2022/screens/new_settings.dart';
import 'package:blendit_2022/screens/nutri_mobile_money.dart';
import 'package:blendit_2022/screens/onboarding_page.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page1.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page_name.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:blendit_2022/screens/paymentMode_page.dart';
import 'package:blendit_2022/screens/phone_details_page.dart';
import 'package:blendit_2022/screens/rating_page.dart';
import 'package:blendit_2022/screens/register_page.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/screens/settings_page.dart';
import 'package:blendit_2022/screens/splash_page.dart';
import 'package:blendit_2022/screens/success_appointment_create.dart';
import 'package:blendit_2022/screens/success_challenge_done.dart';
import 'package:blendit_2022/screens/success_page.dart';
import 'package:blendit_2022/screens/tropical_page.dart';
import 'package:blendit_2022/screens/welcome_page.dart';
import 'package:blendit_2022/screens/welcome_page_new.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';



import 'controllers/push_notification_service.dart';
import 'models/blendit_data.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
  await PushNotificationService().setupInteractedMessage();
  runApp(MyApp());
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:
    [
      ChangeNotifierProvider(
        create: (BuildContext context) {
          return BlenditData();
        },),
      ChangeNotifierProvider(
        create: (BuildContext context) {
          return AiProvider();
        },),
    ],

      child: OverlaySupport(
        child: GetMaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),

          debugShowCheckedModeBanner: false,

          initialRoute: SplashPage.id,

          routes: {
            // '/': (context) => WelcomePage(),
            // HomePage.id: (context) => HomePage(),
            HomePage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> HomePage()),),
            ControlPage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> FeatureDiscovery(recordStepsInSharedPreferences: false, child: ControlPage()),)),
            // ControlPage.id: (context) => FeatureDiscovery(recordStepsInSharedPreferences: false, child: ControlPage()),
            DetoxJuicePage.id: (context)=> DetoxJuicePage(),
            DetoxPlansPage.id: (context)=> DetoxPlansPage(),
            SaladsPage.id: (context)=> SaladsPage(),
            TropicalPage.id: (context)=> TropicalPage(),
            OrdersPage.id: (context)=> OrdersPage(),
            CheckoutPage.id: (context)=> CheckoutPage(),
            LoadingIngredientsPage.id: (context)=> LoadingIngredientsPage(),
            DeliveryPage.id: (context)=> DeliveryPage(),
            WelcomePage.id: (context)=> WelcomePage(),
            WelcomePageNew.id: (context)=> WelcomePageNew(),
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
            AboutUsPage.id: (context)=>AboutUsPage(),
            ReadComments.id: (context)=>ReadComments(comments: [],),
            CustomizeController.id: (context)=>CustomizeController(),
            SaladBlenderPage.id: (context)=>SaladBlenderPage(),
            QuizQuestions.id: (context)=>QuizQuestions(),
            ChooseJuicePage.id: (context)=>ChooseJuicePage(),
            BrowseStorePage.id: (context)=>BrowseStorePage(),
            PhoneDetailsPage.id: (context)=>PhoneDetailsPage(),
            RatingPage.id: (context)=>RatingPage(),
            ChatPage.id: (context)=>ChatPage(),
            ChatDesignedPage.id: (context)=>ChatDesignedPage(),
            NewSettingsPage.id: (context)=>NewSettingsPage(),
            ChatThirdDesignedPage.id: (context)=>ChatThirdDesignedPage(),
            VerifyPinPage.id: (context)=>VerifyPinPage(),
            HomePageOriginal.id: (context)=>HomePageOriginal(),
            MakePaymentPage.id: (context)=>MakePaymentPage(),
            SignInPhone.id: (context)=>SignInPhone(),
            QuizPageName.id: (context)=>QuizPageName(),
            QuizPage1.id: (context)=>QuizPage1(),
            ChallengePage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> ChallengePage()),),
            CalendarPage.id: (context)=>CalendarPage(),
            SuccessPageNew.id: (context)=> SuccessPageNew(),
            SuccessPageChallenge.id: (context)=> SuccessPageChallenge(),
            AppointmentsTabController.id: (context)=> AppointmentsTabController(),
            AboutChallengePage.id: (context)=> AboutChallengePage(),
            NutriMobileMoneyPage.id: (context)=> NutriMobileMoneyPage(),



          },
        ),
      ),
    );
  }

}
