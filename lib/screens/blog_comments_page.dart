
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/commentListWidget.dart';
import 'package:blendit_2022/widgets/roundedIconButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class ReadComments extends StatefulWidget {
  ReadComments({this.blogId = '1000',  this.cardColor = Colors.black,  this.imageUrl = 'https://bit.ly/36vfVyS', this.blogTitle = 'believe',  this.likes = '0',  this.blogSender = 'Blendit',  this.prayerRequests = 'Truth',  required this.comments, this.linkUrl = ''});
  static String id = 'read_comments';
  final String blogId;
  final Color cardColor;
  final String imageUrl;
  final String blogTitle;
  final String likes;
  final String blogSender;
  final String prayerRequests;
  final List comments;
  final String linkUrl;

  @override
  _ReadCommentsState createState() => _ReadCommentsState(blogId: blogId, cardColor: cardColor, imageUrl:imageUrl,
      blogTitle:blogTitle, likes:likes, blogSender:blogSender, blogPost:prayerRequests, comments: comments, linkUrl:linkUrl);
}


class _ReadCommentsState extends State<ReadComments> {
  String blogId;
  Color cardColor;
  String commentators = 'Its coming Soon please wont buy me a mercedesbenz coz my friends are alll buying porches  ';
  String imageUrl;
  String blogTitle;
  String likes;
  String blogSender;
  String blogPost;
  String linkUrl;

  List comments;
  var blogComment = [];
  var sender = [];
  var imageList = [];

  // comments variables


  DateTime now = DateTime.now();
  _ReadCommentsState({required this.blogId, required this.cardColor,required this.imageUrl,required this.blogTitle,required this.likes,required this.blogSender,required this.blogPost,required this.comments, required this.linkUrl});
  final _random = new Random();

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();

    // String churchImage = 'prefs.getString(kChurchImageConstant)' ;

    for(var i = 0; i < comments.length; i++ ){
      sender.add(comments[i]['sender']);
      blogComment.add(comments[i]['comment']);
      imageList.add(comments[i]['image']);

    }
    setState(() {
      name = prefs.getString(kFirstNameConstant)!;
      email = prefs.getString(kEmailConstant)!;
      print(sender);
      print(blogComment);
      print(imageList);
    });
  }

  Future<dynamic> getPrayers() async {

    final userPrayers = await FirebaseFirestore.instance
        .collection('prayers').where('id', isEqualTo: blogId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        prayerRequest = doc['prayer'];
        name = doc['sender'];
      });
    });
    setState(() {
    });
    return userPrayers ;
  }
  CollectionReference userPrayer = FirebaseFirestore.instance.collection('blogs');
  Future<void> addComment() {
    // Call the user's CollectionReference to add a new user
    return userPrayer.doc(blogId).update({
      "comments": FieldValue.arrayUnion([{
        'comment': newComment,
        'sender': name,
        'date': now,
        'id': email,
        'image':avatarImages[_random.nextInt(avatarImages.length)],
      }])
    })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }
  String email = '';
  var avatarImages = ['https://bit.ly/3y5EcY5',
    'https://bit.ly/3y5EcY5',
    'https://bit.ly/3x78fid',
    'https://bit.ly/361qOs5',
    'https://bit.ly/3qA3PxO',
    'https://bit.ly/3qCsba1',
    'https://gallery.mailchimp.com/f78a91485e657cda2c219f659/images/c31b90d6-56fe-4ad7-8c07-964a6b506f82.jpg',
    'https://gallery.mailchimp.com/f78a91485e657cda2c219f659/images/66ce49dd-ce35-4880-9984-8a569e59884e.jpg',
    'https://gallery.mailchimp.com/f78a91485e657cda2c219f659/images/ead4b508-876e-4d37-9a05-b95cec1811d9.jpg'];

  String prayerRequest = '';
  String name= 'Daphine';


  int itemNumber = 10;
  String newComment = '';

  animationTimer() {
    Timer _timer;
    _timer = new Timer(const Duration(milliseconds: 3000), () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
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
    Color pageColor = cardColor;
    return Scaffold(
        backgroundColor: Color(0xFF212121),
        appBar:AppBar(
          backgroundColor: pageColor,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(isScrollControlled: true, context: context, builder: (context) => Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                //color: Color(0xFF757575),
                child:  Container(
                  padding: EdgeInsets.only(top: 50, left:10, right: 10),
                  color: Color(0xFF212121),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),

                      TextField(
                        onChanged: (value){
                          newComment = value;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Share your Comment?',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon: Icon(CupertinoIcons.pencil, color: kGreenThemeColor,),
                          suffixIcon: Icon(CupertinoIcons.heart, color: kGreenThemeColor),
                          //enabled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kGreenThemeColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color:  kGreenThemeColor),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color:  kGreenThemeColor),
                          ),
                          //border: UnderlineInputBorder()

                        ),
                      ),
                      SizedBox(height: 30,),
                      FloatingActionButton(
                        onPressed: (){

                          if (newComment!=''){
                            addComment();
                            animationTimer();

                            showCupertinoModalPopup(context: context, builder: (context) => Container(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              //color: Color(0xFF757575),

                              child: Lottie.asset('images/success.json',
                                  height: 200),
                            ));


                          }else{
                            print('Too short');

                          }
                        },
                        backgroundColor: kGreenThemeColor,
                        child: Icon(CupertinoIcons.paperplane),
                      ),
                    ],
                  ),
                )
            ));
          },
          backgroundColor: pageColor,
          child: Icon(CupertinoIcons.pencil),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(

                      padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(color:pageColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start
                        ,
                        children: [
                          Row(
                            children: [

                              RoundedIconButtons(networkImageToUse: imageUrl, labelText: ''),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(blogSender, style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),),
                                  SizedBox(height: 3,),
                                  Text('20th July 2021', style: GoogleFonts.lato(color: Colors.grey[400], fontSize: 10),)
                                ],
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: (){

                              launch(linkUrl);

                            },
                            child: RichText(text: TextSpan(text: blogPost,
                                style: GoogleFonts.lato(fontSize: 16)),),
                          ),
                          SizedBox(height: 8,) ,
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(

                                  //height: 10,
                                  //color: Colors.yellow,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                        width: double.minPositive,
                                        decoration: BoxDecoration(

                                            color: Color(0xFF212121)
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child:
                                        Text(blogTitle,textAlign: TextAlign.center,style: GoogleFonts.lato(fontSize: 13,
                                            color: Colors.white),)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:5,
                                child: Container(


                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(likes, style: GoogleFonts.lato(color: Colors.white, fontSize: 12),),
                                      SizedBox(width: 4,),
                                      Icon(CupertinoIcons.heart, color: Colors.white,)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index){

                        return CommentListWidget(blogComment: blogComment[index], senderName: sender[index], imageUrl: imageList[index], cardColor: Colors.black,);


                    }),
              ),
            ]
        )
    );
  }
}

