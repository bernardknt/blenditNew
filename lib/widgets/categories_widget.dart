



import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Categories extends StatelessWidget {
  Categories({required this.categoriesNumber, required this.categories, required this.pageName});
  final int categoriesNumber;
  final List categories;
  final List<void Function()> pageName;

  @override

  var result = "1. Follow the daily meal plans provided. These meal plans have been specifically designed to help you safely and effectively gain weight."
      "\n2. Complete the daily workouts provided. These workouts will help you build muscle mass, which is important for gaining weight."
      "\n3. Drink at least 8 glasses of water per day. Staying hydrated is essential for overall health and can also help with weight gain."

      "\n4. Get at least 7-9 hours of sleep per night. Adequate sleep is important for recovery and muscle growth."

      "\n5. Avoid processed and sugary foods. These types of foods are high in empty calories and can lead to weight gain, but not in a healthy way."

      "\n6. Weigh yourself at the beginning and end of the challenge. This will help you track your progress and see how much weight you've gained."

      "\n7. Most importantly, be consistent and stay committed to the challenge. Gaining weight takes time and effort, but with dedication and hard work, you can achieve your goals";

  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 20), child: SizedBox(
      height: 35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoriesNumber,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: pageName[index],

              child: Container(

                padding: EdgeInsets.symmetric(horizontal: 4),
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                decoration:

                BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        // offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],

                    borderRadius: BorderRadius.circular(10),
                    color: Provider.of<AiProvider>(context).welcomeButtons[index]
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(categories[index], style: kNormalTextStyle.copyWith(color: Provider.of<AiProvider>(context).welcomeFontColors[index]),),
                        kSmallWidthSpacing,
                        Icon(Provider.of<AiProvider>(context).welcomeIcons[index], size: 14,)
                      ],
                    ),
                  ],

                ),
              ),

            );
          }),
    ),

    );
  }
}