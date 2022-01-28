import 'package:blendit_2022/controllers/home_controller.dart';
import 'package:blendit_2022/widgets/InputFieldWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
var uuid = Uuid();




class InputPage extends StatefulWidget {
  static String id = 'input_page';
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _random = new Random();
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference ingredients = FirebaseFirestore.instance.collection('ingredients');
  CollectionReference saladIngredients = FirebaseFirestore.instance.collection('proteins');

  Future<void> addItem() {
    // Call the user's CollectionReference to add a new user
    return items.doc(itemId)
        .set({
      'category': 'plans', // John Doe
      'description': description, // Stokes and Sons
      'name': productName,
      'price': price,
      'quantity': 10,
      'image': images[_random.nextInt(images.length)],
      'id': itemId,
      'promote': false
    })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }
  Future<void> addIngredient() {
    // Call the user's CollectionReference to add a new user
    return ingredients.doc(itemId)
        .set({
      'category': 'vegetables', // John Doe
     // 'description': description, // Stokes and Sons
      'name': productName,
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
      'name': productName, // John Doe
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
      'name': productName,
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
  String itemId = 'cat${uuid.v1().split("-")[0]}';
  String description= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String password = '';
  String productName = '';
  int price = 0;


  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  late String countryCode;


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Sign Up'),
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
                InputFieldWidget(labelText:' Item Name' ,hintText: 'Chicken Salad', keyboardType: TextInputType.text, onTypingFunction: (value){
                  productName = value;

                },),
                InputFieldWidget(labelText: 'Price', hintText: '20000', keyboardType: TextInputType.number,  onTypingFunction: (value){

                  price = int.parse(value);
                }),
                SizedBox(height: 10.0,),
                InputFieldWidget(labelText: 'Description', hintText: 'Amazing Salad', keyboardType: TextInputType.text, onTypingFunction: (value){
                  description = value;
                }),
                // SizedBox(height: 8.0,),
                // InputFieldWidget(labelText: ' Password',hintText:'Password', keyboardType: TextInputType.visiblePassword,passwordType: true, onTypingFunction: (value){
                //   password = value;

                //SizedBox(height: 8.0,),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: RoundedLoadingButton(
                        color: Colors.green,
                        child: Text('Add New Ingredient', style: TextStyle(color: Colors.white)),
                        controller: _btnController,
                        onPressed: () async {
                          if ( productName == ''){
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
                            addCategories();
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
