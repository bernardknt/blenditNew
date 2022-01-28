
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ChooseJuicePage extends StatefulWidget {
  static String id = 'choose_juice_page';

  const ChooseJuicePage({Key? key}) : super(key: key);

  @override
  _ChooseJuicePageState createState() => _ChooseJuicePageState();
}

class _ChooseJuicePageState extends State<ChooseJuicePage> {

  void defaultsInitiation () async{


    String newUs= Provider.of<BlenditData>(context, listen:false).speciality;
    String newId= Provider.of<BlenditData>(context, listen:false).specialityId;
    setState(() {
      title = newUs;
      specialityId = newId;

    });
  }
  // OVERRIDE INITIAL STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();

  }

  // Variables
  String title = 'Custom Juice';
  String specialityId = 'bernard';
  var date = [];

  var descList = [];
  var imgList = [];
  var categoryName = [];
  var appointmentId = [];
  var opacityList = [];
  var tokenList = [];
  var priceList = [];
  @override

  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: kBiegeThemeColor,
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: kBlueDarkColor,
        ),
        body:
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('items')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
              } else {

                descList = [];
                imgList = [];
                categoryName = [];
                appointmentId = [];
                priceList = [];

                var items = snapshot.data!.docs;
                for (var item in items) {

                  if (item.get('speciality').contains(specialityId)){
                    descList.add(item.get('description'));
                    imgList.add(item.get('image'));
                    categoryName.add(item.get('name'));
                    appointmentId.add(item.get('id'));
                    priceList.add(item.get('price'));
                  }
                  else{
                  }
                }
              }
              return
                Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(

                    itemCount: imgList.length,
                    itemBuilder: (context, index){
                      return
                        GestureDetector(
                        onTap: (){
                         showDialogFunc(context, imgList[index], categoryName[index], descList[index], priceList[index]);
                        },
                        child:
                        Stack(
                            children: [
                              Card(
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: FadeInImage.assetNetwork(placeholder: 'images/loading.gif', image: imgList[index])
                                    ),
                                    Flexible(
                                      child: Padding(padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(categoryName[index],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 18,
                                                  color: kBlueDarkColor,
                                                  fontWeight: FontWeight.bold),),
                                            const SizedBox(height: 10,),
                                            const Text('Ingredients',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15,
                                                  color: kBlueDarkColor,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold),),
                                            const SizedBox(height: 5,),
                                            Text(descList[index],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 15,
                                                  color: kBlueDarkColor,
                                                  fontWeight: FontWeight.normal),),
                                            const SizedBox(height: 5,),

                                            const Text('BEST FOR:',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blueGrey,
                                              ),)
                                          ],
                                        ),),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Opacity(
                                    opacity: 1,
                                    //opacityList[index],
                                    child: Container(
                                      width: 100,
                                      height: 20,
                                      child: Center(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 12),)),
                                      decoration: const BoxDecoration(
                                          color: kGreenThemeColor,
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                    ),
                                  ))]),
                      );
                    }),
              );
            }
        )
    );
  }
}
