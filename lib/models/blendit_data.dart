
import 'package:blendit_2022/models/location_model.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'basketItem.dart';
import 'package:flutter/material.dart';


class BlenditData extends ChangeNotifier{


  // -----------------GENERAL VARIABLES-------------------------
  String lastQuestion = '';
  String phoneVerificationId = '';
  List<LocationModal> locationValues = [];








  List<BasketItem> basketItems = [];
  String location = '';
  String providerId = "";
  String providerImage= "";
  String providerName= "";
  GeoPoint providerCoordinate  = GeoPoint(0, 0);
  String providerPhoneNumber = "";
  String deliveryInstructions = '';
  String chefInstructions = '';
  double locationOpacity = 0;
  late DateTime deliveryTime;
  String customerName = '';
  int totalPrice = 0;
  int basketNumber = 0;
  bool updateApp = true;
  int tabIndex = 0;
  String phoneNumber = '';
  String shareUrl = 'www.frutsexpress.com';
  Color loyaltyColor = kGreenThemeColor;
  String loyaltyValueInitial = "0";
  double loyaltyWarningOpacity = 0;
  Color loyaltyApplyButton = kGreenThemeColor;
  double loyaltyAccessButton = 1.0;
  bool storeOpen = true;
  bool loyaltyApplied = false;


  // -----------------JUICE VARIABLES-------------------------
  List juiceLeaves = []; // "Chicken","Fish","Mushrooms"
  List juiceExtras = []; //"Eggs","Vinaigrette"
  List juiceFruits = [];
  String speciality = "Weight Loss";
  String specialityId = "cat2a7d37e0";
  int litres = 1;
  int saladQty = 1;
  int juicePrice = 10000;
  int baseJuicePrice = 12000;
  int refJuicePrice = 12000;
  int ingredientsNumber = 0;
  //
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
  List meats = []; // "Chicken","Fish","Mushrooms"
  List extras = []; //"Eggs","Vinaigrette"
  List saladLeaves = [];

  // -----------------GENERAL  FUNCTIONS------------------------
  // Create a function to change the last question
  void setVerificationId(verify){

    phoneVerificationId = verify;
    notifyListeners();
  }

  void changeLastQuestion(String newQuestion){
    lastQuestion = newQuestion;
    notifyListeners();
  }

  void setStoreOpen(status){
    storeOpen = status;
    notifyListeners();
  }

