
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.imgList,
    required this.titleList,
    required this.width,
    required this.descList,
    required this.index,
    required this.priceList

  }) : super(key: key);
  final List<int> priceList;
  final int index;
  final List<String> imgList;
  final List<String> titleList;
  final double width;
  final List<String> descList;

  @override

  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###,000');
    return Card(
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              width: 100,
              height: 100,
              child: FadeInImage.assetNetwork(placeholder: 'images/loading.gif', image: imgList[index],
                width: 100,
                height: 100,
                fit: BoxFit.fill,)
          ),
          Padding(padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleList[index],
                  maxLines: 3,
                  style: TextStyle(fontSize: 14,
                      color: kBlueDarkColor,
                      fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  width: width,
                  child: Text(descList[index],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),),
                ),
                SizedBox(height: 10,),
                Text('Ugx ${formatter.format(priceList[index])}',
                  maxLines: 3,
                  style: TextStyle(fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),),
              ],
            ),),
        ],
      ),
    );
  }
}

