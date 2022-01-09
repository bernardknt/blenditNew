
import 'package:flutter/material.dart';



class roundedButtons extends StatelessWidget {
  roundedButtons({ required this.buttonColor,  required this.title,required this.onPressedFunction, this.buttonHeight = 30,
    this.buttonWidth = double.infinity});
  final String title;
  final Color buttonColor;
  final double buttonHeight;
  final VoidCallback onPressedFunction;
  final double buttonWidth;


  @override
  Widget build(BuildContext context) {
    return Container(


        child: GestureDetector(
          //onTap: onPressedFunction,
          child: MaterialButton(
            onPressed: onPressedFunction,
            clipBehavior: Clip.none,
            child: Text(title ,
              style: TextStyle(color: Colors.white, fontSize: 16),),




          ),
        ),
        height: buttonHeight,
        width: buttonWidth,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(13),
        )
    );
  }
}