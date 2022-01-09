

import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemCards.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';

class AllProductsPage extends StatefulWidget {
  static String id = 'allProdcucts_page';

  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}


class _AllProductsPageState extends State<AllProductsPage> {


  Future<dynamic> getDetoxJuices() async {
    descList = [];
    imgList = [];
    titleList = [];
    priceList = [];
    final detoxJuices = await FirebaseFirestore.instance
        .collection('items')
        .where('quantity', isGreaterThan: 0)
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
        title: Text('All Products'),
        backgroundColor: kBlueDarkColor,
      ),
      body:
      SafeArea(
        child: Column(
          children: [
            
            Container(
              padding: EdgeInsets.all(10),
                child: searchBar()), 
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(

                  itemCount: imgList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        showDialogFunc(context, imgList[index], titleList[index], descList[index], priceList[index]);

                      },
                      child: ItemCard(imgList: imgList, titleList: titleList, width: width, descList: descList, index: index, priceList: priceList,),

                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
  TextField searchBar() {
    return TextField(
      onChanged: searchProducts,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding:EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: Icon(LineIcons.search),
          hintText: 'Chicken Salad'

      ),
    );
  }

  void searchProducts(String query) {
    final product = descList.where((element) {
      return false;
    });
  }
}


