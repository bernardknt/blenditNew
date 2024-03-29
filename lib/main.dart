import 'dart:io';

import 'package:blendit_2022/controllers/gym_tabs_controller.dart';
import 'package:blendit_2022/controllers/customize_controller.dart';
import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/controllers/orders_controller_page.dart';
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/screens/about_challenge_page.dart';
import 'package:blendit_2022/screens/about_us.dart';
import 'package:blendit_2022/screens/ai_juice.dart';
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
import 'package:blendit_2022/screens/customer_care.dart';
import 'package:blendit_2022/screens/customized_juice_page.dart';
import 'package:blendit_2022/screens/delivery_page.dart';
import 'package:blendit_2022/screens/detox_juice.dart';
import 'package:blendit_2022/screens/detox_plans.dart';
import 'package:blendit_2022/screens/home_page.dart';
import 'package:blendit_2022/screens/home_page_original.dart';
import 'package:blendit_2022/screens/input_page.dart';
import 'package:blendit_2022/screens/loading_ingredients_page.dart';
import 'package:blendit_2022/screens/login_page.dart';
import 'package:blendit_2022/screens/loyalty_page.dart';
import 'package:blendit_2022/screens/make_payment_page.dart';
import 'package:blendit_2022/screens/mobileMoney.dart';
import 'package:blendit_2022/screens/blog_comments_page.dart';
import 'package:blendit_2022/screens/blog_page.dart';
import 'package:blendit_2022/screens/new_logins/sign_in_options.dart';
import 'package:blendit_2022/screens/new_logins/sign_in_phone.dart';
import 'package:blendit_2022/screens/new_logins/verify_phone.dart';
import 'package:blendit_2022/screens/new_settings.dart';
import 'package:blendit_2022/screens/nutri_mobile_money.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page1.dart';
import 'package:blendit_2022/screens/onboarding_questions/quiz_page_name.dart';
import 'package:blendit_2022/screens/orders_page.dart';
import 'package:blendit_2022/screens/paymentMode_page.dart';
import 'package:blendit_2022/screens/phone_details_page.dart';
import 'package:blendit_2022/screens/products_page.dart';
import 'package:blendit_2022/screens/purchase_restored_page.dart';
import 'package:blendit_2022/screens/qualityBot.dart';
import 'package:blendit_2022/screens/rating_page.dart';
import 'package:blendit_2022/screens/register_page.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/screens/settings_page.dart';
import 'package:blendit_2022/screens/SplashPages/splash_page.dart';
import 'package:blendit_2022/screens/success_appointment_create.dart';
import 'package:blendit_2022/screens/success_challenge_done.dart';
import 'package:blendit_2022/screens/success_page.dart';
import 'package:blendit_2022/screens/tropical_page.dart';
import 'package:blendit_2022/screens/upload_photo.dart';
import 'package:blendit_2022/screens/welcome_page.dart';
import 'package:blendit_2022/screens/Welcome_Pages/welcome_page_mobile.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/memories_page.dart';
import 'package:feature_discovery/feature_discovery.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';



import 'controllers/controller_page_web.dart';
import 'controllers/push_notification_service.dart';
import 'controllers/settings_tab_controller.dart';
import 'models/blendit_data.dart';



// final _configuration = PurchasesConfiguration(kIsWeb?"ThisIsARandomString": Platform.isIOS ? kRevenueCatPurchasesKeyIOS : kRevenueCatPurchasesKeyAndroid);
final _configuration = PurchasesConfiguration(Platform.isIOS ? kRevenueCatPurchasesKeyIOS : kRevenueCatPurchasesKeyAndroid);
// final String _configuration = _calculateConfiguration();



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}


Future <void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // This configures the in-app purchases
  if(kIsWeb) {

  }else{
    await Purchases.configure(_configuration);
  }
  if (kIsWeb){
     await Firebase.initializeApp(
       options: FirebaseOptions(
         apiKey: "AIzaSyDQV0-v1IfqWDYqZzrKR2Kt1_9G2gjrhiQ",
         appId: "1:1036391886488:web:305af76a997a5610f46aed",
         messagingSenderId: "1036391886488",
         projectId: "blend-it-8a622",
         storageBucket: "gs://blend-it-8a622.appspot.com",
       ),
     );
  }else {
    await Firebase.initializeApp();
  }




  // Get an instance of FirebaseAppCheck
  // FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
  // Disable App Check temporarily
  // await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);

// Install the Play Integrity provider factory
//   firebaseAppCheck.activate();

  await PushNotificationService().setupInteractedMessage();
  runApp(MyApp());
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
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
        // initialRoute: ResponsiveLayout(mobileBody: SplashPage(), desktopBody: SplashPage()),
         //  initialRoute: ControlPage.id,

          routes: {
            // '/': (context) => WelcomePage(),
            // HomePage.id: (context) => HomePage(),
            HomePage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> FeatureDiscovery(recordStepsInSharedPreferences: false,child: HomePage())),),
            ControlPage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> FeatureDiscovery(recordStepsInSharedPreferences: false, child: ControlPage()),)),
            ControlPageWeb.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> FeatureDiscovery(recordStepsInSharedPreferences: false, child: ControlPageWeb()),)),
            AiJuice.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> AiJuice(),)),

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
            WelcomePageMobile.id: (context)=> WelcomePageMobile(),
            RegisterPage.id: (context)=> RegisterPage(),
            // BlenderOnboardingPage.id: (context)=>BlenderOnboardingPage(),
            NewBlenderPage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> NewBlenderPage(),)),
            // NewBlenderPage.id: (context)=>  NewBlenderPage(),
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
            SettingsTabController.id: (context)=>SettingsTabController(),
            SaladBlenderPage.id: (context)=>SaladBlenderPage(),
            CustomerCareChatMessaging.id: (context)=>CustomerCareChatMessaging(),
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
            SignInOptions.id: (context)=>SignInOptions(),
            SignInPhone.id: (context)=>SignInPhone(),
            QuizPageName.id: (context)=>QuizPageName(),
            QuizPage1.id: (context)=>QuizPage1(),
            ChallengePage.id: (context) => ShowCaseWidget(builder: Builder(builder:(_)=> ChallengePage()),),
            CalendarPage.id: (context)=>CalendarPage(),
            UploadAiPhoto.id: (context)=>UploadAiPhoto(),
            SuccessPageNew.id: (context)=> SuccessPageNew(),
            SuccessPageChallenge.id: (context)=> SuccessPageChallenge(),
            AppointmentsTabController.id: (context)=> AppointmentsTabController(),
            AboutChallengePage.id: (context)=> AboutChallengePage(),
            NutriMobileMoneyPage.id: (context)=> NutriMobileMoneyPage(),
            RestorePurchasePage.id: (context)=> RestorePurchasePage(),
            QualityBot.id: (context)=> QualityBot(),
            MemoriesPage.id: (context)=> MemoriesPage(),
            ProductsPage.id: (context)=> ProductsPage(),
            OrdersTabController.id: (context)=> OrdersTabController(),
            ResponsiveLayout.id: (context)=> ResponsiveLayout(mobileBody: FeatureDiscovery(recordStepsInSharedPreferences: false, child: ControlPage()), desktopBody: FeatureDiscovery(recordStepsInSharedPreferences: false, child: ControlPageWeb())),

          },
        ),
      ),
    );
  }

}
