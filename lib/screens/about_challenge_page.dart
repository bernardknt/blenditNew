
import 'package:blendit_2022/utilities/font_constants.dart';
import'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';
import '../utilities/paymentButtons.dart';

class AboutChallengePage extends StatefulWidget {
  static String id = 'about_page';
  String churchName = '';
  String headPastor = '';
  String aboutChurch ='';
  String churchUrl = '';
  String churchPhoneNumber= '';

  @override
  _AboutChallengePageState createState() => _AboutChallengePageState();
}

class _AboutChallengePageState extends State<AboutChallengePage> {
  String churchName = '';
  String headPastor = '';
  String churchAbout ='';
  String churchUrl = '';


  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();

    // String newChurch = prefs.getString(kChurchNameConstant) ?? 'Oneministry';
    // String newImageUrl = prefs.getString(kChurchImageConstant);
    // String newAbout =  prefs.getString(kChurchAboutConstant);
    // String newPastor =  prefs.getString(kChurchPastorConstant);
    // String newPhoneNumber = prefs.getString(kChurchPhoneNumber);

    // setState(() {
    //   churchName = newChurch;
    //   churchUrl = newImageUrl;
    //   headPastor = newPastor;
    //   churchAbout = newAbout;
    //   churchPhoneNumber = newPhoneNumber;
    //
    // });
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
              background:Image.asset('images/page2.png', fit: BoxFit.cover,),
              title:  Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(2),
                  height: 25,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                  child: Center(
                    child: Text('Three day Detox Challenge ', textAlign: TextAlign.center,
                      style: kNormalTextStyle.copyWith(color: Colors.white, fontSize: 10),),
                  )),
              centerTitle: true ,

            ),
            backgroundColor:kBlueDarkColor ,),
          SliverFixedExtentList(delegate:
          SliverChildListDelegate([

            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 15),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text('About $churchName', textAlign: TextAlign.center,
                    style:kBannersFontNormal,),
                  SizedBox(height: 10,),


                  Container(
                    child: Text(churchAbout, textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),

                  Row(
                    children: [
                      Expanded(
                        flex:2,
                        child:
    Text('Phone:', textAlign: TextAlign.center,
                        // paymentButtons(buttonColor: kPurpleThemeColor, buttonHeight: 35, title: 'Call',
                        //     onPressedFunction: () async {
                        //       // Navigator.pushNamed(context, EventsPage.id);
                        //       launch('tel://+${churchPhoneNumber}');



                            ),),
                      Expanded(
                        flex:5,
                        child:
                        Text('Phone:', textAlign: TextAlign.center,
                          // paymentButtons(buttonColor: kPurpleThemeColor, buttonHeight: 35, title: 'Call',
                          //     onPressedFunction: () async {
                          //       // Navigator.pushNamed(context, EventsPage.id);
                          //       launch('tel://+${churchPhoneNumber}');



                        ),),

                    ],
                  )
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