  void setLoyaltyApplied(bool fact, double accessToLoyaty){
    loyaltyApplied = fact;
    loyaltyAccessButton = accessToLoyaty;
    notifyListeners();

  }
  void setLoyaltyInitialValue(String value, color, double opacity, Color buttonColor, double loyaltyAccessOpacityButton){
    loyaltyValueInitial = value;
    loyaltyColor = color;
    loyaltyWarningOpacity = opacity;
    loyaltyApplyButton = buttonColor;
    loyaltyAccessButton = loyaltyAccessOpacityButton;

    notifyListeners();
  }
  void setRemoveLoyaltyPoints(int points){
    totalPrice = totalPrice + points;
    notifyListeners();

  }
  void setPhoneNumber (newPhoneNumber){
    phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void setTabIndex (newTabIndex){
    tabIndex = newTabIndex;
    notifyListeners();
  }
  void setNewShareUrl (newShareUrl){
    shareUrl = newShareUrl;
    notifyListeners();
  }
  void setRewardPoints (newRewardPoints){
    rewardPoints = newRewardPoints;
    notifyListeners();
  }
  void setAppUpdateStatus(){
    updateApp = false;
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

  void setServiceProviderDetails(String phoneNumber, GeoPoint coordinates,id, image, name ){

    providerId = id;
    providerImage = image;
    providerName = name;
    providerPhoneNumber = phoneNumber;
    providerCoordinate = coordinates;

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
  void setSaladLeaves(saladLeafArray, saladMeatArray, saladExtrasArray){
    saladLeaves = saladLeafArray;
    meats = saladMeatArray;
    extras = saladExtrasArray;
    notifyListeners();
  }

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
      var position = meats.indexOf(ingredient); // Get the position of the ingredient in the meat array
      selectedSaladIngredients.remove(ingredient);
      boxColourSaladListMeat[position] = Colors.white; // This is

      // print the index value
      numberOfSaladIngredients();
      decreasePriceSaladMeats();
      notifyListeners();
    }else if(extras.contains(ingredient)){
      var position = extras.indexOf(ingredient);

      boxColourSaladListExtra[position] = Colors.white;
      selectedSaladIngredients.remove(ingredient);
      numberOfSaladIngredients();
      //decreasePriceSaladExtras();
      notifyListeners();
    }
    else{
      var position = saladLeaves.indexOf(ingredient);
      boxColourSaladListLeaves[position] = Colors.white;

      selectedSaladIngredients.remove(ingredient);
      numberOfSaladIngredients();
      notifyListeners();

    }
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

  void setJuiceLeaves(juiceLeafArray, juiceFruitArray, juiceExtrasArray){
    juiceLeaves = juiceLeafArray;
    juiceFruits = juiceFruitArray;
    juiceExtras = juiceExtrasArray;
    notifyListeners();
  }

  void setCustomJuiceSpeciality (id, name){
    speciality = name;
    specialityId = id;
    notifyListeners();
  }

  void changeImage(){
    if (selectedJuiceIngredients.isEmpty){
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

  void setLocationValues(LocationModal location){
    locationValues.add(location);
    notifyListeners();
  }


  void setBlenderDefaultPrice (blenderPrice, saladDownloadedPrice, meatPrice, extrasPrice){
    // Setting the price for the Juices in the Blender
    // Setting the price for the Juices in the Blender
    if (selectedJuiceIngredients.isEmpty && selectedSaladIngredients.isEmpty) {
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
    // meats = meat;
    // extras = extra;
    } else {
    }


    notifyListeners();
  }
  void changeJuiceButtonColors(){
    if (ingredientsNumber == 0){
      blendButtonColourJuice = Colors.grey.shade400;
      ingredientsButtonColour = Colors.green;
    }
    else{
      blendButtonColourJuice = kAppPinkColor;
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

  void setSelectedJuiceIngredients(arrayOfIngredients){
    selectedJuiceIngredients = arrayOfIngredients;
    if (arrayOfIngredients.length > 5){
      refJuicePrice = refJuicePrice + 2000;
    }
    notifyListeners();
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
      if(juiceLeaves.contains(ingredient)){
        var position = juiceLeaves.indexOf(ingredient); // Get the position of the ingredient in the meat array
        boxColourJuiceListVeg[position] = Colors.white;
        selectedJuiceIngredients.remove(ingredient);
        numberOfJuiceIngredients();
        notifyListeners();
      }else if (juiceExtras.contains(ingredient)){
        var position = juiceExtras.indexOf(ingredient); // Get the position of the ingredient in the meat array
        boxColourJuiceListExtra[position] = Colors.white;
        selectedJuiceIngredients.remove(ingredient);
        numberOfJuiceIngredients();
        notifyListeners();
      } else{
        var position = juiceFruits.indexOf(ingredient); // Get the position of the ingredient in the meat array
        boxColourJuiceListFruit[position] = Colors.white;
        selectedJuiceIngredients.remove(ingredient);
        numberOfJuiceIngredients();
        notifyListeners();
      }

    }else {
      if(juiceLeaves.contains(ingredient)){
        var position = juiceLeaves.indexOf(ingredient); // Get the position of the ingredient in the meat array
        boxColourJuiceListVeg[position] = Colors.white;
        selectedJuiceIngredients.remove(ingredient);
        numberOfJuiceIngredients();
        refJuicePrice = refJuicePrice - 1000;
        juicePrice = refJuicePrice  * litres;
        notifyListeners();
      }else if (juiceExtras.contains(ingredient)){
        var position = juiceExtras.indexOf(ingredient); // Get the position of the ingredient in the meat array
        boxColourJuiceListExtra[position] = Colors.white;
        selectedJuiceIngredients.remove(ingredient);
        numberOfJuiceIngredients();
        refJuicePrice = refJuicePrice - 1000;
        juicePrice = refJuicePrice  * litres;
        notifyListeners();
      } else{
        var position = juiceFruits.indexOf(ingredient); // Get the position of the ingredient in the meat array
        boxColourJuiceListFruit[position] = Colors.white;
        selectedJuiceIngredients.remove(ingredient);
        numberOfJuiceIngredients();
        refJuicePrice = refJuicePrice - 1000;
        juicePrice = refJuicePrice  * litres;
        notifyListeners();
      }
      // selectedJuiceIngredients.remove(ingredient);
      // numberOfJuiceIngredients();
      // refJuicePrice = refJuicePrice - 1000;
      // juicePrice = refJuicePrice  * litres;
      // notifyListeners();
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


