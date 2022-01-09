import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blendit_data.dart';


class IngredientsList extends StatelessWidget {
  IngredientsList({required this.ingredients, required this.boxColors, required this.provider, required this.type, required this.info,});

  final List<String> info;
  final List<String> ingredients;
  final List<Color> boxColors;
  final List<dynamic> provider;
  final String type;

  @override
  Widget build(BuildContext context) {
   // Color boxColor = Colors.white;
    var blendedData = Provider.of<BlenditData>(context);
    return SizedBox(
      height: 35.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ingredients.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){

                if (type == 'fruit' ){

                  Provider.of<BlenditData>(context, listen: false).changeBoxColorFruits(boxColors[index], index, ingredients[index]);
                }
                else if (type == 'veggie' ){

                  Provider.of<BlenditData>(context, listen: false).changeBoxColorVegetables(boxColors[index], index, ingredients[index]);
                }else{

                  Provider.of<BlenditData>(context, listen: false).changeBoxColorExtras(boxColors[index], index, ingredients[index]);
                }
              },
              onLongPress: (){

                showDialog(context: context, builder: (BuildContext context)
                {
                  return CupertinoAlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/blender_component.png', height: 25, width: 25,),
                        // SizedBox(width: 5,),
                        Text(ingredients[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    content: Text(info[index], textAlign: TextAlign.justify,),

                  );
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20 ),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:  provider[index]
                ),
                child: Text(
                    ingredients[index], textAlign: TextAlign.justify,style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }),
    );
  }
}

