import 'package:flutter/material.dart';

class Ingredient {
  Ingredient({required this.name, required this.isSelected, this.cardColor = Colors.white});
  final String name;
  bool isSelected;
  Color cardColor;
  void toggleSelected(){
   isSelected = !isSelected;
   if (cardColor == Colors.white){
     cardColor = Colors.green;
   }else {
     cardColor = Colors.white;
   }
 }
}