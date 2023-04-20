

import 'package:flutter/material.dart';

import 'constants.dart';
import 'font_constants.dart';





class InputFieldWidgetEditInfo extends StatelessWidget {
  InputFieldWidgetEditInfo({required this.hintText, required this.onTypingFunction, required this.keyboardType, required this.labelText , this.passwordType = false, this.controller= '', this.leftPadding = 20,  this.rightPadding = 20, this.ringColor = kFontGreyColor, this.hintTextColor = Colors.grey, this.labelTextColor = Colors.grey, required this.onFinishedTypingFunction,  this.readOnlyVariable = false  });
  final String hintText;
  final Color hintTextColor;
  final Color labelTextColor;
  final void Function(String) onTypingFunction;
  final void Function() onFinishedTypingFunction;
  final TextInputType keyboardType;
  final String labelText;
  final bool passwordType;
  final bool readOnlyVariable;
  final String controller;
  final double leftPadding;
  final double rightPadding;
  final Color ringColor;



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(

        // width: 20,
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),

        child: TextFormField(

          validator: (value){

            if (value == ""){
              return 'This field needs to be filled';
            } else {
              return null;
            }
          },
          readOnly: readOnlyVariable,


          onEditingComplete: onFinishedTypingFunction,
          obscureText: passwordType,
          keyboardType: keyboardType,
          maxLines: 1,
          onChanged: onTypingFunction,
          textAlign: TextAlign.center,
          style: kNormalTextStyle ,
          //keyboardType: TextInputType.number,
          controller: TextEditingController()..text = controller,
          decoration: InputDecoration(

            hintText: "",// hintText
            filled: true,
            border: InputBorder.none,
            fillColor: kPureWhiteColor,


            hintStyle: TextStyle(fontSize: 14, color: hintTextColor),
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            // border: const OutlineInputBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: ringColor, width: 1.0),
            //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
            // ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kGreenThemeColor),
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.green, width: 0),
            //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
            // ),
          ),
        ),
      ),
    );
  }
}

