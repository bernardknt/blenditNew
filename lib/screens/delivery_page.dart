
import 'dart:ui';

import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/phone_details_page.dart';
import 'package:blendit_2022/screens/rating_page.dart';
import 'package:blendit_2022/screens/success_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/keyboard_overlay.dart';
import '../utilities/paymentButtons.dart';

var uuid = Uuid();
double boxOpacity = 0;
class DeliveryPage extends StatefulWidget {
  static String id = 'delivery_page';


  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {

  final auth = FirebaseAuth.instance;
  Future<dynamic> getPoints() async {
    var prefs = await SharedPreferences.getInstance();

    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .get();
      prefs.setInt(kLoyaltyPoints, users['loyalty']);

  }

  String name = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPoints();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Delivery Location', style: TextStyle(color: Colors.white54, fontSize: 15),),
      ),
      body: Map(),
    );
  }
}
//String phoneNumber = '';
class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  late GoogleMapController mapController;
  static const _initialPosition = LatLng(0.3476, 32.5825 );
  LatLng _lastPosition = _initialPosition;

  // final Set<Marker> _markers = {};
  String location = '';
  String instructions = '';

  final _dialog = RatingDialog(
    initialRating: 3.0,
    // your app's name?
    title: const Text(
      'Rate Your Order',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: const Text(
      'Tap a star to set your rating.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ),
    // your app's logo?
    image: Image.asset('images/black_logo.png',width: 150, height: 150, ),
    submitButtonText: 'Submit',
    commentHint: 'You can Add an extra Comment',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) async{
      var prefs = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('orders').doc(prefs.getString(kOrderId))
          .update({
        'rating': response.rating,
        'rating_comment': response.comment,
        'hasRated': true
      }
      );
      return 0;
    },
  );

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      // 'This channel is used for important Notifications',
      importance: Importance.high,
      playSound: true
  );


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
            iOS: IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                subtitle: channel.description

            )
        ));

  }
  void showRatingsDialogue(){
    showDialog(
      context: context,
      barrierDismissible: false, // set to false if you want to force a rating
      builder: (context) => RatingPage(),
    );
  }
  void showDialogue(imageString, body, heading, backgroundColor){
      CoolAlert.show(
          lottieAsset: imageString,
          context: context,
          type: CoolAlertType.success,
          text: body,
          title: heading,
          confirmBtnText: 'Ok 👍',
          confirmBtnColor: Colors.green,
          backgroundColor: backgroundColor
      );
  }
  final dateNow = new DateTime.now();
  Future transactionStream()async{
    var start = FirebaseFirestore.instance.collection('orders').where('orderNumber', isEqualTo: orderId).snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        var status = doc['status'];
        String imageString;
        String body;
        String heading;
        Color backgroundColor;
        if (status == 'submitted'){
          imageString = 'images/success.json';
          body ="Your Order has been Received!";
          heading ="Order Submitted!";
          backgroundColor = kBlueDarkColor;
          print('ORDER SUBMITTED');
          showDialogue(imageString, body, heading, backgroundColor);


        }else if (status == 'preparing'){
          imageString = 'images/cook.json';
          body ="Your is being Prepared!";
          heading ="Preparing Your Order";
          backgroundColor = Colors.white;
          showDialogue(imageString, body, heading, backgroundColor);

          print('ORDER PREPARING');

        }else if (status == 'Ready for Delivery'){
          imageString = 'images/shopping.json';
          body ="Your Order is ready for Delivery!";
          heading ="Ready for Delivery!";
          backgroundColor = Colors.teal;
          showDialogue(imageString, body, heading, backgroundColor);
          print('ORDER READY');
        }else if (status == 'delivering'){
          imageString = 'images/deliver.json';
          body ="Your Order is on its Way!";
          heading ="On its way";
          backgroundColor = kBiegeThemeColor;
          showDialogue(imageString, body, heading, backgroundColor);
          print('ORDER ON WAY');
        } else if(status == 'delivered'){
          showRatingsDialogue();
        }else {

        }
      });
    });
    return start;
    return start;
  }

  String orderId = 'bi${uuid.v1().split("-")[0]}';
  final auth = FirebaseAuth.instance;

  Future<dynamic> updatePoints() async {
    var prefs = await SharedPreferences.getInstance();
    var multiplier = prefs.getDouble(kRewardsRatio)!;
    var points = (Provider.of<BlenditData>(context, listen: false).totalPrice + Provider.of<BlenditData>(context, listen: false).deliveryFee) * multiplier;
    var intPoints =  points.round();

    Provider.of<BlenditData>(context, listen: false).setRewardPoints(intPoints);
    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update({
      'loyalty': FieldValue.increment(intPoints),
      'orderCount': FieldValue.increment(1)
    }
    );
  }

  Future<dynamic> decreasePoints(int value) async {
    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update({
      'loyalty': FieldValue.increment( value),
    }
    ).then((val){
          Get.snackbar("Points Successfully Applied", "You have used ${-value} points");
          Provider.of<BlenditData>(context, listen: false).setRemoveLoyaltyPoints(value);
          Provider.of<BlenditData>(context, listen: false).setLoyaltyApplied(true, 0.0);
          // Provider.of<BlenditData>(context, listen: false).setLoyaltyInitialValue("0", kGreenThemeColor, 0.0, kGreenThemeColor, 0.0);
        }).catchError((error) => Get.snackbar("Error Occured", "Points not removed! Check your internet"));

  }
  late TextEditingController initialController = TextEditingController()..text = '';

  CollectionReference userOrder = FirebaseFirestore.instance.collection('orders');


  Future<void> upLoadOrder (DateTime deliverTime,String chef_note, String deliverInstructions, String newLocation, String phoneNumber, bool loyaltyApplied )async {

    final prefs =  await SharedPreferences.getInstance();
    var products = Provider.of<BlenditData>(context, listen: false).basketItems;


    return userOrder.doc(orderId)
        .set({
      'client': Provider.of<BlenditData>(context, listen: false).customerName,
      //prefs.getString(kFullNameConstant),
      'client_phoneNumber': phoneNumber, // John Doe
      'chef_note': chef_note, // Stokes and Sons
      'instructions': deliverInstructions,
      'sender_id': prefs.getString(kEmailConstant),
      'location': newLocation,
      'deliveryTime': deliverTime,
      'orderNumber': orderId,
      'paymentMethod': 'cash',
      'paymentStatus': 'pending',
      'rating':0,
      'rating_comment': '',
      'hasRated': false,
      'distance': Provider.of<BlenditData>(context, listen: false).distance,
      'status': 'submitted',
      'total_price': Provider.of<BlenditData>(context, listen: false).totalPrice + Provider.of<BlenditData>(context, listen: false).deliveryFee,
      'order_time': dateNow,
      'prepareStartTime':dateNow,
      'prepareEndTime':dateNow,
      'chef': 'none',
      'loyaltyApplied': loyaltyApplied,
      'token': prefs.getString(kToken),
      'phoneNumber': prefs.getString(kPhoneNumberConstant),
      'items': [for(var i = 0; i < products.length; i ++){
        'product': products[i].name,
        'description': products[i].details,
        'quantity': products[i].quantity,
        'totalPrice': products[i].amount,
      }
      ]
    })
        .then((value) {
          Navigator.pushNamed(context, SuccessPage.id);
          updatePoints();
          Provider.of<BlenditData>(context, listen: false).setLoyaltyApplied(false, 1.0);
          showNotification('Order Received', '${prefs.getString(kFirstNameConstant)} we have received your order! We shall have it ready for Delivery');
        } )
        .catchError((error) => Get.snackbar("Error Placing Order", "Ooops something seems to have gone wrong. Check your internet"));
  }

  void defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(kIsPhoneNumberSaved)  == false){
      phoneNumber = prefs.getString(kPhoneNumberAlternative) ?? '0700123123';

       } else {

      phoneNumber = prefs.getString(kPhoneNumberConstant)!;

    }


    initialController = TextEditingController()..text = phoneNumber;


  }
  int deliveryFee = 0;
  late String phoneNumber;
  late String name;
  TextField searchBar() {
    var textToUse;
    if (Provider.of<BlenditData>(context).location == ''){
      textToUse = 'Workers House';
    }else {
      textToUse =  Provider.of<BlenditData>(context).location;
    }
    return TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          fillColor: kBlueDarkColor,
          filled: true,
          contentPadding:const EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: const Icon(LineIcons.search, color: Colors.white,),
          hintText: textToUse,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: const Icon(LineIcons.flag)
      ),
      onTap: ()async{

        var blendedDataModify = Provider.of<BlenditData>(context, listen: false);
        Prediction? p = await PlacesAutocomplete.show(context: context,
            apiKey: kGoogleMapsApiKey, types: [],
        strictbounds: true,
        mode: Mode.overlay,
        location: Location(lat: 0.3173, lng: 32.5927), // 0.3172959363980288, 32.59267831534121
        radius: 10000,
        language: 'en', components: [Component(Component.country, 'UG')]);

        if (p != null){
          Provider.of<BlenditData>(context, listen: false).setLocation(p.description!);
          GoogleMapsPlaces _places = GoogleMapsPlaces(
            apiKey: kGoogleMapsApiKey,
            //apiHeaders: await GoogleApiHeaders().getHeaders(),
          );
          PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
          final lat = detail.result.geometry!.location.lat;
          final lng = detail.result.geometry!.location.lng;
          final prefs = await SharedPreferences.getInstance();

          double distanceInMeters = 6.5;

          // Geolocator.distanceBetween(0.3173, 32.5927, lat, lng);
          blendedDataModify.setDeliveryDistance(distanceInMeters);
          if (distanceInMeters < 2000.0){

            blendedDataModify.setDeliveryFee(prefs.getInt(kTwoKmDistance));


          }else if ( 2000 < distanceInMeters && distanceInMeters < 4500){

            blendedDataModify.setDeliveryFee(prefs.getInt(kFourKmDistance));
          }else if ( 4500 < distanceInMeters && distanceInMeters < 6000){

            blendedDataModify.setDeliveryFee(prefs.getInt(kSixKmDistance));
          }else if ( 6000 < distanceInMeters && distanceInMeters < 9000){

            blendedDataModify.setDeliveryFee(prefs.getInt(kNineKmDistance));
          }
          else {

           blendedDataModify.setDeliveryFee(prefs.getInt(kLongKmDistance));
          }

          setState(() {
            boxOpacity = 1.0;
            //location = p.description!;
          });
          return
            CoolAlert.show(
              lottieAsset: 'images/deliver.json',
              context: context,
              type: CoolAlertType.success,
              widget: TextField(
                onChanged: (description){
                  instructions = description;
                  setState(() {

                  });


                },
              ),
              text: 'Give us extra instructions to make sure your package reaches you',
              title: 'Extra Instructions',
              confirmBtnText: 'Ok',
              confirmBtnColor: Colors.green,
              backgroundColor: kBiegeThemeColor,
              onConfirmBtnTap: (){
                Provider.of<BlenditData>(context, listen:false).setDeliverInstructions(instructions);
                Navigator.pop(context);
          }
          );
        }
      },
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleMapsApiKey,
        //apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }
  // This code places a done button on the iOS number bad after entering the phone number on delivery page
  FocusNode numberFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    // This code places a done button on the iOS number bad after entering the phone number on delivery page
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    // This code places a done button on the iOS number bad after entering the phone number on delivery page
  }
  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var blendedData = Provider.of<BlenditData>(context);


    var myController = initialController;
    var formatter = NumberFormat('#,###,000');
    var numbersColor = Colors.green;
    var loyaltyValue = 0;
    return Stack(
      children: [
        GoogleMap(initialCameraPosition: const CameraPosition(target: _initialPosition,zoom: 10),
          onMapCreated: onCreated,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          onCameraMove: onCameraMove,

        ),
        Positioned(
          top: 20,
          right: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                searchBar(),
                SizedBox(height: 20,),
                Opacity(
                  opacity: blendedData.locationOpacity,
                  child:
                  Stack(
                    children: [

                    Container( padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(const Radius.circular(20)),color: kBlueDarkColor ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: Colors.white,),
                          Text(blendedData.location, style: TextStyle(fontSize: 18, color: Colors.white),),
                          SizedBox(height: 10,),
                          Text('Instructions:  ${blendedData.deliveryInstructions}',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white),),
                          SizedBox(height: 10,),
                          Text('Note: ${blendedData.chefInstructions}',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.white),),
                          SizedBox(height: 10,),
                          Text('Delivery Dist(km):  ${(blendedData.distance / 1000).toStringAsFixed(1)} km',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white),),
                          SizedBox(height: 10,),
                          Text('Delivery Time(Est):  ${DateFormat('EEE-kk:mm aaa').format(blendedData.deliveryTime)}',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white),),
                          SizedBox(height: 10,),
                          Text('Items Fee: ${blendedData.totalPrice}',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white),),
                          SizedBox(height: 10,),
                          Text('Delivery Fee: ${blendedData.deliveryFee}',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white),),
                          SizedBox(height: 4,),
                          Text('_________________',textAlign: TextAlign.start, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
                          SizedBox(height: 2,),
                          Row(

                            children: [
                              Text('Total: UGX ${formatter.format(blendedData.totalPrice + blendedData.deliveryFee)}',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
                              SizedBox(width: 40,),
                              GestureDetector(
                                  onTap: () async {
                                    if(blendedData.loyaltyAccessButton != 0){
                                      var prefs = await SharedPreferences.getInstance();
                                      int? loyaltyPoints = prefs.getInt(kLoyaltyPoints);
                                      loyaltyValue = 0;
                                      blendedData.setLoyaltyInitialValue("0", kGreenThemeColor, 0.0, Colors.grey, 1.0);
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return
                                              Container(
                                                color: const Color(0xFF5e5b5b),

                                                child:
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [kBlueDarkColor, Colors.black] ),
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),  topLeft: Radius.circular(20)),
                                                      color: Colors.green
                                                  ),

                                                  child: Padding(padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      children: [
                                                        Text('YOU HAVE ${loyaltyPoints.toString()} LOYALTY POINTS ',
                                                          style:
                                                          const TextStyle(fontWeight: FontWeight.bold, color: kPinkBlenderColor, fontSize: 18),),
                                                        const SizedBox(height: 10,),
                                                        Text('${loyaltyPoints.toString()} points = ${formatter.format(loyaltyPoints)} Ugx',
                                                          //'${loyaltyPoints.toString()} Points',
                                                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                        ),


                                                        const SizedBox(height: 10,),
                                                        Row(

                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: (){


                                                              },
                                                              child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 15),),),
                                                            // Icon(LineIcons.moneyBill, color: Colors.white,size: 15,),

                                                            const SizedBox(width: 10,),
                                                            Expanded(
                                                                child: TextField(
                                                                  onChanged: (value){

                                                                    // blendedDataSet.setLoyaltyInitialValue(value);
                                                                    var trueValue = int.parse(value); // This
                                                                    // var trueLoyalty = loyaltyPoints; // The Loyalty Points
                                                                    if (trueValue <= loyaltyPoints! && trueValue <= (blendedData.totalPrice + blendedData.deliveryFee)) { // The entered value


                                                                      blendedData.setLoyaltyInitialValue(value, kGreenThemeColor, 0.0, kGreenThemeColor, 1.0);
                                                                      loyaltyValue = int.parse(value);
                                                                      print(blendedData.loyaltyValueInitial);


                                                                    } else {
                                                                      blendedData.setLoyaltyInitialValue("0", Colors.red, 1.0, Colors.grey, 1.0);


                                                                    }

                                                                  },
                                                                  // controller: amountController,
                                                                  textAlign: TextAlign.center,
                                                                  decoration: const InputDecoration(
                                                                    suffixIcon: Icon(LineIcons.moneyBill, size: 15,color: kBiegeThemeColor,),
                                                                    labelText: 'amount',
                                                                    labelStyle: TextStyle(fontSize: 15, color: Colors.white),
                                                                    hintText: '0.00',
                                                                    hintStyle: TextStyle(color: Colors.white),
                                                                    enabledBorder: UnderlineInputBorder(
                                                                      borderSide: BorderSide(color: kBiegeThemeColor),
                                                                    ),
                                                                    focusedBorder: UnderlineInputBorder(
                                                                      borderSide: BorderSide(color:  kBiegeThemeColor),
                                                                    ),
                                                                    border: UnderlineInputBorder(
                                                                      borderSide: BorderSide(color:  kBiegeThemeColor),
                                                                    ),
                                                                  ),

                                                                  selectionWidthStyle: BoxWidthStyle.tight,
                                                                  keyboardType: TextInputType.number,
                                                                  style: TextStyle(color: blendedData.loyaltyColor, fontSize: 30),


                                                                )

                                                            ),
                                                          ],
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child: Column(
                                                            children: [
                                                              Opacity(

                                                                  opacity: blendedData.loyaltyWarningOpacity,
                                                                  child: Text("Amount Greater than available loyalty points or Bill", style: const TextStyle(color: Colors.red),)),
                                                              SizedBox(height: 10,) ,
                                                              Text('Your total bill will be ${formatter.format(Provider.of<BlenditData>(context, listen: false).totalPrice + Provider.of<BlenditData>(context, listen: false).deliveryFee - int.parse(blendedData.loyaltyValueInitial))} Ugx', style: const TextStyle(color: Colors.white),),
                                                            ],
                                                          ),
                                                        ),
                                                        paymentButtons(lineIconFirstButton: LineIcons.backspace, lineIconSecondButton: LineIcons.thumbsUp, continueFunction: (){Navigator.pop(context); }, continueBuyingText: "Cancel", checkOutText: "Apply", buyFunction: (){
                                                          if (blendedData.loyaltyApplyButton != Colors.grey ){
                                                            Get.defaultDialog(
                                                              title: 'Apply Loyalty Points?',
                                                              middleText: "You are reducing your current bill to ${formatter.format(Provider.of<BlenditData>(context, listen: false).totalPrice + Provider.of<BlenditData>(context, listen: false).deliveryFee - int.parse(blendedData.loyaltyValueInitial))} Ugx."
                                                                  " By clicking OK, your loyalty points will be applied to this purchase and cannot be redeemed should you decide not to purchase now.",
                                                              onConfirm: (){
                                                                decreasePoints(-(int.parse(blendedData.loyaltyValueInitial)));
                                                                Navigator.pop(context);
                                                                Navigator.pop(context);

                                                              },
                                                              onCancel: (){
                                                                Navigator.pop(context);
                                                              },
                                                              cancelTextColor: Colors.red,
                                                              confirmTextColor: Colors.white,

                                                            );


                                                          }
                                                        },secondButtonColor: blendedData.loyaltyApplyButton,)
                                                      ],
                                                    ),

                                                  ),
                                                ),
                                              );
                                          });
                                    }
                                  },
                                  child:
                                  Opacity(
                                      opacity: blendedData.loyaltyAccessButton,
                                      child: Lottie.asset('images/loyalty.json', width: 25)),
                                  //const CircleAvatar(child: Icon(LineIcons.addressCard, color: Colors.white)
                                )

                            ],
                          ),
                          const Text('_________________',textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
                          const SizedBox(height: 7,),

                          Row(
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [

                                  Text('+256', style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                                  SizedBox(height: 20,)
                                ],
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child:
                                TextField(

                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return PhoneDetailsPage();
                                        });

                                  },
                                  cursorHeight: 10,
                                  maxLength: 9,
                                  controller: myController,
                                  mouseCursor: MouseCursor.defer,
                                  keyboardType: TextInputType.none,
                                  // focusNode: numberFocusNode,
                                  decoration: const InputDecoration(filled: true,
                                  fillColor: Colors.grey,

                                  //labelText: 'Mobile Number',
                                  border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),),
                              ),],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ingredientButtons(firstButtonFunction: ()async{
                                final prefs =  await SharedPreferences.getInstance();
                                var amountToPay = Provider.of<BlenditData>(context, listen: false).totalPrice + Provider.of<BlenditData>(context, listen: false).deliveryFee ;
                                upLoadOrder(blendedData.deliveryTime, blendedData.chefInstructions, blendedData.deliveryInstructions, blendedData.location, phoneNumber, blendedData.loyaltyApplied);
                                prefs.setBool(kIsPhoneNumberSaved, true);
                                prefs.setString(kBillValue, amountToPay.toString());
                                prefs.setString(kOrderId, orderId);
                                transactionStream();
                                }, firstButtonText: 'Place Order', lineIconFirstButton: LineIcons.book,),
                            ],
                          )
                        ],
                      ),
                    ),
                      Positioned(
                          bottom: 8,
                          right : 4,
                          child:
                      GestureDetector(
                        onDoubleTap: (){
                          CoolAlert.show(
                              lottieAsset: 'images/swipe.json',
                              context: context,
                              type: CoolAlertType.success,
                              widget: Container(

                                child: TextField(
                                  onChanged: (customerName){
                                    instructions = customerName;
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                              text: 'Change the Customer Name below',
                              title: 'Customer Name',
                              confirmBtnText: 'Ok',
                              confirmBtnColor: Colors.green,
                              backgroundColor: kBlueDarkColor,
                              onConfirmBtnTap: (){
                                Provider.of<BlenditData>(context, listen:false).setCustomerName(instructions);
                                Navigator.pop(context);
                              }
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: kBlueDarkColor,
                          radius: 13,
                          child: Icon(CupertinoIcons.repeat, size: 13,)
                        ),
                      ))
                  ]
                  ),
                )
              ],
            ),
          ),
        ),
      ]

    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
  }
}



