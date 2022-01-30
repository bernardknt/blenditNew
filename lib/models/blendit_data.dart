
import 'package:blendit_2022/utilities/constants.dart';

import 'basketItem.dart';
import 'package:flutter/material.dart';


class BlenditData extends ChangeNotifier{


  // -----------------GENERAL VARIABLES-------------------------
  List<BasketItem> basketItems = [];
  String location = '';
  String deliveryInstructions = '';
  String chefInstructions = '';
  double locationOpacity = 0;
  late DateTime deliveryTime;
  String customerName = '';
  int totalPrice = 0;
  int basketNumber = 0;

  // -----------------JUICE VARIABLES-------------------------
  String speciality = "Weight Loss";
  String specialityId = "cat2a7d37e0";
  int litres = 1;
  int saladQty = 1;
  int juicePrice = 12000;
  int baseJuicePrice = 12000;
  int refJuicePrice = 12000;
  int ingredientsNumber = 0;
  List meats = []; // "Chicken","Fish","Mushrooms"
  List extras = []; //"Eggs","Vinaigrette"
  Color ingredientsButtonColour = Colors.green;
  List boxColourJuiceListVeg = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourJuiceListFruit = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourJuiceListExtra = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  Color boxColor = Colors.white;
  Color blendButtonColourJuice = Colors.grey.shade400;
  List selectedJuiceIngredients = [];
  String blenderImage = 'images/blenditclear.png';

  // -----------------SALAD  VARIABLES------------------------
  List boxColourSaladListExtra = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourSaladListMeat = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourSaladListLeaves = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List selectedSaladIngredients = [];
  Color saladButtonColour = Colors.grey.shade400;
  Color saladIngredientsButtonColour = Colors.green;
  int saladIngredientsNumber = 0;
  int saladPrice = 12000;
  int refSaladPrice = 12000;
  int baseSaladPrice = 12000;
  int saladExtrasPrice = 1000;
  int saladMeatPrice = 3000;
  int ordinaryItemQty = 1;
  int deliveryFee = 0;
  double distance = 0;
  int rewardPoints = 0;

  // -----------------GENERAL  FUNCTIONS------------------------

  void setRewardPoints (newRewardPoints){
    rewardPoints = newRewardPoints;
    notifyListeners();
  }

  void setDeliveryDateTime (newDeliveryTime){
    deliveryTime = newDeliveryTime;
    notifyListeners();
  }
  void setDeliveryDistance (newDistance){
    distance = newDistance;
    notifyListeners();
  }

  void setDeliveryFee (newDeliveryFee){
    deliveryFee = newDeliveryFee;
    notifyListeners();
  }

  void setChefInstructions(newChefInstructions){
    chefInstructions = newChefInstructions;
    notifyListeners();
  }
  void setDeliverInstructions(instruction){
    deliveryInstructions = instruction;
    notifyListeners();
  }
  void setLocation(String newlocation ){
    location = newlocation;
    locationOpacity = 1;
    notifyListeners();
  }
  void setCustomerName(String newCustomerName){
    customerName = newCustomerName;
    notifyListeners();
  }
  void updateBasketItem(BasketItem item, int newQuantity,String operand){
    if(item.quantity>1){
      if (operand == '-'){
        item.quantity = newQuantity - 1;
        totalPrice = totalPrice - (item.amount);
        notifyListeners();
      }else if (operand == '+'){
        item.quantity = newQuantity + 1;
        totalPrice = totalPrice + (item.amount);
        notifyListeners();
      }
    }else if (operand == '+'){
      item.quantity = newQuantity + 1;
      totalPrice = totalPrice + (item.amount);
      notifyListeners();
    }
  }

  void addToBasket(BasketItem item){
    basketItems.add(item);
    basketNumber = basketItems.length;
    totalPrice += item.amount * item.quantity;
    ordinaryItemQty = 1;
    notifyListeners();
  }
  void deleteItemFromBasket(BasketItem item){
    basketItems.remove(item);
    basketNumber = basketItems.length;
    totalPrice -= item.amount * item.quantity ;
    notifyListeners();
  }
  void clearBasket(){
    basketItems.clear();
    totalPrice = 0;
    basketNumber = 0;
    notifyListeners();

  }

