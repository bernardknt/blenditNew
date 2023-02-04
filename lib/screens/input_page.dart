import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/widgets/InputFieldWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
var newuuid = Uuid();




class InputPage extends StatefulWidget {
  static String id = 'input_page';
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _random = Random();
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  // CollectionReference communication = FirebaseFirestore.instance.collection('communication');
  CollectionReference aiMessage = FirebaseFirestore.instance.collection('lunch');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference ingredients = FirebaseFirestore.instance.collection('ingredients');
  CollectionReference saladIngredients = FirebaseFirestore.instance.collection('proteins');

  Future<void> addItem() {
    // Call the user's CollectionReference to add a new user
    return items.doc(itemId)
        .set({
      'category': 'plans', // John Doe
      'description': body, // Stokes and Sons
      'name': title,
      'price': price,
      'quantity': 10,
      'image': images[_random.nextInt(images.length)],
      'id': itemId,
      'promote': false
    })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }
  // Future<void> addCommunication() {
  //   // Call the user's CollectionReference to add a new user
  //   return communication.doc(communicationId)
  //       .set({
  //     'title': title, // John Doe
  //     'body': body,
  //
  //     // Stokes and Sons
  //
  //   })
  //       .then((value) => print("Communication Sent"))
  //       .catchError((error) => print("Failed to send Communication: $error"));
  // }

  Future<void> addAiMessage() {
    // Call the user's CollectionReference to add a new user
    return aiMessage.doc(communicationId)
        .set({
      'title': title, // John Doe
      'body': body,
      'message': message,
      'sent': false

      // Stokes and Sons

    })
        .then((value) => print("Communication Sent"))
        .catchError((error) => print("Failed to send Communication: $error"));
  }
  Future<void> addIngredient() {
    // Call the user's CollectionReference to add a new user
    return ingredients.doc(itemId)
        .set({
      'category': 'vegetables', // John Doe
     // 'description': description, // Stokes and Sons
      'name': title,
     // 'price': price,
      'quantity': 10,
      'info':'',
     // 'image': images[_random.nextInt(images.length)],
      'id': itemId,
    })
        .then((value) => print("Ingredient Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }

  Future<void> addCategories() {
    // Call the user's CollectionReference to add a new user
    return categories.doc(itemId)
        .set({
      'name': title, // John Doe
      'id': itemId, // Stokes and Sons
    })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }

  Future<void> addSaladIngredient() {
    // Call the user's CollectionReference to add a new user
    return saladIngredients.doc(itemId)
        .set({
      'category': 'vegetables', // John Doe
      // 'description': description, // Stokes and Sons
      'name': title,
      // 'price': price,
      'quantity': 10,
      'info':'',
      'price': 1000,
      // 'image': images[_random.nextInt(images.length)],
      'id': itemId,
    })
        .then((value) => print("Ingredient Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }

  @override
  var images = ['https://bit.ly/3ealgAb', 'https://bit.ly/3kllKHh',
    'https://bit.ly/3ievsbQ',
    'https://bit.ly/3ealgAb'];
  String itemId = 'cat${newuuid.v1().split("-")[0]}';
  String communicationId = 'aiMessage${newuuid.v1().split("-")[0]}';
  String body= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String message = '';
  String title = '';
  int price = 0;


  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  late String countryCode;


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Dummy Data'),
        backgroundColor: Colors.black,),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0),

        child: SingleChildScrollView(
          child: Container(
            height: 550,

            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child:
                  Center(child: Image.asset('images/fruits.png',)),
                ),

                //Text('SIGN UP', style: TextStyle(color: Colors.black54, fontSize: 30),),
                SizedBox(height: 10.0,),
                Opacity(
                    opacity: changeInvalidMessageOpacity,
                    child: Text(invalidMessageDisplay, style: TextStyle(color:Colors.red , fontSize: 12),)),
                InputFieldWidget(labelText:' Title' ,hintText: 'This is the title', keyboardType: TextInputType.text, onTypingFunction: (value){
                  title = value;

                },),
                // InputFieldWidget(labelText: 'Price', hintText: '20000', keyboardType: TextInputType.number,  onTypingFunction: (value){
                //
                //   price = int.parse(value);
                // }),
                SizedBox(height: 10.0,),
                InputFieldWidget(labelText: 'Body', hintText: 'Additional Information', keyboardType: TextInputType.text, onTypingFunction: (value){
                  body = value;
                }),
                SizedBox(height: 8.0,),
                InputFieldWidget(labelText: ' Password',hintText:'Ai Message', keyboardType: TextInputType.text,passwordType: false, onTypingFunction: (value){
                  message = value;}),

                //SizedBox(height: 8.0,),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: RoundedLoadingButton(
                        color: Colors.green,
                        child: Text('Send Communication', style: TextStyle(color: Colors.white)),
                        controller: _btnController,
                        onPressed: () async {
                          if ( title == ''){
                            _btnController.error();
                            showDialog(context: context, builder: (BuildContext context){

                              return CupertinoAlertDialog(
                                title: Text('Oops Something is Missing'),
                                content: Text('Make sure you have filled in all the fields'),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      _btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'))],
                              );
                            });
                          }else {
                            addAiMessage();
                            // addCategories();
                            //addSaladIngredient();
                            // addItem();
                          // addItem();
                          // addItem();
                            Navigator.pushNamed(context, ControlPage.id);
                            //Implement registration functionality.
                          }

                        },
                      ),
                    ),
                    Opacity(
                        opacity: errorMessageOpacity,
                        child: Text(errorMessage, style: TextStyle(color: Colors.red),))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
