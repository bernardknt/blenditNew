import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sleek_circular_slider/sleek_circular_slider.dart';






var cardAspectRatio = 12.0/16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;


class MemoriesPage extends StatefulWidget {
  static String id = 'projects_page';

  @override
  _MemoriesPageState createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    userIdentifier = prefs.getString(kUniqueIdentifier) ?? 'Nutri';
    churchName =  prefs.getString(kFirstNameConstant)??"Hi";

    setState(() {

    });
  }
  Future<dynamic> getEvents() async {
    print("TITITIITITITITITITIT");
    final prefs = await SharedPreferences.getInstance();
    final transactions = await FirebaseFirestore.instance
        .collection('chat')
        .where('userId', isEqualTo: userIdentifier)
        .where('photo', isEqualTo: true)
        // .where('winning', isEqualTo: true)
        .orderBy("time", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //String formatter = DateFormat('yMd').format(doc['date']);
        if (doc['winning'] == true){
          descList.add(doc['message']);
          imgList.add(doc['image']);
          titleList.add(doc['country']);
          amountList.add(doc['message']);
          date.add(doc['time'].toDate());
          receivedAmount.add("20000");
        } else {

        }


        //print(churchId);
      });

      if (imgList.length == 0){
        // Navigator.pushNamed(context, EmptyEvent.id);
      }else{
        setState(() {
          print('THE CHURCH LENGTH is ${imgList.length}');
          currentPage = imgList.length - 0.0;
        });
      }
    });
    print(userIdentifier);
    print(descList);
    print(titleList);
    return transactions;
  }
  String userIdentifier = "";
  String churchName = 'Oneministry';
  var currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
    getEvents();
  }
  var descList = [];
  var date = [];
  var imgList = [];
  var amountList = [];
  var titleList = [];
  var receivedAmount = [];
  // Currency ugxCurrency = Currency.create('ugx',0, symbol: 'Ugx ', pattern: '#,###,000');

  @override


  Widget build(BuildContext context) {
    int projectNumber = imgList.length;

    PageController controller = PageController(initialPage: imgList.length - 0);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Memories'),
        backgroundColor: kBlueDarkColor,
      ),
      backgroundColor: kBlueDarkColor,
      // Color(0xFF2d3447),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 20,),
            // Row(
            //
            //   children: [
            //     SizedBox(width: 20,),
            //     Text('Current', style: TextStyle(
            //         color: Colors.white, fontSize: 30,
            //         letterSpacing: 1.0,
            //         fontFamily: 'CalibriBold'
            //     ),),
            //   ],
            // ),
            // SizedBox(height: 10,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:12.0, bottom: 12.0  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                    decoration: BoxDecoration(
                        color: kGreenThemeColor,
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: GestureDetector(
                        onTap: (){
                          print(churchName);
                        },
                        child: Text('$churchName', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontFamily: 'CalibriBold', fontSize: 12),)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:12.0, bottom: 12.0  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      //color: kPurpleThemeColor,
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Text('+$projectNumber Photos of You Winning', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold,),),
                  ),
                ),
              ],
            ),
            Stack(

              children: [
                CardScrollWidget(currentPage: currentPage,imgList: imgList, dateList: date, amountList: amountList),
                //CardScrollWidget(currentPage: currentPage, ),
                Positioned.fill(child:
                PageView.builder(
                  itemCount: imgList.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index){
                    return GestureDetector(
                    // THIS IS VERY IMPORTANT CODE THAT WORKS
                    //   onTap: (){
                    //     print(descList[index]);
                    //     showDialog(context: context, builder: (BuildContext context)
                    //     {
                    //       return CupertinoAlertDialog(
                    //         title: Text('${CommonFunctions().changeTheDate(date)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:kGreenThemeColor),),
                    //         content: Column(
                    //           children: [
                    //             Text(descList[index], textAlign: TextAlign.justify,),
                    //             TextButton(onPressed: (){
                    //               Navigator.pop(context);
                    //               // moneyDialogueBox(context, kOffertoryColor, titleList[index]);
                    //
                    //             }, child:
                    //             Column(
                    //               children: [
                    //                 SizedBox(height: 10,),
                    //                 SleekCircularSlider(
                    //                   appearance: CircularSliderAppearance(
                    //                       customWidths: CustomSliderWidths(progressBarWidth: 4)),
                    //                   min: 0,
                    //                   max: 100,
                    //                   initialValue: (receivedAmount[index]/int.parse(amountList[index]))*100,
                    //                 ),
                    //                 //Text('${Money.fromInt(receivedAmount[index], ugxCurrency)} received of ${Money.fromInt(int.parse(amountList[index]), ugxCurrency)}', textAlign: TextAlign.center,),
                    //                 SizedBox(height: 10,),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(left:12.0, bottom: 12.0  ),
                    //                   child: Container(
                    //                     padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                    //                     decoration: BoxDecoration(
                    //                         color: Colors.yellow,
                    //                         borderRadius: BorderRadius.circular(20.0)
                    //                     ),
                    //                     child: Text('Support Cause', style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold,),),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ))
                    //
                    //           ],
                    //         ),
                    //
                    //       );
                    //     });
                    //   },
                    );
                    //Container();
                  },
                )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.arrowCircleLeft, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text('Swipe Left and Right', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontFamily: 'CalibriBold'),),
                  SizedBox(width: 10,),
                  Icon(FontAwesomeIcons.arrowCircleRight, color: Colors.white,),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  CardScrollWidget({this.currentPage, required this.imgList, required this.dateList, required this.amountList, });
  var currentPage;
  final List imgList;
  final List dateList;
  final List amountList;
  var padding = 20.0;
  var verticalInset = 20.0;
  // Currency ugxCurrency = Currency.create('ugx',0, symbol: 'Ugx ', pattern: '#,###,000');



  @override
  Widget build(BuildContext context ) {

    return AspectRatio(aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints){
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          var safeWidth = width - 2 *  padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;
          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;
          List<Widget>cardList = [];

          for (var i = 0; i < imgList.length; i++){
            var delta = i - currentPage;
            bool isOnRight = delta > 0;
            var start = padding + max(primaryCardLeft - horizontalInset* -delta *(isOnRight? 15: 1),
                0.0 );
            var cardItem = Positioned.directional(
              top: padding +verticalInset * max(-delta, 0.0),
              bottom: padding + verticalInset * max(-delta, 0.0),
              start: start,
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color:Colors.black12,
                            offset: Offset(3.0, 6.0),
                            blurRadius: 10.0)

                      ]
                  ),
                  child: AspectRatio(
                    aspectRatio: cardAspectRatio ,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                    //     image: DecorationImage(
                    // image:
                    // NetworkImage(image[index]),
                    // CachedNetworkImageProvider(photoImage[index]),
                        CachedNetworkImage(imageUrl: imgList[i], fit: BoxFit.cover,),
                        // FadeInImage.assetNetwork(placeholder: 'images/whitefood.gif',
                        //   image:CachedNetworkImageProvider(imgList[i])
                        //   imgList[i],

                          // fit: BoxFit.cover,),
                        //Image.asset(imgList[i], fit: BoxFit.cover,),
                        Align(alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, bottom: 12.0  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    child: Text(amountList[i], style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold,),),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal:16.0, vertical: 2.0 ),
                                  child: Text(CommonFunctions().changeTheDate(dateList[i]),
                                      style:
                                      TextStyle(color: Colors.white,
                                      fontSize: 14.0, fontFamily:'CalibriBold',
                                      shadows: [
                                        BoxShadow(color:Colors.black,
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0
                                        )
                                      ])),
                                ),


                              ],
                            ),
                          ),)
                      ],
                    ) ,
                  ),
                ),
              ),
            );
            cardList.add(cardItem);
          }
          return GestureDetector(
            behavior: HitTestBehavior.translucent,

            onTap: (){print('Ok');},
            child: Stack(
              children:
              cardList,
            ),
          );


        },
      ),);
  }

}