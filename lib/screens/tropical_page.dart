
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemCards.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TropicalPage extends StatefulWidget {
  static String id = 'tropical_page';

  @override
  _TropicalPageState createState() => _TropicalPageState();
}

class _TropicalPageState extends State<TropicalPage> {

  Future<dynamic> getTropicalJuices() async {
    descList = [];
    imgList = [];
    titleList = [];
    priceList = [];
    final detoxJuices = await FirebaseFirestore.instance
        .collection('items')
        .where('category', isEqualTo: 'coctail-juice')
        .where('quantity', isGreaterThan: 0)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {

        descList.add(doc['description']);
        imgList.add(doc['image']);
        titleList.add(doc['name']);
        priceList.add(doc['price']);
      });
      // if (imgList.length == 0){
      //   Navigator.pop(context);
      //   print('No Juices found');
      // }else{
      //   setState(() {
      //     print('THE coctail-juice LENGTH is ${imgList.length}');
      //   });
      // }
    });
    return detoxJuices;
  }



  // OVERRIDE INITIAL STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTropicalJuices();

  }

  // Variables

  var descList = ['Detox is amazing', 'Detox is great', 'Detox is perfect', 'Detox is perfect'];
  var imgList = [
    'https://bit.ly/3x78fid',
    'https://bit.ly/361qOs5',
    'https://bit.ly/3qCsba1',
    'https://bit.ly/3qCsba1'];
  var titleList = ['Mango Pineapple Carrot Delight', 'Watermelon mint, beetroot',  'Coconut, Apple, Ginger', 'Lemon Pineapple Butternut'];
  var priceList = [12000, 12000, 12000, 12000];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tropical Juices'),
        backgroundColor: kBlueDarkColor,
      ),
      body:

      ListView.builder(

          itemCount: imgList.length,
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                showDialogFunc(context, imgList[index], titleList[index], descList[index], priceList[index]);

              },
              child: ItemCard(imgList: imgList, titleList: titleList, width: width, descList: descList, index: index, priceList: priceList,),
            );
          }),
    );
  }
}
