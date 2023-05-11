
import 'package:blendit_2022/screens/settings_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/TicketDots.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';


import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/blendit_data.dart';
import 'delivery_page.dart';
import 'new_settings.dart';






class ChatDesignedPage extends StatefulWidget {
  static String id = 'online_orders_page';

  @override
  _ChatDesignedPageState createState() => _ChatDesignedPageState();
}

class _ChatDesignedPageState extends State<ChatDesignedPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  var formatter = NumberFormat('#,###,000');
  var phone = '';
  TextEditingController _textFieldController = TextEditingController();


  void defaultInitialization()async{
   final prefs = await SharedPreferences.getInstance();
   phone =  prefs.getString(kPhoneNumberConstant)!;
   setState(() {

   });
 }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();

  }

  var messageList = [];
  var messageStatusList = [];


  var responseList = [];
  var idList = [];
  var dateList = [];
  var statusList = [];
  var paidStatusListColor = [];
  var message = '';
  var lastQuestion = '';
  List<double> opacityList = [];

  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';
  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;
  // var blendedData = Provider.of<BlenditData>(context);
  String serviceId = '';
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');


  Future<void> uploadData() async {
    // Call the user's CollectionReference to add a new user
    // String dateOfAppointment = DateFormat('dd, MMMM, yyyy ').format(Provider.of<DoctorProvider>(context, listen: false).appointmentDate);
   var finalQuestion = lastQuestion;
    final prefs = await SharedPreferences.getInstance();
    print('WIWIIWIWIWIWIWIIW ${Provider.of<BlenditData>(context, listen: false).lastQuestion}');

    return chat.doc(serviceId)
        .set({

      'replied': false,
      'status' : true,
      'time':  DateTime.now(),
      'message': message,
      'response': '',
      'userId': prefs.getString(kPhoneNumberConstant),
      'weight': 70,
      'height': 165,
      'name': prefs.getString(kFullNameConstant),
      'token': prefs.getString(kToken),
      'id':serviceId,
      'lastQuestion': Provider.of<BlenditData>(context, listen: false).lastQuestion

      // Stokes and Sons

    })
        .then((value) => Provider.of<BlenditData>(context, listen: false).changeLastQuestion(finalQuestion) )
        .catchError((error) => print(error));
  }
  Positioned LowerTextForm() {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            TextField(
              controller: _textFieldController,  // _textFieldController is a TextEditingController object
              maxLines: 1,
              maxLength: 100,
              // minLines: 2,
              // expands: true,

              decoration: InputDecoration(
                hintText: 'Type your message here',
                fillColor: kPureWhiteColor,
                filled: true,

                iconColor: kPureWhiteColor,
                border:
                //InputBorder.none,
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                // shadowColor: Colors.green,
                // shadowRadius: 5,
                // shadowOffset: Offset(0, 2),
              ),

              // Clear the text field when the user submits the text
              onSubmitted: (value) {
                message = value;
                if (message != '') {
                  lastQuestion = message;
                  serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                  // Provider.of<BlenditData>(context, listen: false).changeLastQuestion(lastQuestion);
                  uploadData();
                  _textFieldController.clear();
                }
              },
              onChanged: (value) {

                message = value;
                // Store the text input in a variable
                // _inputText = value;
              },
            ),
            Positioned(
              right: 2,
              // bottom: 2,
              top: 5,
              child: IconButton(


                onPressed: () {
                  // Create a print statement to print the name variable


                  // Create a new function to navigate to the homepage

                  // Print the input text when the button is pessed
                  if(message != ''){

                    lastQuestion = message;

                    // Provider.of<BlenditData>(context, listen: false).changeLastQuestion(lastQuestion);
                    serviceId = '${DateTime.now().toString()}${uuid.v1().split("-")[0]}';
                    uploadData();
                    _textFieldController.clear();

                  }

                }, icon:  Icon(Icons.send, color: kBlueDarkColor,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Scaffold(
    backgroundColor: kGreyLightThemeColor,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kGreyLightThemeColor,
      title: Row(
        children: [
          Container(
              height: 35,
              child: ClipOval(

                  child: Image.asset('images/bot.png', fit: BoxFit.contain,))),
          kSmallWidthSpacing,


          Text('Nutri-Partner', style: kNormalTextStyle.copyWith(color: kGreenThemeColor),),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.info, color:kGreenThemeColor,),
          onPressed: () {

            Navigator.pushNamed(context, NewSettingsPage.id);
          },
        ),
        kSmallWidthSpacing,
        IconButton(
          icon: Icon(LineIcons.cog, color: kGreenThemeColor,),
          onPressed: () {
            Navigator.pushNamed(context, NewSettingsPage.id);
          },
        ),
        kSmallWidthSpacing,
      ],
    ),

      body:

      Stack(
        children: [
          StreamBuilder<QuerySnapshot> (
            stream: FirebaseFirestore.instance
                .collection('chat')
                 .where('userId', isEqualTo: phone)
                .orderBy('time',descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              if(!snapshot.hasData){
                return Container();
              }
              else{
                messageList = [];
                messageStatusList = [];

                responseList = [];
                idList = [];
                dateList = [];
                statusList = [];
                paidStatusListColor = [];
                opacityList = [];



                var orders = snapshot.data?.docs;
                for( var doc in orders!){


                    messageList.add(doc['message']);

                    responseList.add(doc['response']);
                    idList.add(doc['id']);
                    messageStatusList.add(doc['status']);
                    dateList.add(doc['time'].toDate());


                    if (doc['replied'] == true){
                      statusList.add(Icon(LineIcons.doubleCheck, size: 15,color: kGreenThemeColor,));
                      paidStatusListColor.add(Colors.blue);
                      opacityList.add(0.0);

                    } else {
                      statusList.add(Icon(LineIcons.check, size: 15,color: kFaintGrey,));
                      paidStatusListColor.add(Colors.grey);
                      opacityList.add(1.0);
                    }


                }
                // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
                return ListView.builder(
                    itemCount: messageList.length,
                    itemBuilder: (context, index){
                      return Card(

                        margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                        shadowColor: kGreenThemeColor,
                        // color: kBeigeColor,
                        elevation: 2.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text( '${DateFormat('EE, dd - HH:mm').format(dateList[index])}',textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 10, color: kFaintGrey)),
                                  kSmallWidthSpacing,
                                  statusList[index]
                                ],
                              ),
                            ),

                            ListTile(
                              leading: const Icon(Icons.ac_unit_sharp, color: kBlueDarkColor,size: 18,),
                              title:Text( "${messageList[index]}",textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 14, color: kBlueDarkColor)),

                            ),
                            TicketDots(mainColor: kGreyLightThemeColor,circleColor: kGreyLightThemeColor,),
                            responseList[index] == ''? Center(child: Lottie.asset('images/assistant.json', width: 50)) : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children:[
                                  Container(
                                      height: 50,
                                      child: ClipOval(

                                          child: Image.asset('images/bot.png', fit: BoxFit.contain,))),
                                  // Icon(CupertinoIcons.heart_fill, color: kGreenThemeColor,size: 18,),
                                Text('"${responseList[index]}"',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 14, fontWeight: FontWeight.w400),),

            ]

                              ),
                            ),
                          ],
                        ),
                      );}
                );
              }

            }

        ),
          LowerTextForm()

        ])
  );
  }


}



