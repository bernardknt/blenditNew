
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/models/ingredientsList.dart';
import 'package:blendit_2022/models/quatityButton.dart';
import 'package:blendit_2022/models/salad_ingredient_list.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';
import 'package:blendit_2022/widgets/SelectedIngredientsListView.dart';
import 'package:blendit_2022/widgets/SelectedSaladIngredientsListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'loyalty_page.dart';
import 'onboarding_page.dart';

class SaladBlenderPage extends StatefulWidget {
  static String id  = 'newblendersalad';

  @override
  _SaladBlenderPageState createState() => _SaladBlenderPageState();
}
class _SaladBlenderPageState extends State<SaladBlenderPage> {
  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFirstNameConstant) ?? 'Hi';
    String newFullName = prefs.getString(kFullNameConstant) ?? 'Hi';
    bool isFirstTime = prefs.getBool(kIsFirstTimeUser) ?? false;
    bool isFirstTimeBlending = prefs.getBool(kIsFirstBlending)?? true;
    setState(() {
      firstName = newName;
      Provider.of<BlenditData>(context, listen: false).setCustomerName(newFullName);
      firstBlend = isFirstTimeBlending;

    });

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
    defaultsInitiation();
    getIngredients();

  }


  Future<dynamic> getIngredients() async {
    vegetables = [];
    fruits = [];
    extras = [];
    vegInfo = [];
    fruitInfo = [];
    extraInfo = [];

    final availableIngredients = await FirebaseFirestore.instance
        .collection('proteins')
        .orderBy('name',descending: false)
    // .where('quantity', isGreaterThan: 0)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['category']== 'vegetables'){
          vegetables.add(doc['name']);
          vegInfo.add(doc['info']);


        } else if(doc['category']== 'meat'){
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
    var fruitProvider = Provider.of<BlenditData>(context).boxColourSaladListMeat;
    var vegProvider = Provider.of<BlenditData>(context).boxColourSaladListLeaves;
    var extraProvider = Provider.of<BlenditData>(context).boxColourSaladListExtra;
    return Scaffold(
      backgroundColor: kBiegeThemeColor ,
      floatingActionButton: FloatingActionButton.extended(

        backgroundColor: blendedData.saladButtonColour,
        onPressed: (){

          if(Provider.of<BlenditData>(context, listen: false).saladIngredientsNumber == 0){
            AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');

          }
          else {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SelectedSaladIngredientsListView();
                });
          }
        },
        icon: const Icon(LineIcons.blender),
        label: const Text('Mix Salad'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(

              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Make your salad $firstName', textAlign:TextAlign.center , style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 18
                  ),),
                  const SizedBox(height: 10,),
                  ingredientButtons(
                    buttonTextColor: Colors.white,
                    buttonColor: blendedData.saladIngredientsButtonColour,
                      firstButtonFunction: (){
                        showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            color: const Color(0xFF6e7069),
                            child:
                            Container(
                              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),color: kPinkBlenderColor,),
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                          radius: 12,
                                          child: Icon(Icons.arrow_back, size: 12, color: Colors.white,)),
                                      const SizedBox(width: 10,),
                                      Text('Selected Ingredients ${Provider.of<BlenditData>(context).saladIngredientsNumber}', style: TextStyle(fontWeight: FontWeight.bold),),
                                      const SizedBox(width: 10,),
                                      const CircleAvatar(
                                          radius: 12,
                                          child: Icon(Icons.arrow_forward, size: 12, color: Colors.white,)),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Text('Ingredients 🥬',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  const SizedBox(height: 10,),
                                  SaladIngredientList(ingredients: vegetables, boxColors: boxColours, provider: vegProvider, type: 'veggie', info: vegInfo,),
                                  const SizedBox(height: 10,),
                                  Text('Meat and Toppings 🥩',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  const SizedBox(height: 10,),
                                  SaladIngredientList(ingredients: fruits, boxColors: boxColours, provider: fruitProvider, type: 'fruit', info: fruitInfo,),
                                  const SizedBox(height: 10,),
                                  Text('Add-ons 🍇'
                                    ,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                                  const SizedBox(height: 10,),
                                  SaladIngredientList(ingredients: extras, boxColors: boxColours, provider: extraProvider, type: 'extra', info: extraInfo,),
                                  const SizedBox(height: 20),
                                ingredientButtons(buttonTextColor: Colors.white, buttonColor: Colors.green, buttonTextSize: 12, lineIconFirstButton: LineIcons.thumbsUp, firstButtonFunction: (){Navigator.pop(context); }, firstButtonText: 'Done (Ugx${formatter.format(blendedData.saladPrice)})')],
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
              padding: const EdgeInsets.only(left: 20, right: 10),
              child:
              Stack(children:[
                GestureDetector(
                    onTap: (){
                      if(Provider.of<BlenditData>(context, listen: false).saladIngredientsNumber == 0){
                        AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');
                      }
                      else {
                        //Vibration.vibrate(pattern: [200, 500, 200]);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SelectedSaladIngredientsListView();
                            });
                      }
                    },
                    child: Image.asset('images/salads.png')),
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
                              child: Text('${blendedData.saladIngredientsNumber}',style: TextStyle(color: Colors.white, fontSize: 15),)),
                          //SizedBox(width: 5,),
                          const FaIcon(LineIcons.cookieBite, color: Colors.black,size: 25,),

                        ] ),
                    onTap: (){
                      if(Provider.of<BlenditData>(context, listen: false).saladIngredientsNumber == 0){
                        AlertPopUpDialogue(context, imagePath: 'images/addItems.json', title: 'No ingredients Added', text: 'Add some ingredients into your blender');
                      }
                      else {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SelectedSaladIngredientsListView();
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
                        'Qty (Salad Plates)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          QuantityBtn(onTapFunction: (){
                            Provider.of<BlenditData>(context, listen: false).decreaseSaladQty();

                          }, text: '-', size: 28,),
                          const SizedBox(width: 3,),
                          Text('${blendedData.saladQty}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(width: 3,),
                          QuantityBtn(onTapFunction: (){
                            Provider.of<BlenditData>(context, listen: false).increaseSaladQty();
                          }, text: '+',size: 28),
                        ],
                      ),
                      const SizedBox(height: 10,) ,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Ugx ${formatter.format(blendedData.saladPrice)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          SizedBox(height: 50,),


                          GestureDetector
                            (onTap: (){
                              Navigator.pushNamed(context, SaladsPage.id);
                          },
                              child: Lottie.asset('images/salad.json', width: 70),
                          ),
                          const Text('  Ready\n'
                              ' Made',textAlign: TextAlign.center
                            , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
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

