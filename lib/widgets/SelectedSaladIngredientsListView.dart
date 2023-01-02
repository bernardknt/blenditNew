import 'package:blendit_2022/models/basketItem.dart';
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/checkout_page.dart';
import 'package:blendit_2022/screens/loading_ingredients_page.dart';
import 'package:blendit_2022/utilities/constants.dart';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';




class SelectedSaladIngredientsListView extends StatelessWidget {

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
                colors: [kBlueDarkColor, Colors.deepOrangeAccent] ),
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
                      label: Text('${blendedData.saladQty}Plates at Ugx ${blendedData.saladPrice}', style: TextStyle(fontWeight: FontWeight.bold,
                          color: kBlueDarkColor), ), ),
                  )),
              Positioned(
                child:
                ListView.builder(
                    itemCount: blendedData.saladIngredientsNumber,
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: Text(blendedData.selectedSaladIngredients[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        trailing: Checkbox(
                          activeColor: Colors.white,
                          checkColor: Color(0xFF0d1206),
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            blendedData.deleteSaladIngredient(blendedData.selectedSaladIngredients[index]);
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
                    child:
                    TextButton.icon(onPressed: ()async{
                      // Vibration.vibrate(
                      //   pattern: [500, 1000, 500, 1000],
                      // );
                      Navigator.pushNamed(context, LoadingIngredientsPage.id);
                      Provider.of<BlenditData>(context, listen: false)
                          .addToBasket(BasketItem(amount: blendedData.refSaladPrice, quantity: blendedData.saladQty, name: 'Custom Salad', details: blendedData.selectedSaladIngredients.join(", "))); //
                      Provider.of<BlenditData>(context, listen: false).clearListSalad();

                      //print(date);
                    },
                      style: TextButton.styleFrom(
                        //elevation: ,
                          shadowColor: kBlueDarkColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)
                          ),
                          backgroundColor: Color(0xFFF2efe4)),icon: Icon(LineIcons.leaf, color: kBlueDarkColor,),
                      label: Text('Mix Salad', style: TextStyle(fontWeight: FontWeight.bold,
                          color: kBlueDarkColor), ), ),
                  )),
              // Color(0xFFF2efe4)

            ]
        ),
      ),
    );
  }
}