  // -----------------SALAD  FUNCTIONS------------------------
  void setSaladDefaultPrice (blenderPrice){
    refSaladPrice = blenderPrice;
    saladPrice = blenderPrice;
    baseSaladPrice = blenderPrice;
    notifyListeners();
  }
  void changeSaladButtonColors(){
    if (saladIngredientsNumber == 0){
      saladButtonColour = Colors.grey.shade400;
      saladIngredientsButtonColour = Colors.green;
    }
    else{
      saladButtonColour = Colors.green;
      saladIngredientsButtonColour = Colors.grey.shade400;
    }
    notifyListeners();
  }
  void increasePriceSaladExtras (){
    refSaladPrice = refSaladPrice + saladExtrasPrice;
    saladPrice = refSaladPrice  * saladQty;
    notifyListeners();
  }
  void decreasePriceSaladExtras (){
    refSaladPrice = refSaladPrice - saladExtrasPrice;
    saladPrice = refSaladPrice  * saladQty;
    notifyListeners();
  }
  void increasePriceSaladMeats (){
    refSaladPrice = refSaladPrice + saladMeatPrice;
    saladPrice = refSaladPrice  * saladQty;

    notifyListeners();
  }

  void decreasePriceSaladMeats (){

    refSaladPrice = saladPrice - saladMeatPrice;
    saladPrice = refSaladPrice  * saladQty;
    notifyListeners();
  }
  void changeSaladBoxColorLeaves(Color selectedColor, int index, String ingredient){
    if (boxColourSaladListLeaves[index] == selectedColor){
      boxColourSaladListLeaves[index] = Colors.lightGreenAccent;
      addSaladIngredients(ingredient);
      numberOfSaladIngredients();
    }else{
      boxColourSaladListLeaves[index] = Colors.white;
      deleteSaladIngredient(ingredient);

    }
    notifyListeners();
  }
  void changeSaladBoxColorMeat(Color selectedColor, int index, String ingredient){
    if (boxColourSaladListMeat[index] == selectedColor){
      boxColourSaladListMeat[index] = Colors.orange;
      addSaladIngredients(ingredient);
      increasePriceSaladMeats();
      numberOfSaladIngredients();
    }else{
      boxColourSaladListMeat[index] = Colors.white;
      deleteSaladIngredient(ingredient);
      // decreasePriceSaladMeats();

    }
    notifyListeners();
  }
  void changeSaladBoxColorExtras(Color selectedColor, int index, String ingredient){
    if (boxColourSaladListExtra[index] == selectedColor){
      boxColourSaladListExtra[index] = kGreenJavasThemeColor;
      increasePriceSaladExtras();
      addSaladIngredients(ingredient);
      numberOfSaladIngredients();
    }else{
      boxColourSaladListExtra[index] = Colors.white;
      deleteSaladIngredient(ingredient);
      decreasePriceSaladExtras();
    }
    notifyListeners();
  }
  void addSaladIngredients(String addedIngredient){
    if(saladIngredientsNumber< 5){
      selectedSaladIngredients.add(addedIngredient);
      saladIngredientsNumber = selectedSaladIngredients.length;
      notifyListeners();
    }else {
      selectedSaladIngredients.add(addedIngredient);
      saladIngredientsNumber = selectedSaladIngredients.length;
      // refSaladPrice = refSaladPrice + 1000;
      // saladPrice = refSaladPrice  * saladQty;
      notifyListeners();
    }
  }

  void deleteSaladIngredient (ingredient){
    // if(saladIngredientsNumber< 6){
    if(meats.contains(ingredient)){
      selectedSaladIngredients.remove(ingredient);
      numberOfSaladIngredients();
      decreasePriceSaladMeats();
      notifyListeners();
      print(selectedSaladIngredients);
    }else if(extras.contains(ingredient)){
      selectedSaladIngredients.remove(ingredient);
      numberOfSaladIngredients();
      decreasePriceSaladExtras();
      notifyListeners();
      print(selectedSaladIngredients);
    }
    else{
      selectedSaladIngredients.remove(ingredient);
      numberOfSaladIngredients();
      notifyListeners();
      print(selectedSaladIngredients);
    }

    // }else {
    //   selectedJuiceIngredients.remove(ingredient);
    //   numberOfSaladIngredients();
    //   refSaladPrice = refSaladPrice - 1000;
    //   saladPrice = refSaladPrice  * saladQty;
    //   notifyListeners();
    // }
  }

