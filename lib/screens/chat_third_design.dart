
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
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/blendit_data.dart';
import 'delivery_page.dart';
import 'new_settings.dart';






class ChatThirdDesignedPage extends StatefulWidget {
  static String id = 'three_orders_page';

  @override
  _ChatThirdDesignedPageState createState() => _ChatThirdDesignedPageState();
}

class _ChatThirdDesignedPageState extends State<ChatThirdDesignedPage> {
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
              clipBehavior: Clip.antiAlias,
              // minLines: 2,
              // expands: true,

              decoration: InputDecoration(
                hintText: 'Type your message here',
                fillColor: kPureWhiteColor,
                filled: true,


                // icon: GestureDetector(
                //   onTap: () {
                //     // setState(() {
                //     //   _isRecording = !_isRecording;
                //     // });
                //     print('Button Pressed');
                //   },
                //   child: CircleAvatar(
                //       backgroundColor: kBlueDarkColor,
                //       child: Icon(Icons.camera_alt_rounded, size: 24,color: kPureWhiteColor,)),
                // ),
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


            Text('Nutri-Partner', style: kNormalTextStyle.copyWith(color: kBlack),),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info, color:kGreenThemeColor,),
            onPressed: () {

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: kBlack,
                  title: Text('About Nutri', textAlign:TextAlign.center,style: kHeadingTextStyle.copyWith(color: kPureWhiteColor),),
                  content:
                  Container(
                    height: 270,
                    color: kBlack,
                    child: Column(
                      children: [
                        Text('Nutri is an Artificial Intelligence powered assistant that learns your personal nutritional attributes as you interract with it.'
                            ' For best results please enter your information as accurately as possible. Also feel free to ask questions you may have about your health and nutrition.'
                            ' An easy example is "Can I have matooke for super?" or "I want to lose weight, what should I do?" or "Give me a recipe for a healthy breakfast".'
                            ' Some answers may not be as accurate but usually helpful to keep you on track to achieve your goals', style: kNormalTextStyleDark.copyWith(color: kPureWhiteColor, fontSize: 14),textAlign: TextAlign.justify,),
                        CloseButton(
                          color: kAppPinkColor,
                        )
                      ],
                    ),
                  ),

                ),
              );


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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot> (
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 110.0),
                        child:  ListView.builder(
                            itemCount: messageList.length,
                            reverse: true,
                            itemBuilder: (context, index){
                              return
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Card(

                                      // margin: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 10.0),
                                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                      shadowColor: kGreenThemeColor,
                                      // color: kBeigeColor,
                                      elevation: 2.0,
                                      child: Container(
                                        width: 260,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [

                                                  Text( '${DateFormat('EE, dd - HH:mm').format(dateList[index])}',textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 10, color: kFaintGrey)),
                                                  kSmallWidthSpacing,
                                                  statusList[index]
                                                ],
                                              ),
                                              Text( "${messageList[index]}",textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(fontSize: 14, color: kBlueDarkColor)),





                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                                    ),
                                    kSmallHeightSpacing,
                                    responseList[index] == ''? Center(child: Lottie.asset('images/assistant.json', width: 50)) :Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 25,
                                              child: ClipOval(

                                                  child: Image.asset('images/bot.png', fit: BoxFit.contain,))),
                                          Stack(
                                            children: [
                                              Card(
                                                color: kCustomColor,
                                                shadowColor: kPureWhiteColor,

                                                elevation: 4,
                                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),


                                                  child: Padding(
                                                    padding: const EdgeInsets.all(18.0),
                                                    child: Container(
                                                        width: 260,
                                                        child: Text('${responseList[index]}',textAlign: TextAlign.left, style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 14, fontWeight: FontWeight.w400),)),
                                                  )),
                                              Positioned(
                                                top: 20,
                                                right: 20,
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: paidStatusListColor[index],
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: GestureDetector(
                                                      onTap: (){

                                                        Share.share('${responseList[index]}', subject: 'Check this out from Nutri');

                                                      },

                                                      child: Icon(LineIcons.alternateShare, size: 15,color: kPureWhiteColor,)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );}
                        ),
                      );
                    }

                  }

              ),
            ),
            LowerTextForm()

          ])
  );
  }


}



