

import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';
import 'package:blendit_2022/utilities/paymentProcessing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
var uuid = Uuid();

class MobileMoneyPage extends StatefulWidget {
  static String id = 'mobilePayment_page';


  @override
  _MobileMoneyPageState createState() => _MobileMoneyPageState();
}

class _MobileMoneyPageState extends State<MobileMoneyPage> {
  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFullNameConstant) ?? 'Minister';
    String newAmount = prefs.getString(kBillValue) ?? '0';
    String newPhoneNumber = prefs.getString(kPhoneNumberConstant) ?? '0';
    String? newOrderId = prefs.getString(kOrderId);
    myController = TextEditingController()..text = prefs.getString(kPhoneNumberConstant) ?? '0';

    setState(() {
      name = newName;
      amount = newAmount;
      phoneNumber = newPhoneNumber;
      //myController = initialController;
      formattedAmount = formatter.format(int.parse(amount));
      orderId = newOrderId!;

    });
  }
// CALLABLE FUNCTIONS FOR THE NODEJS SERVER (FIREBASE)
  final HttpsCallable callableBeyonicPayment = FirebaseFunctions.instance.httpsCallable(kBeyonicServerName);
  final HttpsCallable callableTransactionEmail = FirebaseFunctions.instance.httpsCallable(kEmailServerName);




  // THESE ARE FIRESTORE COLLECTION REFERENCES
  CollectionReference userTransactions = FirebaseFirestore.instance.collection('userTransactions');
  CollectionReference paymentTransactions = FirebaseFirestore.instance.collection('transactions');


  // FIREBASE FIRESTORE STREAM TO CHECK WHETHER THE TRANSACTION HAS BEEN SUCCESSFUL
  Future transactionStream()async{

    var start = FirebaseFirestore.instance.collection('transactions').where('uniqueID', isEqualTo: orderId).where('payment_status', isEqualTo: true).snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        // TRIGGER SERVER TRANSACTIONS EMAIL AND BEYONIC
        dynamic emailResp = await callableTransactionEmail.call(<String, dynamic>{
          'name': name,
          'emailAddress':kEmailConstant,
          'templateID':'bernard.ntege@tracnode.com',
          'currency': 'UGX',
          'purpose': orderId,
          'amount': amount,
          'transactionID': orderId,
          'subject': 'Blendit Transaction',

        });
        setState(() {
          CoolAlert.show(
              lottieAsset: 'images/thankyou.json',
              context: context,
              type: CoolAlertType.success,
              text: "Your Payment was successfully Received and Updated",
              title: "Payment Made",
              confirmBtnText: 'Ok 👍',
              confirmBtnColor: kGreenThemeColor,
              backgroundColor: kBlueDarkColor
          );

        });

      });
    });


    return start;
  }

  // FIREBASE FIRESTORE FUNCTION TO ADD DOCUMENT

  Future<void> addMobileMoneyTransaction() {

    final User? user = auth.currentUser;
    final emailUID = user!.email;
    return paymentTransactions.doc(transactionId).set({
      'name': name,
      'amount_paid': int.parse(amount), // John Doe
      'beyonic_charge': amountToCharge,
      'collectionID':0,
      'number': '256$phoneNumber',
      'payment_status': false,
      'currency': 'Ugx', // John Doe
      'date': dateNow, // Stokes and Sons
      'purpose': orderId,
      'uniqueID': orderId,
      'testID': transactionId,
      'email': emailUID,
    })
        .then((value){
      print('Nice');
    })
        .catchError((error){
      CoolAlert.show(
          lottieAsset: 'images/pourJuice.json',
          context: context,
          type: CoolAlertType.success,
          text: "Your Payment was unsuccessfully",
          title: "No Payment Made",
          confirmBtnText: 'Ok 👍',
          confirmBtnColor: kGreenThemeColor,
          backgroundColor: kBlueDarkColor
      );
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  // VARIABLE DECLARATIONS
  var formatter = NumberFormat('#,###,000');
  String transactionId = 'mm${uuid.v1().split("-")[0]}';
  String amount = '';
  String amountToCharge = '';
  String orderId = '';
  late String churchId ;
  final dateNow = new DateTime.now();
  double changeNumberOpacity = 0.0;
  String name = '';
  late String churchName;
  String setPhoneMessage = 'Set this as your default Number';
  late String phoneNumber;
  TextEditingController myController  = TextEditingController()..text = '0771220022';
  String formattedAmount = '';
  bool checkboxValue = false;
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String fontFamily = 'Montserrat-Medium';
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mobile Money')
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(60),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Enter Mobile Number', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 40,),
                Row(
                  children: [Text('+256'),
                    SizedBox(width: 10,),
                    Expanded(
                      child:
                      TextField(
                        maxLength: 9,
                        controller: myController,
                        mouseCursor: MouseCursor.defer,
                        onChanged: (value){

                          setState(() {
                            if (value.split('')[0] == '7'){
                              invalidMessageDisplay = 'Incomplete Number';
                              if (value.length == 9 && value.split('')[0] == '7'){
                                changeNumberOpacity = 1.0;
                                phoneNumber = value;
                                phoneNumber.split('0');
                                print(value.split('')[0]);
                                print(phoneNumber.split(''));
                                changeInvalidMessageOpacity = 0.0;
                              } else if(value.length !=9 || value.split('')[0] != '7'){
                                changeInvalidMessageOpacity = 1.0;
                                changeNumberOpacity = 0.0;
                              }

                            }else {
                              invalidMessageDisplay = 'Number should start with 7';
                              changeInvalidMessageOpacity = 1.0;
                            }
                          });
                        }
                        ,keyboardType: TextInputType.number ,decoration:
                      InputDecoration(filled: true,
                        fillColor: Colors.white, labelText: 'Mobile Number',
                        border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),),
                    ),],
                ),
                //SizedBox(height: 10,),
                Opacity(opacity:changeInvalidMessageOpacity, child: Text(invalidMessageDisplay, style: TextStyle(color: Colors.red),)),
                Opacity(
                    opacity: changeNumberOpacity,
                    child: Center(
                      child: Row(
                        children: [
                          Checkbox(value: checkboxValue, onChanged: (value) async{
                            final prefs = await SharedPreferences.getInstance();
                            print(value);
                            setState(() {
                              checkboxValue = value!;
                              prefs.setString(kPhoneNumberConstant, phoneNumber);
                            });
                          }),
                          Text(setPhoneMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: kGreenThemeColor), ),
                        ],
                      ),
                    )),
                //SizedBox(height: 5,),

                Text("$name you are making a payment for order $orderId of UGX $formattedAmount", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15,color: kBlueDarkColor, fontWeight: FontWeight.normal)),
                SizedBox(height: 30,),
                ingredientButtons(buttonTextColor:Colors.white,buttonColor: Colors.green,lineIconFirstButton: LineIcons.cashRegister, firstButtonFunction: ()async{
                  showModalBottomSheet(context: context, builder: (context) => Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: PaymentProcessing(),
                  ));

                  String number = '256$phoneNumber';
                  amountToCharge = (int.parse(amount)).toString();
                  dynamic resp = await callableBeyonicPayment.call(<String, dynamic>{
                    'number': number,
                    'amount':amountToCharge,
                    'transId': transactionId
                    // orderId
                  });
                  transactionStream();
                  addMobileMoneyTransaction();
                  final prefs = await SharedPreferences.getInstance();
                  //prefs.setString(kChurchTransactionIdConstant, transactionId);
                  print('+256$phoneNumber message sent');
                  // Create a document in the Transactions Db
                }, firstButtonText: 'Make Payment'),
                SizedBox(height: 10,),
                Opacity(
                    opacity: 0.5,
                    child: Image.asset('images/mobilemoney.png', height: 100, width: 100, ))
              ],
            ),
          ),

        ),
      ),

    );
  }
}
