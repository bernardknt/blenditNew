
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';

import '../utilities/constants.dart';


class InputFieldWidget2 extends StatelessWidget {
  InputFieldWidget2({required this.hintText, required this.onTypingFunction, required this.keyboardType, required this.labelText , this.passwordType = false, this.controller= '', this.leftPadding = 5, this.boxRadius = 15,this.fontColor = kBlack, required this.onTapFunction,
  });
  final String hintText;
  final void Function(String) onTypingFunction;
  final void Function() onTapFunction;
  final TextInputType keyboardType;
  final String labelText;
  final bool passwordType;
  final String controller;
  final double leftPadding;
  final double boxRadius;
  final Color fontColor;




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: leftPadding, bottom: 10),

      child: TextFormField(

        onTap: onTapFunction,
        obscureText: passwordType,
        keyboardType: keyboardType,
        maxLines: 1,
        onChanged: onTypingFunction,
        textAlign: TextAlign.center,
        style: kHeadingTextStyle.copyWith(color: fontColor),
        //keyboardType: TextInputType.number,
        controller: TextEditingController()..text = controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[300]),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
          contentPadding:
          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(boxRadius)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kButtonGreyColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(boxRadius)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  kAppPinkColor),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.green, width: 0),
          //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
          // ),
        ),
      ),
    );
  }
}