  void numberOfSaladIngredients (){
    saladIngredientsNumber = selectedSaladIngredients.length;
    changeSaladButtonColors();
    notifyListeners();
  }

  void increaseSaladQty(){
    saladQty += 1;
    saladPrice = refSaladPrice * saladQty;
    notifyListeners();
  }
  void decreaseSaladQty(){
    if (saladQty > 1){
      saladQty -= 1;
      saladPrice = refSaladPrice * saladQty;
      notifyListeners();
    }
  }
  void clearListSalad (){
    for(var i = 0; i < boxColourSaladListLeaves.length; i++){
      boxColourSaladListLeaves[i] = Colors.white;
      boxColourSaladListMeat[i] = Colors.white;
      boxColourSaladListExtra[i] = Colors.white;
    }
    refSaladPrice = baseSaladPrice;
    saladPrice = baseSaladPrice;
    selectedSaladIngredients.clear();
    saladIngredientsNumber = selectedSaladIngredients.length;
    saladButtonColour = Colors.grey.shade400;
    saladIngredientsButtonColour = Colors.green;
    notifyListeners();
  }


  // -----------------BLENDER and JUICE FUNCTIONS------------------------
  // Change color of Image Juice and Set Default Prices and Color
  void setCustomJuiceSpeciality (id, name){
    speciality = name;
    specialityId = id;
    notifyListeners();
  }

  void changeImage(){
    if (selectedJuiceIngredients.length == 0){
      blenderImage = 'images/blenditclear.png';
      notifyListeners();
    }else{
      if(selectedJuiceIngredients.contains('Beetroot')){
        blenderImage = 'images/blenditred.png';
        notifyListeners();
      }else if (selectedJuiceIngredients.contains('Spinach')||selectedJuiceIngredients.contains('Collard Greens')||selectedJuiceIngredients.contains('Kale')||selectedJuiceIngredients.contains('Celery')||selectedJuiceIngredients.contains('Aloe vera')||selectedJuiceIngredients.contains('Cactus')||selectedJuiceIngredients.contains('Baby Spinach'))  {
        blenderImage = 'images/blenditgreen.png';
        notifyListeners();
      }else if (selectedJuiceIngredients.contains('Watermelon')){
        blenderImage = 'images/blenditpink.png';
      }else if(selectedJuiceIngredients.contains('Kitafeeri')||selectedJuiceIngredients.contains('Coconut')){
        blenderImage = 'images/blenditwhite.png';
      }else{
        blenderImage = 'images/blendityellow.png';
      }

    }
  }


  void setBlenderDefaultPrice (blenderPrice, saladDownloadedPrice, meatPrice, extrasPrice, meat, extra){
    // Setting the price for the Juices in the Blender
    // Setting the price for the Juices in the Blender
    refJuicePrice = blenderPrice;
    juicePrice = blenderPrice;
    baseJuicePrice = blenderPrice;
// Setting the price for the Salads in the Bowl
    refSaladPrice = saladDownloadedPrice;
    saladPrice = saladDownloadedPrice;
    baseSaladPrice = saladDownloadedPrice;
    // Setting the price for the Salad Extras and Meats in the Bowl
    saladMeatPrice = meatPrice;
    saladExtrasPrice = extrasPrice;
    // Setting the price for the Salads in the Bowl
    meats = meat;
    extras = extra;

    notifyListeners();
  }
  void changeJuiceButtonColors(){
    if (ingredientsNumber == 0){
      blendButtonColourJuice = Colors.grey.shade400;
      ingredientsButtonColour = Colors.green;
    }
    else{
      blendButtonColourJuice = Colors.green;
      ingredientsButtonColour = Colors.grey.shade400;
    }
    notifyListeners();
  }

