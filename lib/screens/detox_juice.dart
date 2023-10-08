
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemCards.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DetoxJuicePage extends StatefulWidget {
  static String id = 'detox_juice_page';

  @override
  _DetoxJuicePageState createState() => _DetoxJuicePageState();
}


class _DetoxJuicePageState extends State<DetoxJuicePage> {


  Future<dynamic> getDetoxJuices() async {
    descList = [];
    imgList = [];
    titleList = [];
    priceList = [];
    final detoxJuices = await FirebaseFirestore.instance
        .collection('items')
        .where('category', isEqualTo: 'detox-juice')
        .where('available', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {

        descList.add(doc['description']);
        imgList.add(doc['image']);
        titleList.add(doc['name']);
        priceList.add(doc['price']);

      });
      if (imgList.length == 0){
        Navigator.pop(context);
        print('No Juices found');
      }else{
        setState(() {
          print('THE Detox LENGTH is ${imgList.length}');
        });
      }
    });
    return detoxJuices;

  }

  // OVERRIDE INITIAL STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetoxJuices();


  }

  // Variables

  var descList = ['Lemon, Cactus, Ginger', 'Lemon, Cactus, Beetroot, Bitter Gourd', 'Lemon, Cactus, Cayenne'];
  var imgList = [
    'https://bit.ly/3kllKHh',
    'https://bit.ly/3ievsbQ',
    'https://bit.ly/3ealgAb',];
  var titleList = ['Ginger Blast', 'Bitter Green detox',  'Hot Lemon Cleanser'];
  var priceList = [12000, 15000, 13000];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Juice and Smoothies'),
        backgroundColor: kBlueDarkColor,
      ),
      body:

      ListView.builder(

          itemCount: imgList.length,
          itemBuilder: (context, index){
            return
              GestureDetector(
              onTap: (){
                showDialogFunc(context, imgList[index], titleList[index], descList[index], priceList[index]);

              },
              child: ItemCard(imgList: imgList, titleList: titleList, width: width, descList: descList, index: index, priceList: priceList,),

            );
          }),
    );
  }
}

