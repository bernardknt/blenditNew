import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';







class DesignedButton extends StatelessWidget {
  DesignedButton({ required this.continueFunction, required this.title, this.backgroundColor = kGreenThemeColor,  this.textColor = kPureWhiteColor, });

  final VoidCallback continueFunction;
  final String title;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: double.infinity,
        height: 45,
        child: TextButton(onPressed: continueFunction,
          style: TextButton.styleFrom(
            //elevation: ,
              shadowColor:  kBlueDarkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))
              ),
              backgroundColor: backgroundColor),
          child: Text(title, style: kNormalTextStyle.copyWith(color: textColor),), ),
      );
  }
}