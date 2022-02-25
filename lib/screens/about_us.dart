
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/paymentButtons.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUsPage extends StatefulWidget {
  static String id = 'about_page';

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String churchName = 'Blendit';

  String imageUrl = 'images/avocado.png';
  String heading = '';
  String body = '';
  String phoneNumber = '';


  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      heading = prefs.getString(kAboutHeading)!;
      body = prefs.getString(kAboutBody)!;
      phoneNumber = prefs.getString(kSupportNumber)!;



    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xFF17183c),
      body:
      CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background:Image.asset('images/avocado.png', fit: BoxFit.cover),
                  //.network(churchUrl, fit: BoxFit.cover,),
              title:  Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.all(2),
                  height: 25,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(25)),
                  child: const Text('100 ingredients in Your Pocket', textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 10,color: Colors.white),)),
              centerTitle: true ,

            ),
            backgroundColor: Colors.teal ,),
          SliverFixedExtentList(delegate:
          SliverChildListDelegate([

            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text(heading, textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 17,color: Colors.white),),
                  SizedBox(height: 10,),


                  Container(
                    child: Text(body, textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),

                  paymentButtons(lineIconSecondButton: Icons.blender,lineIconFirstButton: Icons.cancel,continueFunction: (){Navigator.pop(context);}, continueBuyingText: 'Back', checkOutText: 'Go Home', buyFunction: (){
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  })
                ],
              ),
            ),



          ]),
              itemExtent: 650)
        ],
      ),
    );
  }
}