  // Increase and decrease Item Quantity
  void increaseJuiceItemQty(){
    ordinaryItemQty += 1;
    notifyListeners();
  }
  void decreaseJuiceItemQty(){
    ordinaryItemQty -= 1;
    notifyListeners();
  }
  // End of Increase and decrease Item Quantity

// End of Increase and decrease Litres
  void increaseJuiceLitres(){
    litres += 1;
    juicePrice = refJuicePrice * litres;
    notifyListeners();
  }
  void decreaseJuiceLitres(){
    if (litres>1){
      litres -= 1;
      juicePrice = refJuicePrice * litres;
      notifyListeners();
    }
  }

  // Add and remove Ingredients
  void addIngredients(String addedIngredient){
    if(ingredientsNumber< 5){
      selectedJuiceIngredients.add(addedIngredient);
      ingredientsNumber = selectedJuiceIngredients.length;
      notifyListeners();
    }else {
      selectedJuiceIngredients.add(addedIngredient);
      ingredientsNumber = selectedJuiceIngredients.length;
      refJuicePrice = refJuicePrice + 1000;
      juicePrice = refJuicePrice  * litres;
      notifyListeners();
    }
  }

  void deleteJuiceIngredient (ingredient){
    if(ingredientsNumber< 6){
      selectedJuiceIngredients.remove(ingredient);
      numberOfJuiceIngredients();
      notifyListeners();
    }else {
      selectedJuiceIngredients.remove(ingredient);
      numberOfJuiceIngredients();
      refJuicePrice = refJuicePrice - 1000;
      juicePrice = refJuicePrice  * litres;
      notifyListeners();
    }
  }
  void numberOfJuiceIngredients (){
    ingredientsNumber = selectedJuiceIngredients.length;
    changeJuiceButtonColors();
    changeImage();
    notifyListeners();
  }
  // End add and remove ingredients

  // Change Colour of Ingredients Selected
  void changeBoxColorJuiceVegetables(Color selectedColor, int index, String ingredient){
    if (boxColourJuiceListVeg[index] == selectedColor){
      boxColourJuiceListVeg[index] = Colors.lightGreenAccent;
      addIngredients(ingredient);
      numberOfJuiceIngredients();
    }else{
      boxColourJuiceListVeg[index] = Colors.white;
      deleteJuiceIngredient(ingredient);
    }
    notifyListeners();
  }
  void changeBoxColorJuiceFruits(Color selectedColor, int index, String ingredient){
    if (boxColourJuiceListFruit[index] == selectedColor){
      boxColourJuiceListFruit[index] = Colors.orange;
      addIngredients(ingredient);
      numberOfJuiceIngredients();
    }else{
      boxColourJuiceListFruit[index] = Colors.white;
      deleteJuiceIngredient(ingredient);

    }
    notifyListeners();
  }
  void changeBoxColorJuiceExtras(Color selectedColor, int index, String ingredient){
    if (boxColourJuiceListExtra[index] == selectedColor){
      boxColourJuiceListExtra[index] = kGreenJavasThemeColor;
      addIngredients(ingredient);
      numberOfJuiceIngredients();
    }else{
      boxColourJuiceListExtra[index] = Colors.white;
      deleteJuiceIngredient(ingredient);
    }
    notifyListeners();
  }
  void clearListJuice (){
    for(var i = 0; i < boxColourJuiceListVeg.length; i++){
      boxColourJuiceListVeg[i] = Colors.white;
      boxColourJuiceListFruit[i] = Colors.white;
      boxColourJuiceListExtra[i] = Colors.white;
    }
    refJuicePrice = baseJuicePrice;
    juicePrice = baseJuicePrice;
    blenderImage = 'images/blenditclear.png';
    selectedJuiceIngredients.clear();
    ingredientsNumber = selectedJuiceIngredients.length;
    blendButtonColourJuice = Colors.grey.shade400;
    ingredientsButtonColour = Colors.green;
    notifyListeners();
  }

// ------------------END OF JUICE FUNCTIONS-----------------



  //__________________________SALADS BLEND DATA_________________________________________________
  // This changes the image of the blender when ingredients are being added




  //____________________________JUICE BLEND DATA________________________________

}


