import 'package:blendit_2022/models/basketItem.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/screens/loading_ingredients_page.dart';
import 'package:blendit_2022/utilities/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';




class SelectedJuiceIngredientsListView extends StatelessWidget {
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 300),
    const Duration(milliseconds: 500),
  ];
  @override
  Widget build(BuildContext context) {
    var blendedData = Provider.of<BlenditData>(context);
    return Container(
      color: Color(0xFF737373),
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBlueDarkColor, Colors.lightGreenAccent] ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),  topLeft: Radius.circular(20)),
            color: Colors.green
          ),

            padding: EdgeInsets.all(20),
            child: Stack(
              children : [
                Positioned(
                    bottom: -10,
                    right: 0,
                    left: 0,

                    child:
                    Center(
                      child: TextButton.icon(onPressed: ()async{
                        Navigator.pushNamed(context, CheckoutPage.id);
                        //print(date);
                      },
                        style: TextButton.styleFrom(
                          //elevation: ,
                            shadowColor: kBlueDarkColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                            backgroundColor: Color(0x00F2efe4)),icon: Icon(LineIcons.moneyBill, color: kBlueDarkColor,),
                        label: Text('${blendedData.litres}L at Ugx ${blendedData.juicePrice}', style: TextStyle(fontWeight: FontWeight.bold,
                            color: kBlueDarkColor), ), ),
                    )),
                Positioned(
                  child: ListView.builder(
                    itemCount: blendedData.ingredientsNumber,
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: Text(blendedData.selectedJuiceIngredients[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        trailing: Checkbox(
                          activeColor: Colors.white,
                          checkColor: Color(0xFF0d1206),
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            blendedData.deleteJuiceIngredient(blendedData.selectedJuiceIngredients[index]);
                          }, value: true,),
                      );
                    }),
                ),
                Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,

                    child:
                    Center(
                      child: TextButton.icon(onPressed: ()async{
                        // Vibration.vibrate(
                        //   pattern: [500, 1000, 500, 1000],
                        // );
                        Vibrate.vibrateWithPauses(pauses);
                        Navigator.pushNamed(context, LoadingIngredientsPage.id);
                        Provider.of<BlenditData>(context, listen: false)
                            .addToBasket(BasketItem(amount: blendedData.refJuicePrice, quantity: blendedData.litres, name: 'Custom Juice', details: blendedData.selectedJuiceIngredients.join(", "))); //
                        Provider.of<BlenditData>(context, listen: false).clearListJuice();

                        //print(date);
                      },
                        style: TextButton.styleFrom(
                          //elevation: ,
                            shadowColor: kBlueDarkColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                            backgroundColor: Color(0xFFF2efe4)),icon: Icon(LineIcons.wineBottle, color: kBlueDarkColor,),
                        label: Text('Blend It', style: TextStyle(fontWeight: FontWeight.bold,
                            color: kBlueDarkColor), ), ),
                    )),
                // Color(0xFFF2efe4)

            ]
            ),
        ),
    );
  }
}

