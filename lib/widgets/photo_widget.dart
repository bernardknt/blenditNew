import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';


class LargeWidget extends StatelessWidget {

  //final IconData iconToUse;
  final String iconToUse;
  final Color iconColor;
  final Color widgetColor;
  final String footer;
  final Function onTapFunction;
  final double height;
  final double width;
  final double fontSize;

  const LargeWidget({Key? key, this.iconToUse = "bilungo.json",
    this.iconColor = kBlack,
    this.footer = "",
    required this.onTapFunction,
    this.widgetColor = Colors.transparent,
    this.height = 100,this.width = 150, required this.fontSize}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle icon click here
        onTapFunction();

        print('Icon clicked!');
      },
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: widgetColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: iconColor,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                height<=80? Container():
                    Lottie.asset("images/$iconToUse", height: 100),
                // Icon(
                //   iconToUse,
                //   size: 38,
                //   color: iconColor,
                // ),
                kSmallHeightSpacing,
                Text(footer,textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: iconColor, fontWeight: FontWeight.normal, fontSize: fontSize),)
              ],
            ),
          ),
          // kSmallHeightSpacing,

        ],
      ),
    );
  }
}