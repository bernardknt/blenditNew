import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'constants.dart';



class ingredientButtons extends StatelessWidget {
  ingredientButtons({ required this.firstButtonFunction,
    required this.firstButtonText,
    this.lineIconFirstButton = LineIcons.shoppingBasket,
    this.buttonColor = kBiegeThemeColor, this.buttonTextColor = kBlueDarkColor, this.buttonTextSize = 16});

  final VoidCallback firstButtonFunction;
  final String firstButtonText;
  final IconData lineIconFirstButton;
  final Color buttonColor;
  final Color buttonTextColor;
  final double buttonTextSize;


  @override
  Widget build(BuildContext context) {
    return
      Container(


        child: TextButton.icon(onPressed: firstButtonFunction,
          style: TextButton.styleFrom(
            //elevation: ,
              shadowColor:  buttonTextColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)
              ),
              backgroundColor: buttonColor),icon: Icon(lineIconFirstButton, color: buttonTextColor,size: 16,),
          label: Text(firstButtonText, style: kNormalTextStyle.copyWith(
              color: buttonTextColor, fontSize: buttonTextSize ), ), ),
      );
  }
}