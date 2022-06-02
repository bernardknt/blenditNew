import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/choose_juice_page.dart';
import 'package:blendit_2022/screens/detox_juice.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class CustomizedJuicePage extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _CustomizedJuicePageState createState() => _CustomizedJuicePageState();
}

class _CustomizedJuicePageState extends State<CustomizedJuicePage> {
  var categoryName = [];
  var categoryId = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,

      ),
      body:
      Stack(
        children :
        [
          Container(
            child: const Center(
              child: Text('What Category of Juice\n would You Like?',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),),
            height: 150,
            decoration: const BoxDecoration(
                color: kBlueDarkColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

          ),
          Padding(
            padding: const EdgeInsets.only(top: 110.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {} else {
                  categoryName = [];
                  categoryId = [];

                  var items = snapshot.data!.docs;
                  for (var item in items) {
                      categoryName.add(item.get('name'));
                      categoryId.add(item.get('id'));
                  }
                }
                return ListView.builder(
                    itemCount: categoryId.length,
                    itemBuilder: (context, index) {
                      return questionBlocks(categoryName[index],categoryId[index]);
                    });
              }),
          ),]
      )
    );
    }
  Padding questionBlocks(String speciality, String id) {
    var randomColors = [Colors.teal, Colors.blueAccent, Colors.black12, Colors.deepPurpleAccent, Colors.white12];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector (
        onTap: (){
          Provider.of<BlenditData>(context, listen: false).setCustomJuiceSpeciality(id, speciality);
          Navigator.pushNamed(context, ChooseJuicePage.id);
        },
        child: Container(
          // color: Colors.white,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color:  randomColors[4]
          ),
          child: Center(child: Text(
            speciality,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)),
        ),
      ),
    );
  }

  }



