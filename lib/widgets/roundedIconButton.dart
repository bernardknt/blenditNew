
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';


class RoundedIconButtons extends StatelessWidget {
  const RoundedIconButtons({required this.networkImageToUse, required
  this.labelText,
  });

  final String networkImageToUse;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    return Column(
      children: [
        Container(

          width:  68,
          height: 68,
          decoration: BoxDecoration(
              shape: BoxShape.circle ,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kGreenThemeColor, kGreenJavasThemeColor] ),
              border: Border.all(
                  color: Color(0xFF212121),
                  width: 2
              )
          ),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Container(
              width: 65,
              height:  65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image:
                NetworkImage(networkImageToUse),fit: BoxFit.cover
                ),

              ),


            ),
          ),
        ),
        Text(labelText, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: textColor , fontSize: 14),),


      ],

    );
  }
}