
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/delivery_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';
import 'package:blendit_2022/utilities/paymentProcessing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
var uuid = Uuid();

class PhoneDetailsPage extends StatefulWidget {
  static String id = 'phoneDetails_page';


  @override
  _PhoneDetailsPageState createState() => _PhoneDetailsPageState();
}

class _PhoneDetailsPageState extends State<PhoneDetailsPage> {
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


  // THESE ARE FIRESTORE COLLECTION REFERENCES


  // FIREBASE FIRESTORE FUNCTION TO ADD DOCUMENT

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
      backgroundColor: kBiegeThemeColor,

      body: SingleChildScrollView(
        child: Container(
          decoration:
          BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBiegeThemeColor, kBiegeThemeColor] ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),  topLeft: Radius.circular(20)),
              color: Colors.green
          ),
          //color: kBiegeThemeColor,
          padding: EdgeInsets.all(30),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Change Number for Delivery', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kBlueDarkColor),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text('+256', style: TextStyle(fontWeight: FontWeight.bold, color: kBlueDarkColor),),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child:
                      TextField(
                        maxLength: 9,
                        controller: myController,
                        mouseCursor: MouseCursor.defer,
                        onChanged: (value) async {
                          var prefs = await SharedPreferences.getInstance();

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
                        fillColor: Colors.white,
                        // labelText: 'Mobile Number',
                        border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),),
                    ),],
                ),
                //SizedBox(height: 10,),
                Opacity(opacity:changeInvalidMessageOpacity, child: Text(invalidMessageDisplay, style: TextStyle(color: Colors.red),)),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Opacity(
                      opacity: changeNumberOpacity,
                      child: Row(
                        children: [
                          Checkbox(value: checkboxValue, onChanged: (value) async{
                            final prefs = await SharedPreferences.getInstance();
                            print(value);
                            prefs.setBool(kIsPhoneNumberSaved, true);
                            setState(() {
                              checkboxValue = value!;


                            });
                          }),
                          Text(setPhoneMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: kGreenThemeColor, fontWeight: FontWeight.bold), ),
                        ],
                      )),
                ),
                //SizedBox(height: 5,),

                ingredientButtons(buttonTextColor:Colors.white,buttonColor: kBlueDarkColor,lineIconFirstButton: LineIcons.thumbsUp, firstButtonFunction: ()async{
                  final prefs = await SharedPreferences.getInstance();
                  if (checkboxValue == false) {
                    // Set the value of the saved phone number to false
                    prefs.setBool(kIsPhoneNumberSaved, false);
                    prefs.setString(kPhoneNumberAlternative, phoneNumber);


                  } else {
                    prefs.setBool(kIsPhoneNumberSaved, true);
                    prefs.setString(kPhoneNumberConstant, phoneNumber);
                  }
                 Navigator.pop(context);
                 Navigator.pop(context);
                 Navigator.pushNamed(context, DeliveryPage.id);

                }, firstButtonText: ' Done'),

              ],
            ),
          ),

        ),
      ),

    );
  }
}
