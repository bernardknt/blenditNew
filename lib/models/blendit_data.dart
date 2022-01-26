
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
  int litres = 1;
  int juicePrice = 12000;
  int baseJuicePrice = 12000;
  int refJuicePrice = 12000;
  int ingredientsNumber = 0;
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
  List boxColourSaladListFruit = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourSaladListVeg = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List selectedSaladIngredients = [];
  Color saladButtonColour = Colors.grey.shade400;
  Color saladIngredientsButtonColour = Colors.green;
  int saladIngredientsNumber = 0;
  int saladPrice = 12000;
  int refSaladPrice = 12000;
  int baseSaladPrice = 12000;
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
  void changeSaladBoxColorVegetables(Color selectedColor, int index, String ingredient){
    if (boxColourSaladListVeg[index] == selectedColor){
      boxColourSaladListVeg[index] = Colors.lightGreenAccent;
      addSaladIngredients(ingredient);
      numberOfJuiceIngredients();
    }else{
      boxColourSaladListVeg[index] = Colors.white;
      deleteJuiceIngredient(ingredient);
    }
    notifyListeners();
  }
  void changeSaladBoxColorFruits(Color selectedColor, int index, String ingredient){
    if (boxColourSaladListFruit[index] == selectedColor){
      boxColourSaladListFruit[index] = Colors.orange;
      addSaladIngredients(ingredient);
      numberOfJuiceIngredients();
    }else{
      boxColourSaladListFruit[index] = Colors.white;
      deleteJuiceIngredient(ingredient);

    }
    notifyListeners();
  }
  void changeSaladBoxColorExtras(Color selectedColor, int index, String ingredient){
    if (boxColourJuiceListExtra[index] == selectedColor){
      boxColourJuiceListExtra[index] = kGreenJavasThemeColor;
      addSaladIngredients(ingredient);
      numberOfJuiceIngredients();
    }else{
      boxColourJuiceListExtra[index] = Colors.white;
      deleteJuiceIngredient(ingredient);
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
      refJuicePrice = refJuicePrice + 1000;
      juicePrice = refJuicePrice  * litres;
      notifyListeners();
    }
  }


  // -----------------BLENDER  FUNCTIONS------------------------
  // Change color of Image Juice and Set Default Prices and Color
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
  void setBlenderDefaultPrice (blenderPrice){
    refJuicePrice = blenderPrice;
    juicePrice = blenderPrice;
    baseJuicePrice = blenderPrice;
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


