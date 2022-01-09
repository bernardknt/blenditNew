

import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';


class InputFieldWidget extends StatelessWidget {
  InputFieldWidget({required this.hintText, required this.onTypingFunction, required this.keyboardType, required this.labelText , this.passwordType = false});
  final String hintText;
  final void Function(String) onTypingFunction;
  final TextInputType keyboardType;
  final String labelText;
  final bool passwordType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        obscureText: passwordType,
        keyboardType: keyboardType,
        onChanged: onTypingFunction,
        textAlign: TextAlign.center,
        //keyboardType: TextInputType.number,

        decoration: InputDecoration(

          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[300]),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
          contentPadding:
          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreenJavasThemeColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreenJavasThemeColor, width: 0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
      ),
    );
  }
}

