
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemCards.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SaladsPage extends StatefulWidget {
  static String id = 'salads_page';

  @override
  _SaladsPageState createState() => _SaladsPageState();
}


class _SaladsPageState extends State<SaladsPage> {


  Future<dynamic> getSalads() async {
    descList = [];
    imgList = [];
    titleList = [];
    priceList = [];
    final Salads = await FirebaseFirestore.instance
        .collection('items')
        .where('category', isEqualTo: 'salads')
        .where('available', isEqualTo: true)
        //.where('quantity', isGreaterThan: 0)
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
    return Salads;
  }


  // OVERRIDE INITIAL STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSalads();
  }

  // Variables

  var descList = ['Detox is amazing', 'Detox is great', 'Detox is perfect', 'Detox is perfect'];
  var imgList = [
    'https://bit.ly/3e7J07S',
    'https://bit.ly/36vfVyS',
    'https://bit.ly/3hAKtpr',
    'https://bit.ly/3e7J07S'];
  var titleList = ['Chicken Salad', 'Fish Salad',  'Mushroom Salad', 'Beef Salad'];
  var priceList = [15000, 15000, 14000, 17000];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Salads'),
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
