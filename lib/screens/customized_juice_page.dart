import 'package:blendit_2022/screens/detox_juice.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomizedJuicePage extends StatefulWidget {

  static String id = "CustomizedPage";
  @override
  _CustomizedJuicePageState createState() => _CustomizedJuicePageState();
}

class _CustomizedJuicePageState extends State<CustomizedJuicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,

      ),
      body:  SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Center(child: Text("What type of Juice do You want?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),)
            ),
            SizedBox(height: 20,),
            Container(
              child: Column(
                children: [
                  questionBlocks("Flu and Cough"),
                  questionBlocks("Weight Loss"),
                  questionBlocks( "Skin"),
                  questionBlocks( "Belly Fat"),
                  questionBlocks("Sweet and Refreshing"),

                ],
              ),
            )
          ],
        ),
      )
    );

  }

  Padding questionBlocks(String mainText) {
    // final String mainText;
    var randomColors = [Colors.teal, Colors.blueAccent, Colors.black12, Colors.deepPurpleAccent, Colors.white12];
    return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector (
                    onTap: (){
                      Navigator.pushNamed(context, DetoxJuicePage.id);
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
                        mainText,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)),

                    ),
                  ),
                );
  }
}
