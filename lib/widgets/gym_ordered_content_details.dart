
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';



class GymOrderedContentsWidget extends StatelessWidget {

  GymOrderedContentsWidget({required this.orderIndex, required this.quantity,
    //required this.productDescription,
    required this.productName, required this.price,  this.defaultFontSize = 15, required this.days});

  final String productName;
  final double defaultFontSize;
  //final String productDescription;
  final double quantity;
  final int orderIndex;
  final int days;
  final double price;


  var formatter = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    var numberOfFollowers = productName.length;
    return Container(
      //width: double.infinity,


      // margin: EdgeInsets.only(top: 16, left:16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18), //Color(0xFF212121)
      ),
      child: ListTile(
        leading: Text('$orderIndex', style: kNormalTextStyle,),
        subtitle: days!=1?Text('Access for $days days', style: kNormalTextStyle,):Text('Access for $days day', style: kNormalTextStyle,),

        title: Text('$productName x ${quantity.toInt()}', style:kHeading2TextStyleBold.copyWith(color: kBlack,fontSize: defaultFontSize) ,),
        // subtitle: Text('$productDescription', style:kHeading2TextStyleBold.copyWith(color: kFontGreyColor,fontSize: defaultFontSize) ,),
        trailing: Text('${formatter.format(price)} Ugx', style: kHeading2TextStyleBold.copyWith(color: kBlack,fontSize: defaultFontSize) ,),

      ),
    );
  }
}