
import 'package:blendit_2022/utilities/constants.dart';

import 'basketItem.dart';
import 'package:flutter/material.dart';


class BlenditData extends ChangeNotifier{
  List<BasketItem> basketItems = [];
  String location = '';
  String deliveryInstructions = '';
  String chefInstructions = '';
  double locationOpacity = 0;
  late DateTime deliveryTime;
  String blenderImage = 'images/blenditclear.png';
  String customerName = '';
  int totalPrice = 0;
  int basketNumber = 0;
  List selectedIngredients = [];
  List boxColourListVeg = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourListFruit = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List boxColourListExtra = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  Color boxColor = Colors.white;
  Color blendButtonColour = Colors.grey.shade400;
  Color ingredientsButtonColour = Colors.green;
  String data = 'List Truth';
  int ingredientsNumber = 0;
  int litres = 1;
  int price = 12000;
  int refPrice = 12000;
  int basePrice = 12000;
  int ordinaryItemQty = 1;
  int deliveryFee = 0;
  double distance = 0;
  int rewardPoints = 0;


  void setBlenderDefaultPrice (blenderPrice){
    refPrice = blenderPrice;
    price = blenderPrice;
    basePrice = blenderPrice;
    notifyListeners();
  }
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
  void changeButtonColors(){
  if (ingredientsNumber == 0){
    blendButtonColour = Colors.grey.shade400;
    ingredientsButtonColour = Colors.green;
  }
  else{
    blendButtonColour = Colors.green;
    ingredientsButtonColour = Colors.grey.shade400;
  }
  notifyListeners();
  }

  void changeImage(){
    if (selectedIngredients.length == 0){
      blenderImage = 'images/blenditclear.png';
      notifyListeners();
    }else{
      if(selectedIngredients.contains('Beetroot')){
        blenderImage = 'images/blenditred.png';
        notifyListeners();
      }else if (selectedIngredients.contains('Spinach')||selectedIngredients.contains('Collard Greens')||selectedIngredients.contains('Kale')||selectedIngredients.contains('Celery')||selectedIngredients.contains('Aloe vera')||selectedIngredients.contains('Cactus')||selectedIngredients.contains('Baby Spinach'))  {
        blenderImage = 'images/blenditgreen.png';
        notifyListeners();
      }else if (selectedIngredients.contains('Watermelon')){
        blenderImage = 'images/blenditpink.png';
      }else if(selectedIngredients.contains('Kitafeeri')||selectedIngredients.contains('Coconut')){
        blenderImage = 'images/blenditwhite.png';
      }else{
        blenderImage = 'images/blendityellow.png';
      }

    }
  }

  void increaseItemQty(){
    ordinaryItemQty += 1;
    notifyListeners();
  }

  void decreaseItemQty(){
    ordinaryItemQty -= 1;
    notifyListeners();
  }


  void increaseLitres(){
    litres += 1;
    price = refPrice * litres;
    notifyListeners();
  }
  void decreaseLitres(){
    if (litres>1){
      litres -= 1;
      price = refPrice * litres;
      notifyListeners();
    }

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


  void addtoBasket(BasketItem item){
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

  void addIngredients(String addedIngredient){
    if(ingredientsNumber< 5){
      selectedIngredients.add(addedIngredient);
      ingredientsNumber = selectedIngredients.length;
      notifyListeners();
    }else {
      selectedIngredients.add(addedIngredient);
      ingredientsNumber = selectedIngredients.length;
      refPrice = refPrice + 1000;
      price = refPrice  * litres;
      notifyListeners();
    }
  }

  void deleteIngredient (ingredient){

    if(ingredientsNumber< 6){
      selectedIngredients.remove(ingredient);
      numberOfIngredients();
      notifyListeners();
    }else {
      selectedIngredients.remove(ingredient);
      numberOfIngredients();
      refPrice = refPrice - 1000;
      price = refPrice  * litres;
      notifyListeners();
    }
  }
  void numberOfIngredients (){
    ingredientsNumber = selectedIngredients.length;
    changeButtonColors();
    changeImage();
    notifyListeners();
  }

  void changeBoxColorVegetables(Color selectedColor, int index, String ingredient){
    if (boxColourListVeg[index] == selectedColor){
      boxColourListVeg[index] = Colors.lightGreenAccent;
      addIngredients(ingredient);
      numberOfIngredients();
    }else{
      boxColourListVeg[index] = Colors.white;
      deleteIngredient(ingredient);
    }
    notifyListeners();
  }


  void changeBoxColorFruits(Color selectedColor, int index, String ingredient){
    if (boxColourListFruit[index] == selectedColor){
      boxColourListFruit[index] = Colors.orange;
      addIngredients(ingredient);
      numberOfIngredients();
    }else{
      boxColourListFruit[index] = Colors.white;
      deleteIngredient(ingredient);

    }
    notifyListeners();
  }
  void changeBoxColorExtras(Color selectedColor, int index, String ingredient){
    if (boxColourListExtra[index] == selectedColor){
      boxColourListExtra[index] = kGreenJavasThemeColor;
      addIngredients(ingredient);
      numberOfIngredients();
    }else{
      boxColourListExtra[index] = Colors.white;
      deleteIngredient(ingredient);
    }
    notifyListeners();
  }

  void clearList (){
    for(var i = 0; i < boxColourListVeg.length; i++){
      boxColourListVeg[i] = Colors.white;
      boxColourListFruit[i] = Colors.white;
      boxColourListExtra[i] = Colors.white;
    }
    refPrice = basePrice;
    price = basePrice;
    blenderImage = 'images/blenditclear.png';
    selectedIngredients.clear();
    ingredientsNumber = selectedIngredients.length;
    blendButtonColour = Colors.grey.shade400;
    ingredientsButtonColour = Colors.green;
    notifyListeners();
  }
  void clearBasket(){
    basketItems.clear();
    totalPrice = 0;
    basketNumber = 0;
    notifyListeners();

  }
}


